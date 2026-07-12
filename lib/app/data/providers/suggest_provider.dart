import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../models/remote/suggest/suggest_response.dart';
import '../models/remote/suggest/suggest_click_payload.dart';

part 'suggest_provider.g.dart';

@RestApi()
abstract class SuggestProvider {
  factory SuggestProvider(Dio dio, {String baseUrl}) = _SuggestProvider;

  @GET("/suggest")
  Future<SuggestResponse> getSuggestions({
    @Query("q") required String query,
    @Query("limit") int? limit,
    @Query("lat") double? lat,
    @Query("lng") double? lng,
    @Query("category") String? category,
  });

  @POST("/suggest/click")
  Future<void> trackClick(
    @Body() SuggestClickPayload payload,
  );
}
