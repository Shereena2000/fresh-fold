import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new schedule under the user's document (Firebase auto-generates ID)
  Future<String> createSchedule(ScheduleModel schedule) async {
    try {
      // Reference to the user's schedules subcollection
      CollectionReference schedulesRef = _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('schedules');
      
      // Create a new document reference (Firebase will auto-generate ID)
      DocumentReference docRef = schedulesRef.doc();
      
      // Update schedule with the generated ID
      ScheduleModel updatedSchedule = schedule.copyWith(
        scheduleId: docRef.id,
      );
      
      // Save to Firestore
      await docRef.set(updatedSchedule.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
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

  /// Update schedule status
  Future<void> updateScheduleStatus(String userId, String scheduleId, String status) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .doc(scheduleId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update schedule status: $e');
    }
  }

  /// Update entire schedule
  Future<void> updateSchedule(ScheduleModel schedule) async {
    try {
      await _firestore
          .collection('users')
          .doc(schedule.userId)
          .collection('schedules')
          .doc(schedule.scheduleId)
          .update(schedule.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  /// Delete schedule
  Future<void> deleteSchedule(String userId, String scheduleId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
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
}