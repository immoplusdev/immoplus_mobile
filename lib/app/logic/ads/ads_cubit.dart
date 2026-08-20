import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/enums/ad_event_type.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_event_payload.dart';
import 'package:immoplus/app/data/repositories/ad_repository.dart';
import 'package:immoplus/app/logic/ads/ads_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AdsCubit extends Cubit<AdsState> {
  final AdRepository _adRepository;
  final Set<String> _reportedImpressions = {}; // logs visibility: campaignId_placement

  AdsCubit(this._adRepository) : super(const AdsState.initial());

  Future<void> fetchActiveCampaigns() async {
    emit(const AdsState.loading());
    try {
      final response = await _adRepository.getActiveCampaigns();
      emit(AdsState.success(campaigns: response.data));
    } catch (e) {
      log('AdsCubit: Error fetching active campaigns: $e');
      emit(AdsState.error(message: e.toString()));
    }
  }

  void trackImpression(int campaignId, String placement) {
    final key = '${campaignId}_$placement';
    if (_reportedImpressions.contains(key)) return;
    _reportedImpressions.add(key);

    final sessionManager = getIt<SessionManager>();
    final userId = sessionManager.currentUser?.userId;

    final payload = AdEventPayload(
      campaignId: campaignId,
      placement: placement,
      type: AdEventType.impression.value,
      userId: userId,
      timestamp: DateTime.now().toUtc().toIso8601String(),
    );

    _adRepository.trackEvent(payload);
  }

  void trackClick(int campaignId, String placement) {
    final sessionManager = getIt<SessionManager>();
    final userId = sessionManager.currentUser?.userId;

    final payload = AdEventPayload(
      campaignId: campaignId,
      placement: placement,
      type: AdEventType.click.value,
      userId: userId,
      timestamp: DateTime.now().toUtc().toIso8601String(),
    );

    _adRepository.trackEvent(payload);
  }
}
