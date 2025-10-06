import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fresh_fold/Features/order/view/widgets/active_order.dart';
import 'package:fresh_fold/Features/order/view/widgets/active_pickup.dart';
import 'package:fresh_fold/Features/order/view/widgets/cancelled.dart';
import 'package:fresh_fold/Features/order/view/widgets/completed.dart';
import '../../../Settings/common/widgets/custom_app_bar.dart';
import '../../../Settings/common/widgets/custom_tab_section.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../auth/view_model.dart/auth_view_model.dart';
import '../view_model/order_view_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);
      final userId = authProvider.currentUser?.uid;
      
      if (userId != null) {
        context.read<OrderViewModel>().fetchOrders(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Order"),
      body: Consumer<OrderViewModel>(
        builder: (context, viewModel, child) {
          // Show error message if any
          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(viewModel.errorMessage!),
                  backgroundColor: PColors.errorRed,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () => viewModel.clearError(),
                  ),
                ),
              );
              viewModel.clearError();
            });
          }

          return SafeArea(
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
                      tabContents: const [
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
          );
        },
      ),
    );
  }
}