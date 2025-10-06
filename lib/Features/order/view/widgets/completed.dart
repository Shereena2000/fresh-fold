import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/order_view_model.dart';
import 'order_card.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewModel.completedOrders.isEmpty) {
          return Center(
            child: Text(
              'No completed orders',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: viewModel.completedOrders.length,
          itemBuilder: (context, index) {
            final schedule = viewModel.completedOrders[index];
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