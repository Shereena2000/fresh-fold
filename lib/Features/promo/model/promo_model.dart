import 'package:cloud_firestore/cloud_firestore.dart';

class PromoModel {
  final String promoId;
  final String imageUrl;
  final String publicId;
  final String uploadedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PromoModel({
    required this.promoId,
    required this.imageUrl,
    required this.publicId,
    required this.uploadedBy,
    required this.createdAt,
    this.updatedAt,
  });

  // Create from Firestore document
  factory PromoModel.fromMap(Map<String, dynamic> map) {
    return PromoModel(
      promoId: map['promoId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      publicId: map['publicId'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'promoId': promoId,
      'imageUrl': imageUrl,
      'publicId': publicId,
      'uploadedBy': uploadedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

