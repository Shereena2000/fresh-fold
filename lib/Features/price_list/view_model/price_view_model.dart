import 'package:flutter/material.dart';
import '../model/price_item.dart';
import '../repository/price_repository.dart';

class PriceViewModel extends ChangeNotifier {
  final PriceRepository _repository = PriceRepository();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Map<String, List<PriceItemModel>> _categoryItems = {
    'regular': [],
    'express': [],
    'premium': [],
  };

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  
  List<PriceItemModel> getItemsForCategory(String category) {
    return _categoryItems[category] ?? [];
  }

  // ==================== LOAD ITEMS ====================

  Future<void> loadCategoryItems(String category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categoryItems[category] = await _repository.getCategoryItems(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load items: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        loadCategoryItems('regular'),
        loadCategoryItems('express'),
        loadCategoryItems('premium'),
      ]);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load categories: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== STREAM ITEMS ====================

  Stream<List<PriceItemModel>> streamCategoryItems(String category) {
    return _repository.streamCategoryItems(category);
  }

 

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  String getCategoryDisplayName(String category) {
    switch (category) {
      case 'regular':
        return 'Regular (2-3 Days)';
      case 'express':
        return 'Express (24 Hours)';
      case 'premium':
        return 'Premium (Same Day)';
      default:
        return category;
    }
  }
}