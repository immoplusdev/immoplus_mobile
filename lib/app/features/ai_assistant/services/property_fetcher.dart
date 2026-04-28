import 'dart:developer' as dev;

import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_single.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_response.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_response.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';

import '../models/property_card_data.dart';

/// Service qui fetch les détails des biens immobiliers et retourne des PropertyCardData.
class PropertyFetcher {
  const PropertyFetcher(
    this._bienRepo,
    this._residenceRepo,
    this._furnitureRepo,
  );

  final BienImmobilierRepository _bienRepo;
  final ResidenceRepository _residenceRepo;
  final FurnitureRepository _furnitureRepo;

  /// Fetch jusqu'à 3 sources et retourne une liste de PropertyCardData.
  Future<List<PropertyCardData>> fetchSources(List<dynamic> sources) async {
    final results = <PropertyCardData>[];
    for (final src in sources.take(3)) {
      final bienId = src['bienId'] as String?;
      final entityType = src['entityType'] as String?;
      if (bienId == null) continue;

      final cardData = await _fetchOne(bienId, entityType);
      if (cardData != null) results.add(cardData);
    }
    return results;
  }

  /// Fetch un bien unique par ID et type.
  Future<PropertyCardData?> _fetchOne(
    String bienId,
    String? entityType,
  ) async {
    try {
      return switch (entityType) {
        'RESIDENCE' => _createPropertyCard(
            await _residenceRepo.getResidence(bienId),
            'RESIDENCE',
          ),
        'FURNITURE' => _createPropertyCard(
            await _furnitureRepo.getFurniture(bienId),
            'FURNITURE',
          ),
        _ => _createPropertyCard(
            await _bienRepo.getBiensImmobilier(bienId),
            'BIEN_IMMOBILIER',
          ),
      };
    } catch (e) {
      dev.log('PropertyFetcher error for $bienId: $e');
      return null;
    }
  }

  /// Créer PropertyCardData depuis une réponse API.
  PropertyCardData? _createPropertyCard(dynamic response, String entityType) {
    final model = _extractModel(response);
    if (model == null) return null;
    return PropertyCardData(
      entityType: entityType,
      model: model,
    );
  }

  /// Extraire le modèle de la réponse API selon le type.
  dynamic _extractModel(dynamic response) {
    if (response == null) return null;

    // Pour BienImmobilierSingle
    if (response is BienImmobilierSingle) {
      return response.data;
    }

    // Pour ResidenceResponse
    if (response is ResidenceResponse) {
      return response.data;
    }

    // Pour FurnitureResponse
    if (response is FurnitureResponse) {
      return response.data;
    }

    return null;
  }
}
