import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/price_item.dart';

class PriceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection paths
  String _getPriceListPath(String category) => 'priceList/$category/items';




  /// Get all items for a category
  Future<List<PriceItemModel>> getCategoryItems(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_getPriceListPath(category))
          .orderBy('order', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => PriceItemModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get price items: $e');
    }
  }

  /// Stream items for a category (real-time)
  Stream<List<PriceItemModel>> streamCategoryItems(String category) {
    return _firestore
        .collection(_getPriceListPath(category))
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PriceItemModel.fromMap(doc.data()))
            .toList());
  }

  
  }
