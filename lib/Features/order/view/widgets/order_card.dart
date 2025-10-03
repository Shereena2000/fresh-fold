import 'package:flutter/material.dart';

import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../../../Settings/utils/p_text_styles.dart';


class OrderCard extends StatelessWidget {
  final String title;     
  final String orderId;   
  final String date;     
  final String status;   

  const OrderCard({
    super.key,
    required this.title,
    required this.orderId,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    if (status.toLowerCase() == "completed") {
      statusColor = Colors.green;
    } else if (status.toLowerCase() == "cancelled") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: PColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: PTextStyles.headlineMedium.copyWith(color: Colors.white)),
            SizeBoxH(8),
            Text(orderId, style: PTextStyles.labelMedium.copyWith(color: Colors.white)),
            SizeBoxH(8),
            Text(date, style: PTextStyles.labelMedium.copyWith(color: Colors.white)),
            SizeBoxH(8),
            Text(status,
                style: PTextStyles.labelLarge.copyWith(color: statusColor)),
          ],
        ),
      ),
    );
  }
}
