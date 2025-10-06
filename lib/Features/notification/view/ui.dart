import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notification data - in real app, this would come from API
    final List<NotificationModel> notifications = [
      NotificationModel(
        status: 'pending',
        message: "Your pickup request has been received! We'll confirm your schedule soon.",
        time: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      NotificationModel(
        status: 'confirmed',
        message: "Pickup confirmed! Our agent will arrive tomorrow at 10 AM.",
        time: DateTime.now().subtract(Duration(hours: 2)),
      ),
      NotificationModel(
        status: 'picked_up',
        message: "Your clothes have been picked up and are on the way to our facility.",
        time: DateTime.now().subtract(Duration(hours: 5)),
      ),
      NotificationModel(
        status: 'processing',
        message: "Your laundry is being washed and processed.",
        time: DateTime.now().subtract(Duration(hours: 8)),
      ),
      NotificationModel(
        status: 'ready',
        message: "Your clothes are ready for delivery. Please schedule a delivery time.",
        time: DateTime.now().subtract(Duration(days: 1)),
      ),
      NotificationModel(
        status: 'delivery_scheduled',
        message: "Your delivery has been scheduled for today at 6 PM.",
        time: DateTime.now().subtract(Duration(days: 1)),
      ),
      NotificationModel(
        status: 'delivered',
        message: "Order delivered! We hope you're happy with your fresh clothes.",
        time: DateTime.now().subtract(Duration(days: 2)),
      ),
          NotificationModel(
        status: 'cancelled',
        message: "Order delivered! We hope you're happy with your fresh clothes.",
        time: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(title: "Notifications"),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NotificationCard(notification: notifications[index]),
          );
        },
      ),
    );
  }
}

class NotificationModel {
  final String status;
  final String message;
  final DateTime time;

  NotificationModel({
    required this.status,
    required this.message,
    required this.time,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  // Method to get icon based on status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions_rounded;
      case 'confirmed':
        return Icons.event_available_rounded;
      case 'picked_up':
        return Icons.local_shipping_rounded;
      case 'processing':
        return Icons.local_laundry_service_rounded;
      case 'ready':
        return Icons.iron_rounded;
      case 'delivery_scheduled':
        return Icons.celebration_rounded;
      case 'delivered':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // Method to format time difference
  String _getTimeDifference(DateTime time) {
    final difference = DateTime.now().difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.primaryColor.withOpacity(0.3)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(notification.status),
                color: PColors.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: PTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [Spacer(),
                      Text(
                        _getTimeDifference(notification.time),
                        style: PTextStyles.labelSmall.copyWith(
                          color: PColors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}