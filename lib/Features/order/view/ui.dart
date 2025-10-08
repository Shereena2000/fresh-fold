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
  String? userId;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    userId = authProvider.currentUser?.uid;
    
    // Sync schedules to global collection on app start (to fix any missing documents)
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncSchedulesIfNeeded();
      });
    }
  }

  void _syncSchedulesIfNeeded() async {
    try {
      // Only sync if there are orders to avoid unnecessary calls
      final orderProvider = Provider.of<OrderViewModel>(context, listen: false);
      await orderProvider.syncAllSchedulesToGlobal(userId!);
    } catch (e) {
      // Silent fail - don't show error to user for background sync
      print('Background sync failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Order"),
        body: const Center(
          child: Text('Please log in to view orders'),
        ),
      );
    }

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
                    child: StreamBuilder(
                      stream: viewModel.streamOrders(userId!),
                      builder: (context, snapshot) {
                        // Only show loading on initial connection (when no data exists yet)
                        if (snapshot.connectionState == ConnectionState.waiting && 
                            !snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: PColors.primaryColor,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          // Update view model with real-time data
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            viewModel.updateFromStream(snapshot.data!);
                          });
                        }

                        return CustomTabSection(
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
                        );
                      },
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