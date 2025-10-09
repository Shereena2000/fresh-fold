import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/app_notification.dart';

/// Service that listens to schedule status changes and creates notifications automatically
class NotificationListenerService {
  // Singleton pattern
  static final NotificationListenerService _instance = NotificationListenerService._internal();
  factory NotificationListenerService() => _instance;
  NotificationListenerService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Keep track of initial statuses to avoid creating notifications on first load
  final Map<String, String> _initialStatuses = {};
  bool _isFirstLoad = true;
  bool _isListening = false;

  /// Start listening to schedule changes for a user
  void startListening(String userId) {
    if (_isListening) {
      print('⚠️ Listener already active, skipping...');
      return;
    }

    print('👂 Starting notification listener for user: $userId');
    _isListening = true;
    
    _firestore
        .collection('users')
        .doc(userId)
        .collection('schedules')
        .snapshots()
        .listen((snapshot) {
      print('📨 Received schedule snapshot - ${snapshot.docs.length} documents');
      _handleScheduleChanges(userId, snapshot);
    }, onError: (error) {
      print('❌ Notification listener error: $error');
      _isListening = false;
    });
  }

  /// Handle schedule changes and create notifications
  void _handleScheduleChanges(String userId, QuerySnapshot snapshot) {
    print('🔍 Processing ${snapshot.docChanges.length} changes...');
    
    for (var change in snapshot.docChanges) {
      final doc = change.doc;
      final data = doc.data() as Map<String, dynamic>?;
      
      if (data == null) {
        print('⚠️ Document has no data: ${doc.id}');
        continue;
      }
      
      final scheduleId = doc.id;
      final currentStatus = data['status'] as String?;
      
      print('📋 Document: $scheduleId, Type: ${change.type}, Status: $currentStatus');
      
      if (currentStatus == null) {
        print('⚠️ No status found for: $scheduleId');
        continue;
      }

      if (_isFirstLoad) {
        // First load - just store the statuses, don't create notifications
        _initialStatuses[scheduleId] = currentStatus;
        print('💾 Stored initial status: $scheduleId = $currentStatus');
      } else {
        // Check if status changed
        if (change.type == DocumentChangeType.modified) {
          final previousStatus = _initialStatuses[scheduleId];
          
          print('🔄 Modified: $scheduleId - Previous: $previousStatus, Current: $currentStatus');
          
          if (previousStatus != null && previousStatus != currentStatus) {
            print('✨ STATUS CHANGED! Creating notification...');
            _createNotification(userId, scheduleId, currentStatus);
          } else {
            print('➡️ Status unchanged, skipping notification');
          }
          
          // Update stored status
          _initialStatuses[scheduleId] = currentStatus;
        } else if (change.type == DocumentChangeType.added) {
          // New schedule added after initial load
          print('➕ New schedule added: $scheduleId with status $currentStatus');
          _initialStatuses[scheduleId] = currentStatus;
          _createNotification(userId, scheduleId, currentStatus);
        }
      }
    }
    
    // After first load, set flag to false
    if (_isFirstLoad && snapshot.docs.isNotEmpty) {
      _isFirstLoad = false;
      print('✅ Initial load complete! Loaded ${_initialStatuses.length} schedules');
      print('📊 Statuses: $_initialStatuses');
    }
  }

  /// Create notification when status changes
  Future<void> _createNotification(String userId, String scheduleId, String status) async {
    try {
      print('🔔 Creating notification...');
      print('   User: $userId');
      print('   Schedule: $scheduleId');
      print('   Status: $status');
      
      // Check if notification already exists to avoid duplicates
      print('🔍 Checking for existing notification...');
      final existingNotification = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('scheduleId', isEqualTo: scheduleId)
          .where('status', isEqualTo: status)
          .limit(1)
          .get();

      if (existingNotification.docs.isEmpty) {
        print('✨ No existing notification found, creating new one...');
        
        final notificationsRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('notifications');
        
        final docRef = notificationsRef.doc();
        final message = NotificationModel.getMessageForStatus(status);
        
        print('📝 Message: $message');
        
        final notification = NotificationModel(
          notificationId: docRef.id,
          userId: userId,
          scheduleId: scheduleId,
          status: status,
          message: message,
          createdAt: DateTime.now(),
          isRead: false,
        );
        
        print('💾 Saving to Firestore...');
        await docRef.set(notification.toMap());
        print('✅ NOTIFICATION CREATED SUCCESSFULLY!');
        print('   ID: ${docRef.id}');
        print('   Message: $message');
      } else {
        print('⚠️ Notification already exists for $scheduleId with status $status (skipping)');
      }
    } catch (e, stackTrace) {
      print('❌ ERROR creating notification: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Reset the service (useful when switching users)
  void reset() {
    _initialStatuses.clear();
    _isFirstLoad = true;
  }
}

