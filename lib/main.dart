import 'package:flutter/material.dart';
import 'package:stock_calculate/app_preference.dart';
import 'package:stock_calculate/stock_calculator_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference.init();
  runApp(const StockCalculatorApp());
}
