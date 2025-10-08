import 'package:flutter/material.dart';
import '../model/app_notification.dart';
import '../repository/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  // ==================== LOAD NOTIFICATIONS ====================

  Future<void> loadNotifications(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getUserNotifications(userId);
      _unreadCount = await _repository.getUnreadCount(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load notifications: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== STREAM NOTIFICATIONS ====================

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _repository.streamUserNotifications(userId);
  }

  Stream<int> streamUnreadCount(String userId) {
    return _repository.streamUnreadCount(userId);
  }

  // ==================== MARK AS READ ====================

  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _repository.markAsRead(userId, notificationId);
      
      // Update local list
      int index = _notifications.indexWhere((n) => n.notificationId == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to mark as read: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _repository.markAllAsRead(userId);
      
      // Update local list
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to mark all as read: ${e.toString()}';
      notifyListeners();
    }
  }

  // Mark all as read on navigation (silent, without showing errors)
  Future<void> markAllAsReadOnNavigate(String userId) async {
    try {
      await _repository.markAllAsRead(userId);
      
      // Update local list
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      // Silent error - don't show error message on navigation
      print('Failed to mark all as read on navigate: ${e.toString()}');
    }
  }

  // ==================== DELETE NOTIFICATIONS ====================

  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _repository.deleteNotification(userId, notificationId);
      
      // Remove from local list
      int index = _notifications.indexWhere((n) => n.notificationId == notificationId);
      if (index != -1) {
        if (!_notifications[index].isRead) {
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        }
        _notifications.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to delete notification: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteAllNotifications(String userId) async {
    try {
      await _repository.deleteAllNotifications(userId);
      _notifications.clear();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete all notifications: ${e.toString()}';
      notifyListeners();
    }
  }

  // ==================== UTILITY METHODS ====================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void updateUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }
}