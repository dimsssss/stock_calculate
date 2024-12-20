import 'package:flutter/material.dart';
import 'package:stock_calculate/average_price_screen.dart';

class StockCalculatorApp extends StatefulWidget {
  const StockCalculatorApp({super.key});

  @override
  State<StockCalculatorApp> createState() => _StockCalculatorAppState();
}

class _StockCalculatorAppState extends State<StockCalculatorApp> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Text("평단"),
                Text("설정"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AveragePriceScreen(),
              Text(
                "data",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
