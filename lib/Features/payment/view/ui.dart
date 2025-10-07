import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'widgets/payment_history_screen.dart';
import 'widgets/payment_screen.dart';

class PaymentSectionScreens extends StatelessWidget {
  const PaymentSectionScreens({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PColors.white,
          title: Text(
            'Payment Section',
            style: TextStyle(color: PColors.primaryColor),
          ),
          bottom: TabBar(
            labelColor: PColors.secondoryColor,
            indicatorColor: PColors.secondoryColor,
            tabs: [
              Tab(text: 'Payment Methods'),
              Tab(text: 'Transaction History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PaymentScreen(), PaymentHistoryScreen()],
        ),
      ),
    );
  }
}