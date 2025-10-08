import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/order_billing_model.dart';

class OrderBillingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }
}
