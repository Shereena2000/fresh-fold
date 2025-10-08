import 'package:cloud_firestore/cloud_firestore.dart';
import '../../notification/model/app_notification.dart';
import '../model/order_billing_model.dart';

class OrderBillingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Track processed notifications to avoid duplicates
  final Map<String, String> _processedPaymentStatuses = {};

  // Get billing details for a specific order
  Future<OrderBillingModel?> getBillingDetails(
    String userId,
    String scheduleId,
  ) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_requests')
          .doc(scheduleId)
          .get();

      if (doc.exists) {
        return OrderBillingModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get billing details: $e');
    }
  }

  // Stream billing details for real-time updates
  Stream<OrderBillingModel?> streamBilling(
    String userId,
    String scheduleId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('payment_requests')
        .doc(scheduleId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return OrderBillingModel.fromMap(snapshot.data()!);
      }
      return null;
    });
  }

  // Get all payment requests for a user
  Future<List<OrderBillingModel>> getAllPaymentRequests(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_requests')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderBillingModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get payment requests: $e');
    }
  }

  // Stream all payment requests for a user
  Stream<List<OrderBillingModel>> streamAllPaymentRequests(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('payment_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderBillingModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Update payment status (after successful payment)
  Future<void> updatePaymentStatus(
    String userId,
    String scheduleId,
    String status,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('payment_requests')
          .doc(scheduleId)
          .update({
        'paymentStatus': status,
        'updatedAt': Timestamp.now(),
      });

      // Create notification for payment status change
      await _createPaymentNotification(
        userId: userId,
        scheduleId: scheduleId,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Private method to create notification for payment events
  Future<void> _createPaymentNotification({
    required String userId,
    required String scheduleId,
    required String status,
  }) async {
    try {
      print('🔔 Creating payment notification: userId=$userId, scheduleId=$scheduleId, status=$status');
      
      CollectionReference notificationsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications');
      
      DocumentReference docRef = notificationsRef.doc();
      
      NotificationModel notification = NotificationModel(
        notificationId: docRef.id,
        userId: userId,
        scheduleId: scheduleId,
        status: status,
        message: NotificationModel.getMessageForStatus(status),
        createdAt: DateTime.now(),
        isRead: false,
      );
      
      await docRef.set(notification.toMap());
      print('✅ Payment notification created successfully: ${docRef.id}');
    } catch (e) {
      // Don't throw exception, just log it
      print('❌ Failed to create payment notification: $e');
    }
  }

  // Listen for payment request changes and create notifications
  // This should be called when monitoring payment_requests collection
  void setupPaymentRequestListener(String userId) {
    print('🔔 Setting up payment request listener for user: $userId');
    _firestore
        .collection('users')
        .doc(userId)
        .collection('payment_requests')
        .snapshots()
        .listen((snapshot) {
      print('📊 Payment request stream update: ${snapshot.docs.length} documents');
      
      for (var change in snapshot.docChanges) {
        print('🔄 Payment request change: ${change.type} - Doc ID: ${change.doc.id}');
        
        if (change.type == DocumentChangeType.added || 
            change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null) {
            final paymentStatus = data['paymentStatus'] as String?;
            final scheduleId = data['scheduleId'] as String?;
            
            print('💳 Payment status: $paymentStatus, Schedule ID: $scheduleId');
            
            if (paymentStatus != null && scheduleId != null) {
              // Create unique key for this payment status
              final statusKey = '$scheduleId:$paymentStatus';
              
              // Only create notification if this status hasn't been processed yet
              if (!_processedPaymentStatuses.containsKey(statusKey) ||
                  _processedPaymentStatuses[statusKey] != paymentStatus) {
                _processedPaymentStatuses[statusKey] = paymentStatus;
                
                print('🔔 Creating payment notification for: $statusKey');
                
                // Create notification for payment request or status change
                _createPaymentNotification(
                  userId: userId,
                  scheduleId: scheduleId,
                  status: paymentStatus,
                );
              } else {
                print('⚠️ Notification already processed for: $statusKey');
              }
            }
          }
        }
      }
    }, onError: (error) {
      print('❌ Payment request listener error: $error');
    });
  }
}
