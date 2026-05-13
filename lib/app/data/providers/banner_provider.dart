import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/remote/banners/banner_model.dart';

part 'banner_provider.g.dart';

@RestApi()
abstract class BannerProvider {
  factory BannerProvider(Dio dio, {String baseUrl}) = _BannerProvider;

  @GET("/banners")
  Future<BannerResponse> getBanners(
    @Query("source") String source,
  );
}
