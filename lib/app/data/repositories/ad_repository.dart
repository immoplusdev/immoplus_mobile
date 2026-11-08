import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_event_payload.dart';
import 'package:immoplus/app/data/providers/ad_provider.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AdRepository {
  final dioClient = getIt<Dio>();

  Future<AdCampaignListResponse> getActiveCampaigns() async {
    try {
      return await AdProvider(dioClient).getActiveCampaigns();
    } on DioException catch (dioError) {
      log('DioError when loading campaigns: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error when loading campaigns: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<void> trackEvent(AdEventPayload payload) async {
    try {
      await AdProvider(dioClient).trackEvent(payload);
    } on DioException catch (dioError) {
      log('DioError when tracking event: ${dioError.message}');
    } catch (error) {
      log('Error when tracking event: $error');
    }
  }
}
