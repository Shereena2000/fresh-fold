import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';

class PriceTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final Color headerBackgroundColor;
  final Color rowBackgroundColor;
  final Color textColor;

  const PriceTable({
    super.key,
    required this.headers,
    required this.data,
    this.headerBackgroundColor =const Color(0xFF013E6A),
    this.rowBackgroundColor =const Color(0xFF4267B2),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizeBoxH(12),
        Table(
          border: TableBorder.all(color: Colors.white),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Table Header
            TableRow(
              decoration: BoxDecoration(color: headerBackgroundColor),
              children: headers.map((header) => 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    header,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ).toList(),
            ),
            
            // Table Rows
            ...data.map((rowData) => 
              TableRow(
                decoration: BoxDecoration(color: rowBackgroundColor),
                children: rowData.map((cellData) => 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cellData,
                      style: TextStyle(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ).toList(),
              ),
            ).toList(),
          ],
        ),
      ],
    );
  }
}