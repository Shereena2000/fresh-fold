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
  Future<void> rescheduleOrder(String userId, String scheduleId) async {
    try {
      // TODO: Navigate to schedule screen with pre-filled data
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