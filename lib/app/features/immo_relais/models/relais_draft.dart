import 'dart:io';

import 'package:immoplus/app/data/enums/relais_availability_preset.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/enums/relais_reporter_relation.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';

/// État accumulé au fil des 2 écrans du flux "Publiez votre ancien
/// logement" (signalement anonyme, flux B — voir CLIENT-IMMO-RELAIS-API.md),
/// passé d'écran en écran jusqu'à l'envoi final. Pas de freezed ici : c'est
/// un brouillon local mutable, jamais sérialisé tel quel.
class RelaisDraft {
  RelaisPropertyType? propertyType;
  String? commune;
  Address? landmarkAddress;
  int rooms = 1;

  /// Max 3 — voir `ReportRelaisStep1Page._maxPhotos`.
  List<File> photos = [];

  RelaisAvailabilityPreset? availabilityPreset;
  RelaisReporterRelation? reporterRelation;
  String? reporterRelationDetails;
}
