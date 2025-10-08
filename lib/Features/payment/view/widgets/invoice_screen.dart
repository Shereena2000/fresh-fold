import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/utils/p_colors.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../../model/order_billing_model.dart';
import '../../view_model/payment_view_model.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PaymentViewModel>().loadPaymentRequests(userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view invoices'),
        ),
      );
    }

    return Scaffold(
      body: Consumer<PaymentViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: PColors.primaryColor,
              ),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.clearError();
                      viewModel.loadPaymentRequests(userId!);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.paymentRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Payment Requests',
                    style: PTextStyles.headlineMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your payment requests will appear here',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadPaymentRequests(userId!),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.paymentRequests.length,
              itemBuilder: (context, index) {
                final billing = viewModel.paymentRequests[index];
                return _buildInvoiceCard(context, billing, viewModel);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceCard(
    BuildContext context,
    OrderBillingModel billing,
    PaymentViewModel viewModel,
  ) {
    final statusText = viewModel.getStatusText(billing.paymentStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PColors.primaryColor, PColors.secondoryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${billing.scheduleId.substring(0, 8)}',
                        style: PTextStyles.headlineMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy · hh:mm a')
                            .format(billing.createdAt),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: Colors.white30),

            // Service details
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    Icons.local_laundry_service,
                    'Service',
                    billing.serviceType,
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    Icons.wash,
                    'Wash Type',
                    viewModel.formatWashType(billing.washType),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Items section header
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Items (${billing.items.length})',
                  style: PTextStyles.headlineMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Items list
            ...billing.items.map((item) => _buildItemRow(item)).toList(),

            const Divider(height: 24, color: Colors.white30),

            // Total amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: PTextStyles.headlineMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '₹${billing.totalAmount.toStringAsFixed(2)}',
                    style: PTextStyles.displaySmall.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildItemRow(BillingItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name
          Text(
            item.itemName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // Details row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity
              Row(
                children: [
                  const Icon(Icons.shopping_cart, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    'Qty: ${item.quantity}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              // Unit price
              Row(
                children: [
                  const Text(
                    'Unit: ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '₹${item.unitPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              // Total
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  '₹${item.itemTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


// import 'package:flutter/material.dart';
// import 'package:fresh_fold/Settings/constants/sized_box.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_fold/Settings/common/widgets/custom_elevated_button.dart';
// import 'package:fresh_fold/Settings/utils/p_colors.dart';
// import 'package:fresh_fold/Settings/utils/p_text_styles.dart';

// import '../../model/payment_model.dart';
// import '../../view_model/payment_view_model.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PaymentViewModel>(
//       builder: (context, viewModel, child) {
//         final payment = viewModel.paymentModel;

//         return Scaffold(
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Total Amount
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [PColors.primaryColor, PColors.secondoryColor],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           spreadRadius: 1,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Total Amount",
//                           style: PTextStyles.displaySmall.copyWith(
//                             fontSize: 20,
//                             color: PColors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                         "₹ ${payment.totalAmount.toStringAsFixed(0)}",
//                           style: PTextStyles.displaySmall.copyWith(
//                             color: PColors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Payment Methods Label
//                   Text(
//                     "Select Payment Method",
//                     style: PTextStyles.headlineMedium.copyWith(
//                       color: PColors.black,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // UPI Payment Option
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         ListTile(
//                           onTap: () => viewModel.selectPaymentMethod(
//                             PaymentMethod.upi,
//                           ),
//                           leading: Icon(
//                             Icons.account_balance_wallet,
//                             color: PColors.primaryColor,
//                           ),
//                           title: const Text("UPI"),
//                           subtitle: const Text("Google Pay, PhonePe, Paytm"),
//                           trailing: Icon(
//                             payment.selectedMethod == PaymentMethod.upi
//                                 ? Icons.radio_button_checked
//                                 : Icons.radio_button_unchecked,
//                             color: PColors.primaryColor,
//                           ),
//                         ),
                        
//                         // Show UPI apps when UPI is selected
//                         if (payment.showUpiOptions) ...[
//                           const Divider(height: 1),
//                           ...UpiAppType.values.map((appType) {
//                             final isAvailable = viewModel.isUpiAppAvailable(appType);
//                             return ListTile(
//                               contentPadding: const EdgeInsets.only(
//                                 left: 72,
//                                 right: 16,
//                               ),
//                               onTap: isAvailable
//                                   ? () {
//                                       viewModel.selectUpiApp(appType);
//                                       viewModel.launchUpiApp(appType, context);
//                                     }
//                                   : null,
//                               enabled: isAvailable,
//                               leading: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   color: isAvailable 
//                                       ? PColors.white 
//                                       : Colors.grey.shade200,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(
//                                     viewModel.getUpiAppIcon(appType),
//                                     color: isAvailable 
//                                         ? PColors.primaryColor 
//                                         : Colors.grey,
//                                     size: 20,
//                                   ),
//                                 ),
//                               ),
//                               title: Text(
//                                 viewModel.getUpiAppName(appType),
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: isAvailable 
//                                       ? Colors.black 
//                                       : Colors.grey,
//                                 ),
//                               ),
//                               trailing: payment.selectedUpiApp == appType
//                                   ? Icon(
//                                       Icons.check_circle,
//                                       color: PColors.primaryColor,
//                                       size: 20,
//                                     )
//                                   : null,
//                             );
//                           }).toList(),
//                         ],
//                       ],
//                     ),
//                   ),

//                   // Card Payment Option (Now works with Razorpay!)
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       onTap: () => viewModel.selectPaymentMethod(
//                         PaymentMethod.card,
//                       ),
//                       leading: Icon(
//                         Icons.credit_card,
//                         color: PColors.primaryColor,
//                       ),
//                       title: const Text("Credit/Debit Card"),
//                       subtitle: const Text("Visa, Mastercard, Rupay"),
//                       trailing: Icon(
//                         payment.selectedMethod == PaymentMethod.card
//                             ? Icons.radio_button_checked
//                             : Icons.radio_button_unchecked,
//                         color: PColors.primaryColor,
//                       ),
//                     ),
//                   ),

//                   // Cash on Delivery Option
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       onTap: () => viewModel.selectPaymentMethod(
//                         PaymentMethod.cod,
//                       ),
//                       leading: Icon(Icons.money, color: PColors.primaryColor),
//                       title: const Text("Cash on Delivery"),
//                       subtitle: const Text("Pay when order is delivered"),
//                       trailing: Icon(
//                         payment.selectedMethod == PaymentMethod.cod
//                             ? Icons.radio_button_checked
//                             : Icons.radio_button_unchecked,
//                         color: PColors.primaryColor,
//                       ),
//                     ),
//                   ),

//                   SizeBoxH(20),
                  
//                   // Pay Now Button
//                   CustomElavatedTextButton(
//                     text: "Pay Now",
//                //     onPressed: () => viewModel.processPayment(context),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }