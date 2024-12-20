import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_calculate/app_preference.dart';
import 'package:stock_calculate/average_purchase_price_widegt.dart';
import 'package:stock_calculate/report.widget.dart';
import 'package:stock_calculate/result_rate_widget.dart';
import 'package:stock_calculate/split_sale_price_widget.dart';

import 'input_model.dart';

class AveragePriceScreen extends StatefulWidget {
  const AveragePriceScreen({super.key});

  @override
  State<AveragePriceScreen> createState() => _AveragePriceScreenState();
}

class _AveragePriceScreenState extends State<AveragePriceScreen> {
  int totalPurchaseAmount = 0;
  int totalPurchageCount = 0;
  int totalPurchage = 0;

  int totalSaleAmount = 0;
  int salesStockCount = 0;

  void _initPurchase() {
    final purchase = AppPreference.get("purchase");

    if (purchase.isEmpty) {
      return;
    }

    final initModels = jsonDecode(purchase) as List<dynamic>;
    final convertedModels = initModels.map((model) {
      final inputMap = jsonDecode(model) as Map<String, dynamic>;
      return InputModel.fromJson(inputMap);
    }).toList();

    salesStockCount = convertedModels.isEmpty
        ? 0
        : convertedModels
            .map((model) => model.count)
            .reduce((acc, count) => acc + count);

    totalPurchaseAmount = convertedModels.isEmpty
        ? 0
        : convertedModels
            .map((model) => model.amount)
            .reduce((acc, amount) => acc + amount);
  }

  void _initSale() {
    final sales = AppPreference.get("sales");

    if (sales.isEmpty) {
      return;
    }

    final initModels = jsonDecode(sales) as List<dynamic>;
    final convertedModels = initModels.map((model) {
      final inputMap = jsonDecode(model) as Map<String, dynamic>;
      return InputModel.fromJson(inputMap);
    }).toList();

    totalPurchageCount = convertedModels.isEmpty
        ? 0
        : convertedModels
            .map((model) => model.count)
            .reduce((acc, count) => acc + count);

    totalSaleAmount = convertedModels.isEmpty
        ? 0
        : convertedModels
            .map((model) => model.amount)
            .reduce((acc, amount) => acc + amount);
  }

  void changePurchageAmount(int amount) {
    setState(() {
      totalPurchaseAmount = amount;
    });
  }

  void changePurchageCount(int count) {
    setState(() {
      totalPurchageCount = count;
    });
  }

  void changeHasStockCount(int count) {
    setState(() {
      salesStockCount = count;
    });
  }

  void changeTotalSaleAmount(int amount) {
    setState(() {
      totalSaleAmount = amount;
    });
  }

  double calculateRealProhibitRate() {
    if (totalPurchageCount == 0) {
      return 0;
    }
    return (totalSaleAmount - totalPurchaseAmount) / totalPurchageCount;
  }

  @override
  void initState() {
    super.initState();
    _initPurchase();
    _initSale();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          AveragePurchasePriceWidegt(
            onChangePurchaseCount: changePurchageCount,
            onChangePurchaseAmount: changePurchageAmount,
          ),
          SplitSalePriceWidget(
            totalPurchaseCount: totalPurchageCount,
            changeTotalSaleAmount: changeTotalSaleAmount,
            changeHasStockCount: changeHasStockCount,
          ),
          const SizedBox(
            height: 20,
          ),
          const ResultRateWidget(),
          ReportWidget(
            totalPurchaseAmount: totalPurchaseAmount,
            totalSaleAmount: totalSaleAmount,
            totalHasStockCount: totalPurchageCount - salesStockCount,
            totalRealPropitRate: calculateRealProhibitRate(),
          ),
        ],
      )),
    );
  }
}
