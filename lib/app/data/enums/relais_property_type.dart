import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

/// `propertyType` du flux Immo Relais (voir CLIENT-IMMO-RELAIS-API.md) —
/// distinct de `AlertPropertyType` (taxonomie différente : apartment,
/// studio, villa, duplex plutôt que appartement/maison/villa/terrain).
class RelaisPropertyType {
  final String backendSlug;
  final String label;
  final String? svgIcon;
  final IconData? fallbackIcon;

  const RelaisPropertyType({
    required this.backendSlug,
    required this.label,
    this.svgIcon,
    this.fallbackIcon,
  }) : assert(svgIcon != null || fallbackIcon != null);
}

const List<RelaisPropertyType> relaisPropertyTypes = [
  RelaisPropertyType(
    backendSlug: 'studio',
    label: 'Studio',
    fallbackIcon: Iconsax.grid_1,
  ),
  RelaisPropertyType(
    backendSlug: 'apartment',
    label: 'Appartement',
    svgIcon: 'assets/icons/property_type/appart.svg',
  ),
  RelaisPropertyType(
    backendSlug: 'villa',
    label: 'Villa',
    svgIcon: 'assets/icons/property_type/villa.svg',
  ),
  RelaisPropertyType(
    backendSlug: 'duplex',
    label: 'Duplex',
    svgIcon: 'assets/icons/property_type/duplex.svg',
  ),
];

/// Label lisible pour un `propertyType` reçu du backend (ex: dans une
/// carte de la liste `GET /relais`) — `null`/inconnu retombe sur la
/// valeur brute plutôt que de planter.
String relaisPropertyTypeLabel(String? backendSlug) {
  for (final type in relaisPropertyTypes) {
    if (type.backendSlug == backendSlug) return type.label;
  }
  return backendSlug ?? '';
}
