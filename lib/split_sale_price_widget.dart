import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_calculate/app_preference.dart';
import 'package:stock_calculate/input_model.dart';
import 'package:stock_calculate/input_widget.dart';

class SplitSalePriceWidget extends StatefulWidget {
  final int totalPurchaseCount;
  final Function changeTotalSaleAmount;
  final Function changeHasStockCount;

  const SplitSalePriceWidget({
    super.key,
    required this.totalPurchaseCount,
    required this.changeTotalSaleAmount,
    required this.changeHasStockCount,
  });

  @override
  State<SplitSalePriceWidget> createState() => _SplitSalePriceWidget();
}

class _SplitSalePriceWidget extends State<SplitSalePriceWidget> {
  final List<InputWidget> _input = [];
  final List<InputModel> _model = [];

  double totalAverageSalePrice = 0;
  int totalSaleCount = 0;
  int totalSaleAmount = 0;

  int getRemainingStockCount() {
    return widget.totalPurchaseCount - totalSaleCount;
  }

  int getTotalPurchaseCount() {
    return widget.totalPurchaseCount;
  }

  TextEditingController createController() {
    final controller = TextEditingController();
    return controller;
  }

  void _initTotalSaleAmount() {
    if (_model.isEmpty) {
      totalSaleAmount = 0;
    } else {
      totalSaleAmount = _model
          .map((model) => model.amount)
          .reduce((acc, amount) => acc + amount);
    }
  }

  void _initTotalSaleCount() {
    if (_model.isEmpty) {
      totalSaleCount = 0;
    } else {
      totalSaleCount = _model
          .map((model) => model.count)
          .reduce((acc, count) => acc + count);
    }
  }

  void _refreshResult() {
    _changeTotalCount();
    _changeTotalPurchase();
    _changeAverage();
  }

  void _changeTotalPurchase() {
    setState(() {
      _initTotalSaleAmount();
      widget.changeTotalSaleAmount(totalSaleAmount);
      _changeAverage();

      AppPreference.save("sales", _model.map((m) => m.toStringJson()).toList());
    });
  }

  void _changeTotalCount() {
    setState(() {
      _initTotalSaleCount();
      widget.changeHasStockCount(totalSaleCount);
      _changeAverage();
      AppPreference.save("sales", _model.map((m) => m.toStringJson()).toList());
    });
  }

  void _changeAverage() {
    if (totalSaleCount == 0) {
      totalAverageSalePrice = 0;
    } else {
      totalAverageSalePrice = totalSaleAmount / totalSaleCount;
    }
  }

  void _addInput() {
    if (getRemainingStockCount() == 0) {
      return;
    }
    setState(() {
      final key = DateTime.now().toString();
      final model = InputModel(id: key);
      _input.add(InputWidget(
        onDelete: _removeInput,
        changeTotalPurchase: _changeTotalPurchase,
        changeTotalCount: _changeTotalCount,
        getRemainingStockCount: getRemainingStockCount,
        getTotalPurchaseCount: getTotalPurchaseCount,
        model: model,
        id: key,
      ));

      _model.add(model);

      AppPreference.save("sales", _model.map((m) => m.toStringJson()).toList());
    });
  }

  void _removeInput(String key) {
    setState(() {
      if (_input.isNotEmpty) {
        _input.remove(_input.firstWhere((input) => input.id == key));
      }

      if (_model.isNotEmpty) {
        _model.remove(_model.firstWhere((model) => model.id == key));
      }

      _refreshResult();
    });
  }

  void _initSales(List<dynamic> sales) {
    setState(() {
      for (var sale in sales) {
        final inputMap = jsonDecode(sale) as Map<String, dynamic>;
        final inputModel = InputModel.fromJson(inputMap);
        _model.add(inputModel);

        final widget = InputWidget(
          onDelete: (String key) => _removeInput(key),
          changeTotalPurchase: _changeTotalPurchase,
          changeTotalCount: _changeTotalCount,
          getRemainingStockCount: getRemainingStockCount,
          getTotalPurchaseCount: getTotalPurchaseCount,
          id: inputModel.id,
          model: inputModel,
        );

        _input.add(widget);
        _input.sort((m1, m2) => m1.id.compareTo(m2.id));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final salesStr = AppPreference.get("sales");

    if (salesStr.isNotEmpty) {
      _initSales(jsonDecode(salesStr) as List<dynamic>);
      _initTotalSaleCount();
      _initTotalSaleAmount();
      _changeAverage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "분할매도",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("평균매도단가"),
                  SizedBox(
                    width: 100,
                    // width: MediaQuery.sizeOf(context).width,

                    child: Center(
                      child: Text(
                        '₩ $totalAverageSalePrice',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("남은수량"),
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(
                        '${widget.totalPurchaseCount - totalSaleCount}',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("매도금"),
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: Text(
                        '₩ $totalSaleAmount',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: IconButton(
                  onPressed: _addInput,
                  icon: const Icon(Icons.post_add),
                ),
              ),
            ],
          ),
          Column(
            children: _input,
          ),
        ],
      ),
    );
  }
}
