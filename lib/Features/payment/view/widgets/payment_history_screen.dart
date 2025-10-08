import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/utils/p_colors.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../../model/order_billing_model.dart';
import '../../view_model/payment_view_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
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
          child: Text('Please log in to view payment history'),
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

          // Filter only paid requests
          final paidRequests = viewModel.paymentRequests
              .where((billing) => billing.paymentStatus.toLowerCase() == 'paid')
              .toList();

          if (paidRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Payment History',
                    style: PTextStyles.headlineMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your paid invoices will appear here',
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
              itemCount: paidRequests.length,
              itemBuilder: (context, index) {
                final billing = paidRequests[index];
                return _buildPaymentHistoryCard(context, billing, viewModel);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentHistoryCard(
    BuildContext context,
    OrderBillingModel billing,
    PaymentViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PColors.primaryColor, PColors.secondoryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with order ID and Paid badge
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(billing.createdAt),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Paid badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Paid',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 16, color: Colors.white30),

            // Service info row
            Row(
              children: [
                Expanded(
                  child: _buildCompactInfo(
                    Icons.local_laundry_service,
                    billing.serviceType,
                  ),
                ),
                Expanded(
                  child: _buildCompactInfo(
                    Icons.wash,
                    viewModel.formatWashType(billing.washType),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Items count and total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_basket, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      '${billing.items.length} items · ${billing.items.fold(0, (sum, item) => sum + item.quantity)} pcs',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${billing.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}