import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/enums/booking_mode.dart';
import 'package:immoplus/app/data/repositories/booking_mode_repository.dart';
import 'package:injectable/injectable.dart';

/// Mode de réservation du client (`PAY_NOW` / `REQUEST`), fourni par le
/// serveur. Partagé par toute l'app (singleton) : les boutons « Réserver » /
/// « Payer » le lisent, et le formulaire de réservation s'y adapte.
///
/// Sans réponse exploitable (invité, hors-ligne, endpoint indisponible), le
/// mode reste `REQUEST` (comportement historique, sans régression).
@lazySingleton
class BookingModeCubit extends Cubit<BookingMode> {
  BookingModeCubit(BookingModeRepository repository)
      : this.withInitial(repository, BookingMode.request);

  @visibleForTesting
  BookingModeCubit.withInitial(this._repository, BookingMode initial)
      : _initial = initial,
        super(initial);

  final BookingModeRepository _repository;

  /// Mode avant toute réponse du serveur.
  final BookingMode _initial;

  /// Relit le mode depuis le serveur (lancement, connexion, retour au premier
  /// plan). Échec silencieux : on garde le mode courant.
  Future<void> refresh() async {
    try {
      final model = await _repository.getBookingMode();
      if (!isClosed) emit(model.mode);
    } catch (e) {
      log('BookingModeCubit.refresh failed: $e', name: 'BOOKING_MODE');
    }
  }

  /// Déconnexion : retour au mode par défaut.
  void reset() => emit(_initial);
}
