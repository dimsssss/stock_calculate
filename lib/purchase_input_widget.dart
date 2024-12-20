import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_calculate/input_model.dart';

class PurchaseInputWidget extends StatefulWidget {
  final Function onDelete;
  final Function changeTotalPurchase;
  final Function changeTotalCount;
  final String id;
  final InputModel model;

  const PurchaseInputWidget({
    super.key,
    required this.id,
    required this.onDelete,
    required this.changeTotalPurchase,
    required this.changeTotalCount,
    required this.model,
  });

  @override
  State<PurchaseInputWidget> createState() => _PurchaseInputWidget();
}

class _PurchaseInputWidget extends State<PurchaseInputWidget> {
  final priceTextEditController = TextEditingController();
  final countTextEditController = TextEditingController();
  final amountTextEditController = TextEditingController();
  Timer? countTextEditTimer;
  Timer? amountTextEditTimer;
  int lastAmountValue = 0;
  int lastCountValue = 0;

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
          // width: MediaQuery.sizeOf(context).width,

          child: TextField(
            controller: countTextEditController,
            onChanged: (value) {
              if (value.isEmpty) {
                lastCountValue = 0;
              } else {
                lastCountValue = int.parse(value);
              }

              if (countTextEditTimer != null && countTextEditTimer!.isActive) {
                return;
              }

              countTextEditTimer = Timer(const Duration(seconds: 1), () {
                widget.model.changeCount(lastCountValue);
                widget.model.changeAmount();

                setState(() {
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
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            ),
          ),
        ),
        SizedBox(
          height: 20,
          width: 90,
          // width: MediaQuery.sizeOf(context).width,

          child: Center(
            child: TextField(
              controller: amountTextEditController,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                lastAmountValue = int.parse(value);
                setState(() {
                  if (amountTextEditTimer != null &&
                      amountTextEditTimer!.isActive) {
                    return;
                  }
                  amountTextEditTimer = Timer(const Duration(seconds: 1), () {
                    int newAmount = int.parse(amountTextEditController.text);

                    if (newAmount < widget.model.price) {
                      return;
                    }
                    widget.model.setAmount(newAmount);
                    widget.model.floorCountForAmount();
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
