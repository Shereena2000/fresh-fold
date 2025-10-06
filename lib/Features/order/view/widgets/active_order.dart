import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/order_view_model.dart';
import 'order_card.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewModel.activeOrders.isEmpty) {
          return Center(
            child: Text(
              'No active orders',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: viewModel.activeOrders.length,
          itemBuilder: (context, index) {
            final schedule = viewModel.activeOrders[index];
            return OrderCard(
              schedule: schedule,
              scheduleId: schedule.scheduleId,
            );
          },
        );
      },
    );
  }
}