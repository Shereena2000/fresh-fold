import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String scheduleId;
  final String status;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.scheduleId,
    required this.status,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'scheduleId': scheduleId,
      'status': status,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  // Create from Firestore document
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? '',
      userId: map['userId'] ?? '',
      scheduleId: map['scheduleId'] ?? '',
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  // Copy with method
  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? scheduleId,
    String? status,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      scheduleId: scheduleId ?? this.scheduleId,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  // Get notification message based on status
  static String getMessageForStatus(String status) {
    switch (status) {
      case 'pending':
        return "Your pickup request has been received! We'll confirm your schedule soon.";
      case 'confirmed':
        return "Pickup confirmed! Our agent will arrive at your scheduled time.";
      case 'picked_up':
        return "Your clothes have been picked up and are on the way to our facility.";
      case 'processing':
        return "Your laundry is being washed and processed with care.";
      case 'ready':
        return "Your clothes are ready for delivery! Please schedule a delivery time.";
      case 'delivery_scheduled':
        return "Your delivery has been scheduled. We'll deliver soon!";
      case 'delivered':
        return "Order delivered! We hope you're happy with your fresh clothes.";
      case 'cancelled':
        return "Your order has been cancelled. Contact us if you need assistance.";
      default:
        return "Status updated for your order.";
    }
  }
}