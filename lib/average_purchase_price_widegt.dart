import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_calculate/app_preference.dart';
import 'package:stock_calculate/input_model.dart';
import 'package:stock_calculate/purchase_input_widget.dart';

class AveragePurchasePriceWidegt extends StatefulWidget {
  final Function onChangePurchaseCount;
  final Function onChangePurchaseAmount;

  const AveragePurchasePriceWidegt({
    super.key,
    required this.onChangePurchaseCount,
    required this.onChangePurchaseAmount,
  });

  @override
  State<AveragePurchasePriceWidegt> createState() =>
      _AveragePurchasePriceWidegt();
}

class _AveragePurchasePriceWidegt extends State<AveragePurchasePriceWidegt>
    with WidgetsBindingObserver {
  final List<PurchaseInputWidget> _input = [];
  final List<InputModel> _model = [];

  double totalAveragePrice = 0;
  int totalPurchageCount = 0;
  int totalPurchage = 0;

  void _changeAveragePrice() {
    if (totalPurchage == 0 || totalPurchage.isNaN || totalPurchageCount == 0) {
      totalAveragePrice = 0;
    } else {
      totalAveragePrice = totalPurchage / totalPurchageCount;
    }
  }

  void _initAveragePrice() {
    if (totalPurchage == 0 || totalPurchage.isNaN || totalPurchageCount == 0) {
      totalAveragePrice = 0;
    } else {
      totalAveragePrice = totalPurchage / totalPurchageCount;
    }
  }

  void _initTototalCount() {
    totalPurchageCount = _model.isEmpty
        ? 0
        : _model
            .map((model) => model.count)
            .reduce((acc, count) => acc + count);
  }

  void _initTotalPuchase() {
    totalPurchage = _model.isEmpty
        ? 0
        : _model
            .map((model) => model.amount)
            .reduce((acc, amount) => acc + amount);

    _initAveragePrice();
  }

  void _changeTotalPurchase() {
    setState(() {
      totalPurchage = _model.isEmpty
          ? 0
          : _model
              .map((model) => model.amount)
              .reduce((acc, amount) => acc + amount);
      widget.onChangePurchaseAmount(totalPurchage);

      _changeAveragePrice();
      AppPreference.save('purchase',
          _model.map((toElement) => toElement.toStringJson()).toList());
    });
  }

  void _changeTotalCount() {
    setState(() {
      totalPurchageCount = _model.isEmpty
          ? 0
          : _model
              .map((model) => model.count)
              .reduce((acc, count) => acc + count);
      widget.onChangePurchaseCount(totalPurchageCount);
      _changeAveragePrice();

      AppPreference.save('purchase',
          _model.map((toElement) => toElement.toStringJson()).toList());
    });
  }

  void _addInput() async {
    setState(() {
      final key = DateTime.now().toString();
      final model = InputModel(id: key);

      _model.add(model);

      _input.add(PurchaseInputWidget(
        onDelete: (String key) => _removeInput(key),
        changeTotalPurchase: _changeTotalPurchase,
        changeTotalCount: _changeTotalCount,
        id: key,
        model: model,
      ));

      AppPreference.save('purchase',
          _model.map((toElement) => toElement.toStringJson()).toList());
    });
  }

  void _initList(List<dynamic> initModels) {
    setState(() {
      for (var entry in initModels) {
        final inputMap = jsonDecode(entry) as Map<String, dynamic>;
        final inputModel = InputModel.fromJson(inputMap);
        _model.add(inputModel);

        final widget = PurchaseInputWidget(
          onDelete: (String key) => _removeInput(key),
          changeTotalPurchase: _changeTotalPurchase,
          changeTotalCount: _changeTotalCount,
          id: inputModel.id,
          model: inputModel,
        );

        _input.add(widget);
        _input.sort((m1, m2) => m1.id.compareTo(m2.id));
      }
    });
  }

  void _removeInput(String key) {
    setState(() {
      if (_input.isNotEmpty) {
        _input.remove(_input.firstWhere((model) => model.id == key));
      }
      if (_model.isNotEmpty) {
        _model.remove(_model.firstWhere((model) => model.id == key));
        AppPreference.save(
            "purchase", _model.map((m) => m.toStringJson()).toList());
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        // Do something when the app is visible...
        break;
      case AppLifecycleState.hidden: // <-- This is the new state.
      case AppLifecycleState.paused:
        AppPreference.save(
            "purchase", _model.map((m) => m.toStringJson()).toList());
        break;
      case AppLifecycleState.detached:
        AppPreference.save(
            "purchase", _model.map((m) => m.toStringJson()).toList());
        // Do something when the app is not visible...
        // AppPreference.savePurchase("purchase", jsonEncode(_models.entries.ma));
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final savedModel = AppPreference.get("purchase");

    if (savedModel.isNotEmpty) {
      _initList(jsonDecode(savedModel));
    }

    _initTototalCount();
    _initTotalPuchase();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
            "물타기",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("평균매수단가"),
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(
                        '₩ $totalAveragePrice',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("매수수량"),
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(
                        '$totalPurchageCount',
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("매수금"),
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: Text(
                        '₩ $totalPurchage',
                        // overflow: TextOverflow.visible,
                        // softWrap: true,
                        style: const TextStyle(
                          color: Colors.red,
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
                  // iconSize: 40,
                ),
              ),
            ],
          ),
          Column(children: _input),
        ],
      ),
    );
  }
}
