import 'package:flutter/material.dart';

import '../../../../Settings/constants/sized_box.dart';
import '../../../shedule_plan/model/schedule_model.dart';
import 'order_card.dart';

class ActiveOrder extends StatefulWidget {
  const ActiveOrder({super.key});

  @override
  State<ActiveOrder> createState() => _ActiveOrderState();
}

class _ActiveOrderState extends State<ActiveOrder> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    // Example data
    final schedules = [
      ScheduleModel(
        scheduleId: '496007',
        userId: 'user123',
        serviceType: 'express',
        washType: 'wash_press',
        pickupLocation: 'Home Address, Mumbai',
        pickupDate: DateTime(2025, 10, 5),
        timeSlot: '11 AM-1 PM',
        status: 'in_progress',
        createdAt: DateTime.now(),
      ),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return OrderCard(
          schedule: schedule,
          isExpanded: expandedCards.contains(schedule.scheduleId),
          onToggleExpand: () {
            setState(() {
              if (expandedCards.contains(schedule.scheduleId)) {
                expandedCards.remove(schedule.scheduleId);
              } else {
                expandedCards.add(schedule.scheduleId);
              }
            });
          },
        );
      },
    );
  }
}
