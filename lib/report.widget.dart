import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  final int totalPurchaseAmount;
  final int totalSaleAmount;
  final int totalHasStockCount;
  final double totalRealPropitRate;

  const ReportWidget({
    super.key,
    required this.totalPurchaseAmount,
    required this.totalSaleAmount,
    required this.totalHasStockCount,
    required this.totalRealPropitRate,
  });

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  bool isTax = false;

  void applyTax() {
    setState(() {
      isTax = !isTax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(
              width: 2,
            ),
          ),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(64),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              const Text("총매수가"),
              Text('${widget.totalPurchaseAmount}')
            ]),
            TableRow(children: [
              const Text("총매도가"),
              Text('${widget.totalSaleAmount}')
            ]),
            TableRow(children: [
              const Text("실현수익률(%)"),
              Text("${widget.totalRealPropitRate}")
            ]),
            TableRow(children: [
              const Text("실현손익"),
              Text("${widget.totalSaleAmount - widget.totalPurchaseAmount}")
            ]),
            TableRow(children: [
              const Text("남은수량"),
              Text('${widget.totalHasStockCount}')
            ]),
            TableRow(children: [
              const Text("총평가금(남은수량제외)"),
              Text("${widget.totalSaleAmount}")
            ]),
          ],
        ),
      ],
    );
  }
}
