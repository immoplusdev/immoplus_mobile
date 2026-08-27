import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/reverse_search_status.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

part 'reverse_search_model.freezed.dart';
part 'reverse_search_model.g.dart';

@freezed
class ReverseSearchZone with _$ReverseSearchZone {
  const factory ReverseSearchZone({
    required String adresse,
    required double lat,
    required double lng,
  }) = _ReverseSearchZone;

  factory ReverseSearchZone.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchZoneFromJson(json);
}

@freezed
class ReverseSearchRequest with _$ReverseSearchRequest {
  const factory ReverseSearchRequest({
    required List<ReverseSearchZone> zones,
    required DateTime dateDebut,
    required DateTime dateFin,
    required int nombrePersonnes,
    required double budgetMin,
    required double budgetMax,
    String? notes,
  }) = _ReverseSearchRequest;

  factory ReverseSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchRequestFromJson(json);
}

extension ReverseSearchRequestX on ReverseSearchRequest {
  /// Nombre de nuits recherchées, toujours au moins 1.
  int get nights {
    final diff = dateFin.difference(dateDebut).inDays;
    return diff > 0 ? diff : 1;
  }
}

@freezed
class ReverseSearchProposition with _$ReverseSearchProposition {
  const factory ReverseSearchProposition({
    required String reverseSearchId,

    /// Montant du séjour SANS les frais de paiement.
    required double montant,
    required ResidenceModel data,

    /// Prix par nuit, figé au moment de l'envoi de la vague.
    int? prixParNuit,
    int? nombreNuits,

    /// Frais de paiement (2%) appliqués à [montant].
    double? frais,

    /// Montant réellement facturé au paiement (montant + frais).
    required double montantTotal,
  }) = _ReverseSearchProposition;

  factory ReverseSearchProposition.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchPropositionFromJson(json);
}

/// Payload brut des propositions (renvoyé par l'événement socket et par GET /reverse-searches/:id dans "proposals").
@freezed
class ReverseSearchPropositionEvent with _$ReverseSearchPropositionEvent {
  const factory ReverseSearchPropositionEvent({
    required String reverseSearchId,
    required List<ResidenceModel> data,
  }) = _ReverseSearchPropositionEvent;

  factory ReverseSearchPropositionEvent.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchPropositionEventFromJson(json);
}

extension ReverseSearchPropositionEventX on ReverseSearchPropositionEvent {
  List<ReverseSearchProposition> toPropositions() {
    return data.map((residence) {
      final montant = residence.reverseSearchMontant ??
          residence.prixReservation.toDouble();
      // Montant réellement facturé au paiement (frais compris).
      final montantTotal = residence.reverseSearchMontantTotal ?? montant;
      return ReverseSearchProposition(
        reverseSearchId: reverseSearchId,
        montant: montant,
        montantTotal: montantTotal,
        frais: residence.reverseSearchFrais,
        prixParNuit: residence.reverseSearchPrixParNuit,
        nombreNuits: residence.reverseSearchNombreNuits,
        data: residence.copyWith(
          prixReservation: montantTotal > 0
              ? montantTotal.toInt()
              : (residence.prixReservation > 0
                  ? residence.prixReservation
                  : montantTotal.toInt()),
        ),
      );
    }).toList();
  }
}

@freezed
class ReverseSearchItem with _$ReverseSearchItem {
  const factory ReverseSearchItem({
    required String id,
    required String status,
    String? clientId,
    @Default([]) List<ReverseSearchZone> zones,
    DateTime? dateDebut,
    DateTime? dateFin,
    @Default(1) int nombrePersonnes,
    @Default(0) double budgetMin,
    @Default(0) double budgetMax,
    String? notes,
    @Default([]) List<String> eligibleResidenceIds,
    @Default([]) List<dynamic> proprietairesNotifies,
    String? residenceSelectionnee,
    double? montantSelectionne,
    DateTime? selectionExpireAt,
    @Default(0) int currentWave,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReverseSearchPropositionEvent? proposals,

    /// Id de la réservation créée une fois la recherche confirmée (statut `confirmee`).
    String? reservationId,
  }) = _ReverseSearchItem;

  factory ReverseSearchItem.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchItemFromJson(json);
}

@freezed
class ReverseSearchResponse with _$ReverseSearchResponse {
  const factory ReverseSearchResponse({
    required ReverseSearchItem data,
  }) = _ReverseSearchResponse;

  factory ReverseSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchResponseFromJson(json);
}

@freezed
class ReverseSearchesResponse with _$ReverseSearchesResponse {
  const factory ReverseSearchesResponse({
    @Default([]) List<ReverseSearchItem> data,
    int? currentPage,
    int? totalPages,
    int? pageSize,
    int? totalCount,
    bool? hasPrevious,
    bool? hasNext,
  }) = _ReverseSearchesResponse;

  factory ReverseSearchesResponse.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchesResponseFromJson(json);
}

extension ReverseSearchItemX on ReverseSearchItem {
  ReverseSearchStatus get statusEnum => ReverseSearchStatus.fromString(status);

  List<ReverseSearchProposition> get propositionsList =>
      proposals?.toPropositions() ?? [];

  /// Proposition correspondant à [residenceSelectionnee], si elle est encore
  /// présente dans les propositions chargées. Utile pour épingler la
  /// résidence verrouillée en attente de paiement (statut
  /// `selection_en_attente_paiement`).
  ReverseSearchProposition? get pendingSelectionProposition {
    final selectedId = residenceSelectionnee;
    if (selectedId == null) return null;
    for (final p in propositionsList) {
      if (p.data.id == selectedId) return p;
    }
    return null;
  }

  ReverseSearchRequest toRequest() {
    return ReverseSearchRequest(
      zones: zones,
      dateDebut: dateDebut ?? DateTime.now(),
      dateFin: dateFin ?? DateTime.now().add(const Duration(days: 4)),
      nombrePersonnes: nombrePersonnes,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      notes: notes,
    );
  }
}
