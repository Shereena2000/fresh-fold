import 'package:flutter/material.dart';
import '../../../shedule_plan/model/schedule_model.dart';
import 'order_card.dart';

class Cancelled extends StatefulWidget {
  const Cancelled({super.key});

  @override
  State<Cancelled> createState() => _CancelledState();
}

class _CancelledState extends State<Cancelled> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    final schedules = [
      ScheduleModel(
        scheduleId: '496004',
        userId: 'user123',
        serviceType: 'regular',
        washType: 'press_only',
        pickupLocation: 'Home Address, Mumbai',
        pickupDate: DateTime(2025, 9, 28),
        timeSlot: '5 PM-7 PM',
        status: 'cancelled',
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
