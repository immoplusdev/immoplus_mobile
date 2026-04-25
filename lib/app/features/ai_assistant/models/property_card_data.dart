/// Wrapper qui contient un modèle de propriété (bien/résidence/meublé) avec son type.
class PropertyCardData {
  const PropertyCardData({
    required this.entityType,
    required this.model,
  });

  /// 'BIEN_IMMOBILIER', 'RESIDENCE', ou 'FURNITURE'
  final String entityType;

  /// BienImmobilierModel, ResidenceModel, ou FurnitureModel
  final dynamic model;
}
