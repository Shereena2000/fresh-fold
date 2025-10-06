import 'package:flutter/material.dart';
import '../../shedule_plan/model/schedule_model.dart';
import '../../shedule_plan/repository/schedule_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();
  
  // Expanded cards state
  final Set<String> _expandedCards = {};
  Set<String> get expandedCards => _expandedCards;

  void toggleExpand(String scheduleId) {
    if (_expandedCards.contains(scheduleId)) {
      _expandedCards.remove(scheduleId);
    } else {
      _expandedCards.add(scheduleId);
    }
    notifyListeners();
  }

  bool isExpanded(String scheduleId) {
    return _expandedCards.contains(scheduleId);
  }

  // Schedule lists
  List<ScheduleModel> _activePickups = [];
  List<ScheduleModel> _activeOrders = [];
  List<ScheduleModel> _completedOrders = [];
  List<ScheduleModel> _cancelledOrders = [];

  List<ScheduleModel> get activePickups => _activePickups;
  List<ScheduleModel> get activeOrders => _activeOrders;
  List<ScheduleModel> get completedOrders => _completedOrders;
  List<ScheduleModel> get cancelledOrders => _cancelledOrders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetch all orders for a user and categorize them
  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<ScheduleModel> allSchedules = await _repository.getUserSchedules(userId);
      _categorizeSchedules(allSchedules);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update orders from stream (real-time updates)
  void updateFromStream(List<ScheduleModel> schedules) {
    _categorizeSchedules(schedules);
    notifyListeners();
  }

  /// Categorize schedules into different lists
  void _categorizeSchedules(List<ScheduleModel> allSchedules) {
    _activePickups = allSchedules.where((s) => 
      s.status == 'pending' || s.status == 'pickup_requested'
    ).toList();

    _activeOrders = allSchedules.where((s) => 
      s.status == 'confirmed' || 
      s.status == 'picked_up' || 
      s.status == 'processing' || 
      s.status == 'ready'
    ).toList();

    _completedOrders = allSchedules.where((s) => 
      s.status == 'delivered' || s.status == 'completed'
    ).toList();

    _cancelledOrders = allSchedules.where((s) => 
      s.status == 'cancelled'
    ).toList();
  }

  /// Stream orders for real-time updates
  Stream<List<ScheduleModel>> streamOrders(String userId) {
    return _repository.streamUserSchedules(userId);
  }

  /// Reschedule order
 /// Reschedule order with new date and time
Future<void> rescheduleOrder(
  String userId, 
  String scheduleId, 
  DateTime newDate, 
  String newTimeSlot
) async {
  try {
    // 1. Find the existing schedule that needs to be updated
    ScheduleModel? existingSchedule;
    
    // Search through all order lists to find the schedule
    final allSchedules = [..._activePickups, ..._activeOrders, ..._completedOrders, ..._cancelledOrders];
    existingSchedule = allSchedules.firstWhere(
      (schedule) => schedule.scheduleId == scheduleId,
    );

    if (existingSchedule == null) {
      _errorMessage = 'Order not found.';
      notifyListeners();
      return;
    }

    // 2. Create an updated schedule model with the new date and time
    ScheduleModel updatedSchedule = existingSchedule.copyWith(
      pickupDate: newDate,
      timeSlot: newTimeSlot,
      updatedAt: DateTime.now(), // Track when the reschedule happened
      // Optionally, you can also reset the status here if needed, e.g.:
      // status: 'rescheduled'
    );

    // 3. Call the repository to update the schedule in Firestore
    await _repository.updateSchedule(updatedSchedule);

    // 4. Refresh the orders list to reflect the changes
    await fetchOrders(userId);

  } catch (e) {
    _errorMessage = 'Failed to reschedule: $e';
    notifyListeners();
  }
}

  /// Cancel order
  Future<void> cancelOrder(String userId, String scheduleId) async {
    try {
      await _repository.updateScheduleStatus(userId, scheduleId, 'cancelled');
      await fetchOrders(userId);
    } catch (e) {
      _errorMessage = 'Failed to cancel: $e';
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}