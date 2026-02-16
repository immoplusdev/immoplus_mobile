import 'furniture_model.dart';
import 'seller_contact_model.dart';

class FurnitureDetailModel {
  final String id;
  final String titre;
  final String description;
  final int prix;
  final String adresse;
  final List<String> images;
  final String? type;
  final String? category;
  final String? etat;
  final String? video;
  final String? status;
  final String? createdAt;
  final int viewsCount;
  final double? lat;
  final double? lng;
  final FurnitureMetadata metadata;
  final String? ownerPhoneNumber;
  final SellerContactModel seller;

  const FurnitureDetailModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.adresse,
    required this.images,
    required this.seller,
    this.type,
    this.category,
    this.etat,
    this.video,
    this.status,
    this.createdAt,
    this.viewsCount = 0,
    this.lat,
    this.lng,
    this.metadata = const FurnitureMetadata(),
    this.ownerPhoneNumber,
  });

  factory FurnitureDetailModel.fromJson(Map<String, dynamic> json) {
    // Gere si le JSON est deja l'objet ou enveloppe dans 'data'
    final d = (json['data'] ?? json) as Map<String, dynamic>;

    return FurnitureDetailModel(
      id: d['id'] as String,
      titre: d['titre'] as String,
      description: d['description'] as String? ?? '',
      prix: (d['prix'] as num).toInt(),
      adresse: d['adresse'] as String,
      images:
          (d['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      type: d['type'] as String?,
      category: d['category'] as String?,
      etat: d['etat'] as String?,
      video: d['video'] as String?,
      status: d['status'] as String?,
      createdAt: d['createdAt'] as String?,
      viewsCount: (d['viewsCount'] as num?)?.toInt() ?? 0,
      lat: (d['lat'] as num?)?.toDouble(),
      lng: (d['lng'] as num?)?.toDouble(),
      metadata: FurnitureMetadata.fromJson(
        (d['metadata'] as Map<String, dynamic>?) ?? const {},
      ),
      ownerPhoneNumber: d['ownerPhoneNumber'] as String?,
      seller: SellerContactModel.fromJson(
        (d['seller'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }

  bool get hasLocation => lat != null && lng != null;
}
