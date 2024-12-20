import 'dart:async';

import 'package:flutter/material.dart';

class ResultRateWidget extends StatefulWidget {
  const ResultRateWidget({super.key});

  @override
  State<ResultRateWidget> createState() => _ResultRateWidgetState();
}

class _ResultRateWidgetState extends State<ResultRateWidget> {
  final purchaseTextEditController = TextEditingController();
  final saleTextEditController = TextEditingController();
  final resultTextEditController = TextEditingController();
  Timer? purchaseTimer;
  Timer? saleTimer;

  int purchaseAmount = 0;
  int salesAmount = 0;
  int resultAmount = 0;

  @override
  void dispose() {
    purchaseTextEditController.dispose();
    saleTextEditController.dispose();
    resultTextEditController.dispose();
    purchaseTimer?.cancel();
    saleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const SizedBox(
              width: 100,
              height: 20,
              child: Center(
                child: Text("매수단가"),
              ),
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                controller: purchaseTextEditController,
                onChanged: (value) {
                  if (purchaseTimer != null && purchaseTimer!.isActive) {
                    return;
                  }

                  purchaseTimer = Timer(const Duration(seconds: 2), () {
                    setState(() {
                      purchaseAmount =
                          int.parse(purchaseTextEditController.text);
                      resultAmount = salesAmount - purchaseAmount;
                      resultTextEditController.text =
                          "${(resultAmount / 100)}%";
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
          ],
        ),
        Column(
          children: [
            const SizedBox(
              width: 100,
              height: 20,
              child: Center(
                child: Text("매도단가"),
              ),
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                controller: saleTextEditController,
                onChanged: (value) {
                  if (saleTimer != null && saleTimer!.isActive) {
                    return;
                  }

                  saleTimer = Timer(const Duration(seconds: 2), () {
                    setState(() {
                      salesAmount = int.parse(saleTextEditController.text);
                      resultAmount = salesAmount - purchaseAmount;
                      resultTextEditController.text =
                          "${(resultAmount / 100)}%";
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
          ],
        ),
        Column(
          children: [
            const SizedBox(
              width: 100,
              height: 20,
              child: Center(
                child: Text("결과"),
              ),
            ),
            SizedBox(
              width: 100,
              height: 20,
              child: TextField(
                controller: resultTextEditController,
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
          ],
        )
      ],
    );
  }
}
