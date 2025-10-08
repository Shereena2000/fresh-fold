import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../model/price_item.dart';
import '../../view_model/price_view_model.dart';

class PriceTable extends StatelessWidget {
  final String category;

  const PriceTable({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PriceViewModel>(
      builder: (context, priceProvider, child) {
        if (priceProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: PColors.primaryColor,
            ),
          );
        }

        if (priceProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  priceProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => priceProvider.loadCategoryItems(category),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<List<PriceItemModel>>(
          stream: priceProvider.streamCategoryItems(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: PColors.primaryColor,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading data'),
              );
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No price items available',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizeBoxH(12),
                  Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      // Table Header
                      TableRow(
                        decoration: BoxDecoration(
                          color: const Color(0xFF013E6A),
                        ),
                        children: [
                          _buildHeaderCell('Per Piece'),
                          _buildHeaderCell('Dry Wash'),
                          _buildHeaderCell('Wet Wash'),
                          _buildHeaderCell('Steam Press'),
                        ],
                      ),
                      
                      // Table Rows
                      ...items.map((item) => TableRow(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4267B2),
                        ),
                        children: [
                          _buildDataCell(item.itemName),
                          _buildDataCell('₹${item.dryWash}'),
                          _buildDataCell('₹${item.wetWash}'),
                          _buildDataCell('₹${item.steamPress}'),
                        ],
                      )).toList(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}