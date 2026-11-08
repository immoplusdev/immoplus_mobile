import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_requirement.freezed.dart';
part 'payment_requirement.g.dart';

/// Part du séjour à régler en ligne pour confirmer la réservation.
enum PaymentRequirementLevel {
  @JsonValue('NONE')
  none,
  @JsonValue('DEPOSIT_25')
  deposit25,
  @JsonValue('DEPOSIT_50')
  deposit50,
  @JsonValue('DEPOSIT_75')
  deposit75,
  @JsonValue('FULL')
  full;

  /// Pourcentage d'acompte, ou `null` hors acompte.
  int? get depositPercent => switch (this) {
        deposit25 => 25,
        deposit50 => 50,
        deposit75 => 75,
        _ => null,
      };
}

/// Mode de règlement du séjour.
enum PaymentRequirementMode {
  @JsonValue('ON_ARRIVAL')
  onArrival,
  @JsonValue('DEPOSIT')
  deposit,
  @JsonValue('FULL_ONLINE')
  fullOnline,
}

/// Exigence de paiement calculée par le serveur (aperçu ou création de la
/// réservation). Le montant à payer vient toujours d'ici, jamais d'un calcul
/// local.
@freezed
class PaymentRequirement with _$PaymentRequirement {
  const PaymentRequirement._();

  const factory PaymentRequirement({
    @JsonKey(unknownEnumValue: PaymentRequirementLevel.full)
    @Default(PaymentRequirementLevel.full)
    PaymentRequirementLevel requirement,
    @JsonKey(unknownEnumValue: PaymentRequirementMode.fullOnline)
    @Default(PaymentRequirementMode.fullOnline)
    PaymentRequirementMode mode,
    @Default('XOF') String currency,
    @Default(0) double totalAmount,
    @Default(0) double amountDueNow,
    @Default(0) double remainingAmount,
    @Default(false) bool paymentOnArrivalEligible,
    DateTime? expiresAt,

    /// Libellé à afficher tel quel au client.
    @Default('') String protectionMessage,
  }) = _PaymentRequirement;

  factory PaymentRequirement.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequirementFromJson(json);

  /// Un paiement en ligne est demandé maintenant.
  bool get isPaymentDue => amountDueNow > 0;

  bool get isDeposit => mode == PaymentRequirementMode.deposit;
}

@freezed
class PaymentRequirementResponse with _$PaymentRequirementResponse {
  const factory PaymentRequirementResponse({
    required PaymentRequirement data,
  }) = _PaymentRequirementResponse;

  factory PaymentRequirementResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequirementResponseFromJson(json);
}
