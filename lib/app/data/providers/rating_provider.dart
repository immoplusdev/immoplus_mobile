import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../models/remote/rating/rating_request.dart';
import '../models/remote/rating/rating_history_response.dart';

part 'rating_provider.g.dart';

@RestApi()
abstract class RatingProvider {
  factory RatingProvider(Dio dio, {String baseUrl}) = _RatingProvider;

  @POST("/ratings/client")
  Future<void> createClientRating(@Body() RatingRequest request);

  @GET("/ratings/history")
  Future<RatingHistoryResponse> getRatingHistory({
    @Query("page") int? page,
    @Query("perPage") int? perPage,
  });
}
