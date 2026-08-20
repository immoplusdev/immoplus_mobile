import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:retrofit/retrofit.dart';

part 'reverse_search_provider.g.dart';

@RestApi()
abstract class ReverseSearchProvider {
  factory ReverseSearchProvider(Dio dio) = _ReverseSearchProvider;

  @POST('/reverse-searches')
  Future<HttpResponse<dynamic>> createSearch(@Body() ReverseSearchRequest body);

  @GET('/reverse-searches')
  Future<HttpResponse<dynamic>> getReverseSearches({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @POST('/reverse-searches/action/cancel/{id}')
  Future<void> cancelSearch(@Path('id') String id);

  @POST('/reverse-searches/action/select/{searchId}')
  Future<void> selectResidence(
    @Path('searchId') String searchId,
    @Body() Map<String, dynamic> body,
  );

}
