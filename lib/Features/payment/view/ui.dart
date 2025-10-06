import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:provider/provider.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_elevated_button.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';
import '../../../Settings/common/widgets/custom_app_bar.dart';
import '../model/payment_model.dart';
import '../view_model/payment_view_model.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, child) {
        final payment = viewModel.paymentModel;

        return Scaffold(
          appBar: const CustomAppBar(title: "Payment"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Amount
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [PColors.primaryColor, PColors.secondoryColor],
                      ),
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
                          "₹ ${payment.totalAmount.toStringAsFixed(0)}",
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
                    style: PTextStyles.headlineMedium.copyWith(
                      color: PColors.black,
                    ),
                  ),
            
                  const SizedBox(height: 12),
            
                  // UPI Payment Option
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => viewModel.selectPaymentMethod(
                            PaymentMethod.upi,
                          ),
                          leading: Icon(
                            Icons.account_balance_wallet,
                            color: PColors.primaryColor,
                          ),
                          title: const Text("UPI"),
                          subtitle: const Text("Google Pay, PhonePe, Paytm"),
                          trailing: Icon(
                            payment.selectedMethod == PaymentMethod.upi
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: PColors.primaryColor,
                          ),
                        ),
                        
                        // Show UPI apps when UPI is selected
                        if (payment.showUpiOptions) ...[
                          const Divider(height: 1),
                          ...UpiApp.values.map((app) {
                            return ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 72,
                                right: 16,
                              ),
                              onTap: () {
                                viewModel.selectUpiApp(app);
                                viewModel.launchUpiApp(app);
                              },
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: PColors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    viewModel.getUpiAppIcon(app),
                                    color: PColors.primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                viewModel.getUpiAppName(app),
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: payment.selectedUpiApp == app
                                  ? Icon(
                                      Icons.check_circle,
                                      color: PColors.primaryColor,
                                      size: 20,
                                    )
                                  : null,
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
            
                  // // Credit/Debit Card Option
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: ListTile(
                  //     onTap: () => viewModel.selectPaymentMethod(
                  //       PaymentMethod.card,
                  //     ),
                  //     leading: Icon(
                  //       Icons.credit_card,
                  //       color: PColors.primaryColor,
                  //     ),
                  //     title: const Text("Credit / Debit Card"),
                  //     subtitle: const Text("Visa, Mastercard, Rupay"),
                  //     trailing: Icon(
                  //       payment.selectedMethod == PaymentMethod.card
                  //           ? Icons.radio_button_checked
                  //           : Icons.radio_button_unchecked,
                  //       color: PColors.primaryColor,
                  //     ),
                  //   ),
                  // ),
            
                  // Cash on Delivery Option
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => viewModel.selectPaymentMethod(
                        PaymentMethod.cod,
                      ),
                      leading: Icon(Icons.money, color: PColors.primaryColor),
                      title: const Text("Cash on Delivery"),
                      subtitle: const Text("Pay when order is delivered"),
                      trailing: Icon(
                        payment.selectedMethod == PaymentMethod.cod
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: PColors.primaryColor,
                      ),
                    ),
                  ),
            
            SizeBoxH(20),
                  // Pay Now Button
                  CustomElavatedTextButton(
                    text: "Pay Now",
                    onPressed: () => viewModel.processPayment(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}