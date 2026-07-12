enum TargetTypeEnum {
  bienImmobilier("bien_immobilier"),
  residence("residence"),
  furniture("furniture");

  final String value;
  const TargetTypeEnum(this.value);
}

class AlertPropertyType {
  final String icon;
  final String backendSlug;
  final String label;

  const AlertPropertyType({
    required this.icon,
    required this.backendSlug,
    required this.label,
  });

  // Méthode utile pour la comparaison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertPropertyType &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          backendSlug == other.backendSlug;

  @override
  int get hashCode => icon.hashCode ^ backendSlug.hashCode;
}

List<AlertPropertyType> selectableChoice = [
  const AlertPropertyType(
    icon: 'assets/icons/property_type/appart.svg',
    backendSlug: 'appartement',
    label: 'Appartement',
  ),
  const AlertPropertyType(
    icon: 'assets/icons/property_type/duplex.svg',
    backendSlug: 'maison',
    label: 'Maison',
  ),
  const AlertPropertyType(
    icon: 'assets/icons/property_type/villa.svg',
    backendSlug: 'villa',
    label: 'Villa',
  ),
  const AlertPropertyType(
    icon: 'assets/icons/property_type/terrain.svg',
    backendSlug: 'terrain',
    label: 'Terrain',
  ),
];
