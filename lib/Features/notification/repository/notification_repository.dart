import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_notification.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create notification when status changes
  Future<String> createNotification(NotificationModel notification) async {
    try {
      CollectionReference notificationsRef = _firestore
          .collection('users')
          .doc(notification.userId)
          .collection('notifications');
      
      DocumentReference docRef = notificationsRef.doc();
      
      NotificationModel updatedNotification = notification.copyWith(
        notificationId: docRef.id,
      );
      
      await docRef.set(updatedNotification.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Get all notifications for a user
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Stream notifications (real-time)
  Stream<List<NotificationModel>> streamUserNotifications(String userId) {
    print('📱 Setting up notification stream for user: $userId');
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('🔔 Notification stream update: ${snapshot.docs.length} notifications');
          return snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList();
        });
  }

  /// Mark notification as read
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      WriteBatch batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all as read: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Stream unread count
  Stream<int> streamUnreadCount(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Delete notification
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      WriteBatch batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }
}