import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/promo_model.dart';

class PromoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all promos ordered by creation date
  Future<List<PromoModel>> getPromos() async {
    try {
      final querySnapshot = await _firestore
          .collection('promos')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PromoModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error fetching promos: $e');
      return [];
    }
  }

  /// Stream promos for real-time updates
  Stream<List<PromoModel>> streamPromos() {
    return _firestore
        .collection('promos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PromoModel.fromMap(doc.data()))
          .toList();
    });
  }
}

