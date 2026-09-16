import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/home_feed/home_feed_response.dart';

part 'home_feed_provider.g.dart';

@RestApi(baseUrl: null)
abstract class HomeFeedProvider {
  factory HomeFeedProvider(Dio dio, {String baseUrl}) = _HomeFeedProvider;

  @GET("/me/home")
  Future<HomeFeedApiResponse> getHomeFeed({
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("cursor") String? cursor,
    @Query("limit") int? limit,
    @Query("device_id") String? deviceId,
  });
}
