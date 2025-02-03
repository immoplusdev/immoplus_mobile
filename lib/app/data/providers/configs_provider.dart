import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/remote/configs/commune_collection.dart';
import '../models/remote/configs/ville_collection.dart';

part 'configs_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ConfigsProvider {
  factory ConfigsProvider(Dio dio, {String baseUrl}) = _ConfigsProvider;

  @GET("/communes")
  Future<CommuneCollection> getCommunes(
      @Query("_page") int page, @Query("_per_page") int perPage);

  @GET("/villes")
  Future<VilleCollection> getVilles(
      @Query("_page") int page, @Query("_per_page") int perPage);
}
