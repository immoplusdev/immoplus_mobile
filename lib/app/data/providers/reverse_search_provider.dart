import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:retrofit/retrofit.dart';

part 'reverse_search_provider.g.dart';

@RestApi()
abstract class ReverseSearchProvider {
  factory ReverseSearchProvider(Dio dio) = _ReverseSearchProvider;

  @POST('/reverse-searches')
  Future<ReverseSearchResponse> createSearch(@Body() ReverseSearchRequest body);

  @GET('/reverse-searches')
  Future<ReverseSearchesResponse> getReverseSearches({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET('/reverse-searches/{id}')
  Future<ReverseSearchResponse> getReverseSearchById(@Path('id') String id);

  @POST('/reverse-searches/action/cancel/{id}')
  Future<void> cancelSearch(@Path('id') String id);

  @POST('/reverse-searches/action/select/{searchId}')
  Future<void> selectResidence(
    @Path('searchId') String searchId,
    @Body() Map<String, dynamic> body,
  );

}
