import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/remote/ads/ad_campaign_model.dart';
import '../models/remote/ads/ad_event_payload.dart';

part 'ad_provider.g.dart';

@RestApi()
abstract class AdProvider {
  factory AdProvider(Dio dio, {String baseUrl}) = _AdProvider;

  @GET("/ads/campaigns/active")
  Future<AdCampaignListResponse> getActiveCampaigns();

  @POST("/ads/events")
  Future<void> trackEvent(@Body() AdEventPayload payload);
}
