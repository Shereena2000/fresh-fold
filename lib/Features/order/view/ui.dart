import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/order/view/widgets/active_order.dart';
import 'package:fresh_fold/Features/order/view/widgets/active_pickup.dart';
import 'package:fresh_fold/Features/order/view/widgets/cancelled.dart';
import 'package:fresh_fold/Features/order/view/widgets/completed.dart';

import '../../../Settings/common/widgets/custom_app_bar.dart';
import '../../../Settings/common/widgets/custom_tab_section.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const CustomAppBar(title: "Order"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: CustomTabSection(
                  contentHPadding: 10,
                  fontSize: 12,
                  tabTitles: const [
                    "Active Pickup",
                    "Active Order",
                    "Completed",
                    "Cancelled",
                  ],
                  tabContents: [
                    ActivePickup(),
                    ActiveOrder(),
                    Completed(),
                    Cancelled(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
