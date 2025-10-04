import 'package:flutter/material.dart';

import '../../../shedule_plan/model/schedule_model.dart';
import 'order_card.dart';

class ActivePickup extends StatefulWidget {
  const ActivePickup({super.key});

  @override
  State<ActivePickup> createState() => _ActivePickupState();
}

class _ActivePickupState extends State<ActivePickup> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    // Example data - Replace with your actual data
    final schedules = [
      ScheduleModel(
        scheduleId: '496006',
        userId: 'user123',
        serviceType: 'regular',
        washType: 'dry_clean',
        pickupLocation: '134, XR5J+7RG, Mohammed Ali Rd, Bhuleshwar, Mumbai, Maharashtra 400003, India',
        latitude: 18.9512,
        longitude: 72.8326,
        pickupDate: DateTime(2025, 10, 4),
        timeSlot: '9 AM-11 AM',
        status: 'pickup_requested',
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
          onReschedule: () {
            // Handle reschedule
          },
          onCancel: () {
            // Handle cancel
          },
        );
      },
    );
  }
}
