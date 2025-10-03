import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_elevated_button.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';

import '../../../Settings/common/widgets/custom_app_bar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: const CustomAppBar(title: "Payment"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount",
                    style: PTextStyles.displaySmall.copyWith(
                      fontSize: 20,
                      color: PColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹ 350",
                    style: PTextStyles.displaySmall.copyWith(
                      color: PColors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Methods Label
            Text(
              "Select Payment Method",
              style: PTextStyles.headlineMedium.copyWith(color: PColors.black),
            ),

            const SizedBox(height: 12),

            // Payment Options
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: PColors.primaryColor,
                ),
                title: const Text("UPI"),
                subtitle: const Text("Google Pay, PhonePe, Paytm"),
                trailing: Icon(
                  Icons.radio_button_checked,
                  color: PColors.primaryColor,
                ),
              ),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.credit_card, color: PColors.primaryColor),
                title: const Text("Credit / Debit Card"),
                subtitle: const Text("Visa, Mastercard, Rupay"),
                trailing: Icon(
                  Icons.radio_button_unchecked,
                  color: PColors.primaryColor,
                ),
              ),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.money, color: PColors.primaryColor),
                title: const Text("Cash on Delivery"),
                subtitle: const Text("Pay when order is delivered"),
                trailing: Icon(
                  Icons.radio_button_unchecked,
                  color: PColors.primaryColor,
                ),
              ),
            ),

            const Spacer(),

            // Pay Now Button
            CustomElavatedTextButton(text: "Pay Now", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
