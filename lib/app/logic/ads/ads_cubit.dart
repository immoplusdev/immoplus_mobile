import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/enums/ad_event_type.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_event_payload.dart';
import 'package:immoplus/app/data/repositories/ad_repository.dart';
import 'package:immoplus/app/logic/ads/ads_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AdsCubit extends Cubit<AdsState> {
  final AdRepository _adRepository;
  final Set<String> _reportedImpressions =
      {}; // logs visibility: campaignId_placement

  AdsCubit(this._adRepository) : super(const AdsState.initial());

  Future<void> fetchActiveCampaigns() async {
    emit(const AdsState.loading());
    try {
      final response = await _adRepository.getActiveCampaigns();
      emit(AdsState.success(campaigns: response.data));
      // Mock data for UI testing
      // final mockData = [
      //   AdCampaignModel(
      //     id: 33,
      //     placement: 'LOCATION_LIST',
      //     positionIndex: 0,
      //     campaignCategory: 'VILLE_ADS',
      //     type: 'CAROUSEL',
      //     content: const AdCampaignContent(
      //       title: 'Belle Villa Cocody',
      //       subtitle: 'Découvrez notre sélection de villas à Cocody',
      //       ctaLabel: 'En savoir plus',
      //     ),
      //     media: const AdCampaignMedia(
      //       images: [
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //       ],
      //       videos: [],
      //     ),
      //     action: 'OPEN_PROPERTY',
      //     scope: const AdCampaignScope(
      //       filters: {},
      //       entityId: null,
      //       entityIds: [
      //         '407593e2-9a0a-48d1-9cda-5845d6c3196c',
      //         'e4b86e3d-87e2-4c18-b4f1-7d3e8e18422f',
      //         '4d663d64-940a-4c92-a385-4e8566e5b35a',
      //         // 'ab43c0ab-ac2d-49da-800a-6195967dd8f9',
      //       ],
      //     ),
      //     url: '',
      //     priority: 10,
      //     status: 'ACTIVE',
      //   ),
      //   AdCampaignModel(
      //     id: 34,
      //     placement: 'LOCATION_LIST',
      //     positionIndex: 1,
      //     campaignCategory: 'OFFRE SPECIAL',
      //     type: 'CAROUSEL',
      //     content: const AdCampaignContent(
      //       badge: 'Offre specialee',
      //       title: 'Penthouse luxe F4',
      //       subtitle: 'Macory, Residenciel',
      //     ),
      //     media: const AdCampaignMedia(
      //       images: [
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //       ],
      //       videos: [],
      //     ),
      //     action: 'OPEN_PROPERTY',
      //     url: '',
      //     priority: 9,
      //     status: 'ACTIVE',
      //   ),
      //   AdCampaignModel(
      //     id: 35,
      //     placement: 'PROPERTY_LIST_TOP',
      //     positionIndex: 0,
      //     campaignCategory: 'OFFRE SPECIAL',
      //     type: 'CAROUSEL',
      //     content: const AdCampaignContent(
      //       badge: 'Offre special',
      //       title: 'Penthouse luxe F4',
      //       subtitle: 'Macory, Residenciel',
      //       ctaLabel: 'tout savoir',
      //     ),
      //     media: const AdCampaignMedia(
      //       images: [
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //         '1d1a76a6-145c-43f3-9955-8332bfb9daea',
      //       ],
      //       videos: [],
      //     ),
      //     action: 'NONE',
      //     url: '',
      //     priority: 8,
      //     status: 'ACTIVE',
      //   ),
      // ];
      // emit(AdsState.success(campaigns: mockData));
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
