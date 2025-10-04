import 'package:flutter/material.dart';

import '../../../shedule_plan/model/schedule_model.dart';
import 'order_card.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    final schedules = [
      ScheduleModel(
        scheduleId: '496005',
        userId: 'user123',
        serviceType: 'premium',
        washType: 'dry_clean',
        pickupLocation: 'Office Address, Mumbai',
        pickupDate: DateTime(2025, 10, 1),
        timeSlot: '3 PM-5 PM',
        status: 'completed',
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
