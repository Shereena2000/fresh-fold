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
    // Prevent unnecessary updates if data hasn't changed
    final allCurrentOrders = [
      ..._activePickups,
      ..._activeOrders,
      ..._completedOrders,
      ..._cancelledOrders
    ];
    
    if (allCurrentOrders.length == schedules.length) {
      bool hasChanged = false;
      for (int i = 0; i < schedules.length; i++) {
        if (i >= allCurrentOrders.length || 
            schedules[i].scheduleId != allCurrentOrders[i].scheduleId ||
            schedules[i].status != allCurrentOrders[i].status) {
          hasChanged = true;
          break;
        }
      }
      if (!hasChanged) return;
    }
    
    _categorizeSchedules(schedules);
    notifyListeners();
  }

  /// Categorize schedules into different lists based on status
  void _categorizeSchedules(List<ScheduleModel> allSchedules) {
    print('🔄 Categorizing ${allSchedules.length} total schedules');
    
    // Active Pickup: pending only
    _activePickups = allSchedules.where((s) => 
      s.status.toLowerCase() == 'pending'
    ).toList();
    print('📦 Active Pickups (pending): ${_activePickups.length}');

    // Active Orders: confirmed, picked_up, processing, ready, delivered
    _activeOrders = allSchedules.where((s) => 
      s.status.toLowerCase() == 'confirmed' || 
      s.status.toLowerCase() == 'picked_up' || 
      s.status.toLowerCase() == 'processing' || 
      s.status.toLowerCase() == 'ready' ||
      s.status.toLowerCase() == 'delivered'
    ).toList();
    print('📋 Active Orders (confirmed/picked_up/processing/ready/delivered): ${_activeOrders.length}');

    // Completed: paid only
    _completedOrders = allSchedules.where((s) => 
      s.status.toLowerCase() == 'paid'
    ).toList();
    print('✅ Completed (paid): ${_completedOrders.length}');

    // Cancelled: cancelled only
    _cancelledOrders = allSchedules.where((s) => 
      s.status.toLowerCase() == 'cancelled'
    ).toList();
    print('❌ Cancelled: ${_cancelledOrders.length}');
    
    print('📊 Final counts - Active Pickups: ${_activePickups.length}, Active Orders: ${_activeOrders.length}, Completed: ${_completedOrders.length}, Cancelled: ${_cancelledOrders.length}');
  }

  /// Stream orders for real-time updates
  Stream<List<ScheduleModel>> streamOrders(String userId) {
    return _repository.streamUserSchedules(userId);
  }

  /// Reschedule order with new date and time
  Future<void> rescheduleOrder(
    String userId, 
    String scheduleId, 
    DateTime newDate, 
    String newTimeSlot
  ) async {
    try {
      // Find the existing schedule
      ScheduleModel? existingSchedule;
      
      final allSchedules = [..._activePickups, ..._activeOrders, ..._completedOrders, ..._cancelledOrders];
      existingSchedule = allSchedules.firstWhere(
        (schedule) => schedule.scheduleId == scheduleId,
      );

      // Create updated schedule with status reset to pending
      ScheduleModel updatedSchedule = existingSchedule.copyWith(
        pickupDate: newDate,
        timeSlot: newTimeSlot,
        status: 'pending',  // Reset status to pending when rescheduled
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _repository.updateSchedule(updatedSchedule);

      // Refresh orders
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

  /// Sync all user schedules to global collection (for fixing sync issues)
  Future<void> syncAllSchedulesToGlobal(String userId) async {
    try {
      // Import the schedule repository to access sync method
      final scheduleRepository = ScheduleRepository();
      await scheduleRepository.syncUserSchedulesToGlobal(userId);
      await fetchOrders(userId); // Refresh the orders list
    } catch (e) {
      _errorMessage = 'Failed to sync schedules: $e';
      notifyListeners();
    }
  }
 
  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}