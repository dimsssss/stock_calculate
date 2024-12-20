import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_calculate/input_model.dart';

class InputWidget extends StatefulWidget {
  final Function onDelete;
  final Function changeTotalPurchase;
  final Function changeTotalCount;
  final Function getRemainingStockCount;
  final Function getTotalPurchaseCount;
  final String id;
  final InputModel model;

  const InputWidget({
    super.key,
    required this.id,
    required this.onDelete,
    required this.changeTotalPurchase,
    required this.changeTotalCount,
    required this.getRemainingStockCount,
    required this.getTotalPurchaseCount,
    required this.model,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final priceTextEditController = TextEditingController();
  final countTextEditController = TextEditingController();
  final amountTextEditController = TextEditingController();
  Timer? countTextEditTimer;
  Timer? amountTextEditTimer;

  void applyChangedCount() {
    final newText = '${widget.model.count}';
    countTextEditController.value = countTextEditController.value.copyWith(
      text: newText,
      selection: TextSelection(
          baseOffset: newText.length, extentOffset: newText.length),
      composing: TextRange.empty,
    );
  }

  void applyChangedAmount() {
    final newText = '${widget.model.amount}';
    amountTextEditController.value = amountTextEditController.value.copyWith(
      text: newText,
      selection: TextSelection(
          baseOffset: newText.length, extentOffset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  void dispose() {
    countTextEditController.dispose();
    amountTextEditController.dispose();
    amountTextEditTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    priceTextEditController.text = '${widget.model.price}';
    countTextEditController.text = '${widget.model.count}';
    amountTextEditController.text = '${widget.model.amount}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 20,
          width: 90,
          child: TextField(
            controller: priceTextEditController,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  widget.model.changePrice(int.parse(value));
                } else {
                  widget.model.changePrice(0);
                }

                widget.model.changeAmount();
                applyChangedAmount();
                widget.changeTotalPurchase();
              });
            },
            maxLength: 10,
            style: const TextStyle(
              height: 1,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
              labelText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: 90,
          child: TextField(
            controller: countTextEditController,
            onChanged: (value) {
              if (countTextEditTimer != null && countTextEditTimer!.isActive) {
                return;
              }
              if (value.isEmpty) {
                // return lastCountValue = 0;
                return;
              }

              countTextEditTimer = Timer(const Duration(seconds: 2), () {
                final tmp = int.parse(countTextEditController.text);

                if (widget.model.count == tmp) {
                  return;
                }

                if (tmp == 0) {
                  widget.model.changeCount(tmp);
                  widget.changeTotalCount();
                  widget.model.changeAmount();

                  applyChangedCount();
                  applyChangedAmount();
                } else if (widget.getRemainingStockCount() +
                        widget.model.count >=
                    tmp) {
                  widget.model.changeCount(tmp);
                  widget.model.changeAmount();
                  widget.changeTotalCount();

                  applyChangedCount();
                  applyChangedAmount();
                } else {
                  widget.model.changeCount(
                      widget.getRemainingStockCount() + widget.model.count);

                  widget.changeTotalCount();
                  widget.model.changeAmount();

                  applyChangedCount();
                  applyChangedAmount();
                }

                setState(() {
                  widget.changeTotalCount();
                  widget.changeTotalPurchase();
                });
              });
            },
            maxLength: 10,
            style: const TextStyle(
              height: 1,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
              labelText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: 90,
          child: Center(
            child: TextField(
              controller: amountTextEditController,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                setState(() {
                  if (amountTextEditTimer != null &&
                      amountTextEditTimer!.isActive) {
                    return;
                  }
                  amountTextEditTimer = Timer(const Duration(seconds: 2), () {
                    int newAmount = int.parse(amountTextEditController.text);

                    if (newAmount < widget.model.price) {
                      return;
                    }
                    if (widget.getRemainingStockCount() + widget.model.count <
                        (newAmount / widget.model.price).floor()) {
                      widget.model.changeCount(
                          widget.getRemainingStockCount() + widget.model.count);
                      widget.model.changeAmount();
                    } else if (widget.getRemainingStockCount() +
                            widget.model.count >
                        (newAmount / widget.model.price).floor()) {
                      widget.model.changeCount(
                          (newAmount / widget.model.price).floor());
                      widget.model.changeAmount();
                    } else {
                      widget.model.setAmount(newAmount);
                    }

                    applyChangedCount();
                    applyChangedAmount();
                    widget.changeTotalCount();
                    widget.changeTotalPurchase();
                  });
                });
              },
              maxLength: 10,
              style: const TextStyle(
                height: 1,
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
                labelText: "",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              ),
            ),
          ),
        ),
        IconButton(
          iconSize: 20,
          padding: const EdgeInsets.only(bottom: 25),
          onPressed: () {
            widget.model.count = 0;
            widget.model.setAmount(0);
            widget.changeTotalCount();
            widget.changeTotalPurchase();
            widget.onDelete(widget.id);
          },
          icon: const Icon(
            Icons.highlight_remove_sharp,
          ),
        ),
      ],
    );
  }
}

class SalePriceModel {
  int count = 0;
  int price = 0;
  int amount = 0;

  void changeCount(int newCount) {
    count = newCount;
  }

  void changePrice(int newPrice) {
    price = newPrice;
  }

  void changeAmount() {
    amount = price * count;
  }

  void setAmount(int newAmount) {
    amount = newAmount;
  }

  void floorCountForAmount(int newAmount) {
    count = (newAmount / price).floor();
    amount = count * price;
  }
}
