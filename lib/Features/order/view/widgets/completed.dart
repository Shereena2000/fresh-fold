import 'package:flutter/material.dart';

import '../../../../Settings/constants/sized_box.dart';
import 'order_card.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizeBoxH(8),
        OrderCard(
          title: "Laundry",
          orderId: "Order Id: ORD1234",
          date: "Oct 5, 2025",
          status: "Completed",
        ),
      ],
    );
  }
}
