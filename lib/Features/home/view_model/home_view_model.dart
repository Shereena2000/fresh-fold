import 'package:flutter/material.dart';
import '../../promo/model/promo_model.dart';
import '../../promo/repository/promo_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PromoRepository _promoRepository = PromoRepository();

  List<PromoModel> _promos = [];
  bool _isLoadingPromos = true;
  String? _errorMessage;
  int _currentPromoPage = 0;

  // Getters
  List<PromoModel> get promos => _promos;
  bool get isLoadingPromos => _isLoadingPromos;
  String? get errorMessage => _errorMessage;
  int get currentPromoPage => _currentPromoPage;

  /// Load promos from Firestore
  Future<void> loadPromos() async {
    _isLoadingPromos = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _promos = await _promoRepository.getPromos();
      _isLoadingPromos = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load promos: $e';
      _isLoadingPromos = false;
      notifyListeners();
    }
  }

  /// Update current promo page for carousel
  void updateCurrentPromoPage(int page) {
    _currentPromoPage = page;
    notifyListeners();
  }

  /// Stream promos for real-time updates
  Stream<List<PromoModel>> streamPromos() {
    return _promoRepository.streamPromos();
  }
}