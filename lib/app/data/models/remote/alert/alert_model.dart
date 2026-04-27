import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'property_type.dart';

part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

enum AlertTransactionType {
  buy('Acheter', 'acheter'),
  rent('Louer', 'louer'),
  reserve('Réserver', 'reserver');

  final String label;
  final String value;
  const AlertTransactionType(this.label, this.value);
}

enum AlertStatus {
  pending('pending', 'En attente', Color(0xFFFEF3C7), Color(0xFFD97706)),
  hasProposals('has_proposals', 'Proposition reçue', Color(0xFFE0F2FE),
      Color(0xff2744de)),
  closed('closed', 'Clôturée', Color(0xFFE5E7EB), Color(0xFF4B5563)),
  active('active', 'Active', Color(0xFFDCFCE7), Color(0xFF166534)),
  paused('paused', 'En pause', Color(0xFFF3F4F6), Color(0xFF374151)),
  deleted('deleted', 'Supprimée', Color(0xFFFEE2E2), Color(0xFF991B1B));

  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const AlertStatus(
      this.value, this.label, this.backgroundColor, this.textColor);

  static AlertStatus fromString(String? value) {
    return AlertStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertStatus.pending,
    );
  }
}

enum AlertTargetType {
  bienImmobilier("bien_immobilier"),
  residence("residence"),
  furniture("furniture");

  final String value;
  const AlertTargetType(this.value);

  static AlertTargetType fromString(String? value) {
    return AlertTargetType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertTargetType.bienImmobilier,
    );
  }
}

@freezed
class AlertModel with _$AlertModel {
  const AlertModel._();

  const factory AlertModel({
    required String id,
    required String userId,
    required String? title,
    required String? targetType,
    String? descriptionClient,
    required AlertCriteriaModel criteria,
    required String status,
    required int? matchCount,
    int? unreadMatchCount,
    DateTime? lastViewedAt,
    required DateTime? expiresAt,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _AlertModel;

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  AlertStatus get statusEnum => AlertStatus.fromString(status);

  AlertTargetType get targetTypeEnum => AlertTargetType.fromString(targetType);
}

@freezed
class AlertCriteriaModel with _$AlertCriteriaModel {
  const AlertCriteriaModel._();

  const factory AlertCriteriaModel({
    List<String>? extras,
    String? location,
    @JsonKey(name: 'price_min') int? priceMin,
    @JsonKey(name: 'price_max') int? priceMax,
    @JsonKey(name: 'rooms_min') int? roomsMin,
    @JsonKey(name: 'rooms_max') int? roomsMax,
    @JsonKey(name: 'surface_min') int? surfaceMin,
    @JsonKey(name: 'property_type') String? propertyType,
    @JsonKey(name: 'transaction_type') String? transactionType,
  }) = _AlertCriteriaModel;

  factory AlertCriteriaModel.fromJson(Map<String, dynamic> json) =>
      _$AlertCriteriaModelFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      if (extras != null && extras!.isNotEmpty) 'extras': extras,
      if (location != null) 'location': location,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
      if (roomsMin != null) 'rooms_min': roomsMin,
      if (roomsMax != null) 'rooms_max': roomsMax,
      if (surfaceMin != null) 'surface_min': surfaceMin,
      if (propertyType != null) 'property_type': propertyType,
      if (transactionType != null) 'transaction_type': transactionType,
    };
  }

  AlertPropertyType? get propertyTypeObj {
    if (propertyType == null) return null;
    for (var choice in selectableChoice) {
      if (choice.backendSlug.toLowerCase() == propertyType!.toLowerCase()) {
        return choice;
      }
    }
    return null;
  }

  AlertTransactionType get transactionTypeEnum {
    return AlertTransactionType.values.firstWhere(
      (e) => e.value == transactionType,
      orElse: () => AlertTransactionType.buy,
    );
  }
}
