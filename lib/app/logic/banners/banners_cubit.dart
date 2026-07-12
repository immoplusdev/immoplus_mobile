import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/repositories/banner_repository.dart';
import 'package:immoplus/app/logic/banners/banners_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BannersCubit extends Cubit<BannersState> {
  final BannerRepository _bannerRepository;
  Timer? _pollingTimer;
  bool _isFetching = false;
  bool _isDismissed = false;

  BannersCubit(this._bannerRepository) : super(const BannersState.initial());

  /// Marque la bannière comme fermée par l'utilisateur
  void setDismissed(bool value) {
    _isDismissed = value;
    if (value) {
      log('BannersCubit: Banner dismissed, polling will be skipped.');
    }
  }

  /// Récupère les bannières.
  /// [isPolling] à true permet une mise à jour discrète (sans état de chargement UI).
  Future<void> fetchBanners({String? source, bool isPolling = false}) async {
    if (_isFetching) return;

    // Si c'est un polling et que la bannière est fermée, on ne fait rien
    if (isPolling && _isDismissed) return;

    _isFetching = true;

    if (isPolling) {
      log('BannersCubit: Polling banners background update...');
    }

    // On n'émet l'état loading que si ce n'est pas un polling et qu'on n'a pas déjà de données
    if (!isPolling && state is! BANNERS_SUCCESS) {
      emit(const BannersState.loading());
    }

    try {
      final response = await _bannerRepository.getBanners(
        source: source ?? AccountSource.customerApp.value,
      );

      final newBanners = response.data;

      // Comparaison intelligente pour éviter les rebuilds inutiles
      bool hasChanged = state.maybeWhen(
        success: (currentBanners) => !listEquals(currentBanners, newBanners),
        orElse: () => true,
      );

      if (hasChanged) {
        log('BannersCubit: Banners updated (${newBanners.length} found)');
        emit(BannersState.success(banners: newBanners));
      } else if (isPolling) {
        log('BannersCubit: Polling complete, no changes.');
      }
    } catch (e) {
      log('BannersCubit: Error fetching banners: $e');
      if (!isPolling) {
        emit(BannersState.error(message: e.toString()));
      }
    } finally {
      _isFetching = false;
    }
  }

  /// Démarre un polling "smart" (discret et économe)
  void startPolling(
      {String? source, Duration interval = const Duration(seconds: 10)}) {
    _pollingTimer?.cancel();
    log('BannersCubit: Starting polling every ${interval.inSeconds}s');
    _pollingTimer = Timer.periodic(interval, (_) {
      fetchBanners(source: source, isPolling: true);
    });
  }

  /// Arrête le polling
  void stopPolling() {
    if (_pollingTimer != null) {
      log('BannersCubit: Stopping polling');
      _pollingTimer?.cancel();
      _pollingTimer = null;
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
