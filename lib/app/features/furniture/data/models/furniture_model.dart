class FurnitureModel {
  final String id;
  final String titre;
  final int prix;
  final String adresse;
  final List<String> images;
  final String? type;
  final String? category;
  final String? etat;
  final String? status;
  final String? createdAt;
  final double? lat;
  final double? lng;
  final FurnitureMetadata metadata;
  final String? ownerPhoneNumber;

  const FurnitureModel({
    required this.id,
    required this.titre,
    required this.prix,
    required this.adresse,
    required this.images,
    this.type,
    this.category,
    this.etat,
    this.status,
    this.createdAt,
    this.lat,
    this.lng,
    this.metadata = const FurnitureMetadata(),
    this.ownerPhoneNumber,
  });

  factory FurnitureModel.fromJson(Map<String, dynamic> json) {
    return FurnitureModel(
      id: json['id'] as String,
      titre: json['titre'] as String,
      prix: (json['prix'] as num).toInt(),
      adresse: json['adresse'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      type: json['type'] as String?,
      category: json['category'] as String?,
      etat: json['etat'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      metadata: FurnitureMetadata.fromJson(
        (json['metadata'] as Map<String, dynamic>?) ?? const {},
      ),
      ownerPhoneNumber: json['ownerPhoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titre': titre,
        'prix': prix,
        'adresse': adresse,
        'images': images,
        'type': type,
        'category': category,
        'etat': etat,
        'status': status,
        'createdAt': createdAt,
        'lat': lat,
        'lng': lng,
        'metadata': metadata.toJson(),
        'ownerPhoneNumber': ownerPhoneNumber,
      };

  String get firstImage => images.isNotEmpty ? images.first : '';
  bool get isActive => status?.toLowerCase() == 'active';
}

class FurnitureMetadata {
  final List<String> colors;

  const FurnitureMetadata({
    this.colors = const [],
  });

  factory FurnitureMetadata.fromJson(Map<String, dynamic> json) {
    return FurnitureMetadata(
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'colors': colors,
      };
}
