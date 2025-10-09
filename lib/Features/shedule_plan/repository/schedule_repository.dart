
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../notification/model/app_notification.dart';
import '../model/schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//client
  /// Create a new schedule under the user's document (Firebase auto-generates ID)
  Future<String> createSchedule(ScheduleModel schedule) async {
    try {
      CollectionReference schedulesRef = _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('schedules');
      
      DocumentReference docRef = schedulesRef.doc();
      
      ScheduleModel updatedSchedule = schedule.copyWith(
        scheduleId: docRef.id,
      );
      
      // Store in user's subcollection
      await docRef.set(updatedSchedule.toMap());
      
      // ALSO store in global schedules collection for shopkeeper access
      await _firestore
          .collection('schedules')
          .doc(docRef.id)
          .set(updatedSchedule.toMap());
      
      // Create initial notification
      await _createNotification(
        userId: schedule.userId,
        scheduleId: docRef.id,
        status: schedule.status,
      );
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  /// Update schedule status with notification
  Future<void> updateScheduleStatus(String userId, String scheduleId, String status) async {
    try {
      print('📝 Updating schedule status - userId: $userId, scheduleId: $scheduleId, status: $status');
      
      final updateData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Update in user's subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .doc(scheduleId)
          .update(updateData);
      
      print('✅ Schedule updated in user collection');

      // ALSO update in global schedules collection for shopkeeper
      // If document doesn't exist in global collection, create it first
      try {
        await _firestore
            .collection('schedules')
            .doc(scheduleId)
            .update(updateData);
      } catch (globalUpdateError) {
        // If global document doesn't exist, get the full document from user's collection and create it
        if (globalUpdateError.toString().contains('not-found')) {
          print('⚠️ Global schedule document not found, creating it...');
          
          // Get the full schedule from user's collection
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(userId)
              .collection('schedules')
              .doc(scheduleId)
              .get();
          
          if (userDoc.exists) {
            // Create the document in global collection with updated status
            Map<String, dynamic> scheduleData = userDoc.data() as Map<String, dynamic>;
            scheduleData['status'] = status;
            scheduleData['updatedAt'] = FieldValue.serverTimestamp();
            
            await _firestore
                .collection('schedules')
                .doc(scheduleId)
                .set(scheduleData);
            
            print('✅ Created missing global schedule document for $scheduleId');
          }
        } else {
          // Re-throw if it's a different error
          throw globalUpdateError;
        }
      }

      // Create notification for status change
      await _createNotification(
        userId: userId,
        scheduleId: scheduleId,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to update schedule status: $e');
    }
  }

  /// Simple method to create notification (avoids duplicates)
  Future<void> _createNotification({
    required String userId,
    required String scheduleId,
    required String status,
  }) async {
    try {
      print('🔔 Creating notification - userId: $userId, scheduleId: $scheduleId, status: $status');
      
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
      print('✅ Notification created successfully: ${notification.message}');
    } catch (e) {
      print('❌ Failed to create notification: $e');
    }
  }

  /// Get all schedules for a specific user from their subcollection
  Future<List<ScheduleModel>> getUserSchedules(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user schedules: $e');
    }
  }

  /// Get a specific schedule by ID from user's subcollection
  Future<ScheduleModel?> getScheduleById(String userId, String scheduleId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .doc(scheduleId)
          .get();

      if (doc.exists) {
        return ScheduleModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get schedule: $e');
    }
  }

  /// Update entire schedule
  Future<void> updateSchedule(ScheduleModel schedule) async {
    try {
      final updatedSchedule = schedule.copyWith(updatedAt: DateTime.now());
      final scheduleMap = updatedSchedule.toMap();
      
      // Update in user's subcollection
      await _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('schedules')
          .doc(schedule.scheduleId)
          .update(scheduleMap);
      
      // ALSO update in global schedules collection for shopkeeper
      await _firestore
          .collection('schedules')
          .doc(schedule.scheduleId)
          .update(scheduleMap);
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  /// Delete schedule
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    try {
      // Delete from user's subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .doc(scheduleId)
          .delete();
      
      // ALSO delete from global schedules collection
      await _firestore
          .collection('schedules')
          .doc(scheduleId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  /// Get schedules by status for a user
  Future<List<ScheduleModel>> getUserSchedulesByStatus(
    String userId,
    String status,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get schedules by status: $e');
    }
  }

  /// Stream of user schedules (real-time updates)
  Stream<List<ScheduleModel>> streamUserSchedules(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('schedules')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScheduleModel.fromMap(doc.data()))
            .toList());
  }

  /// Get upcoming schedules (future pickups)
  Future<List<ScheduleModel>> getUpcomingSchedules(String userId) async {
    try {
      DateTime now = DateTime.now();
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .where('pickupDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('pickupDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get upcoming schedules: $e');
    }
  }

  /// Get schedule history (past pickups)
  Future<List<ScheduleModel>> getScheduleHistory(String userId) async {
    try {
      DateTime now = DateTime.now();
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .where('pickupDate', isLessThan: Timestamp.fromDate(now))
          .orderBy('pickupDate', descending: true)
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get schedule history: $e');
    }
  }

  /// Helper method to sync user's schedules to global collection
  /// This is useful for migrating existing schedules
  Future<void> syncUserSchedulesToGlobal(String userId) async {
    try {
      // Get all schedules from user's subcollection
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .get();

      // Sync each schedule to global collection
      WriteBatch batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.set(
          _firestore.collection('schedules').doc(doc.id),
          doc.data(),
        );
      }

      await batch.commit();
      print('✅ Synced ${snapshot.docs.length} schedules to global collection for user $userId');
    } catch (e) {
      print('❌ Failed to sync schedules: $e');
      throw Exception('Failed to sync schedules: $e');
    }
  }
}