import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../models/remote/hotel/hotel_model.dart';
import '../models/remote/hotel/hotel_detail_model.dart';
import '../models/remote/hotel/hotel_response.dart';
import '../models/remote/hotel/hotels_collection.dart';
import '../models/remote/hotel/hotel_estimation_request.dart';
import '../models/remote/hotel/hotel_estimation_response.dart';
import '../models/remote/hotel/hotel_villes_response.dart';
import '../models/remote/hotel/hotel_room_detail_model.dart';

part 'hotel_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class HotelProvider {
  factory HotelProvider(Dio dio, {String baseUrl}) = _HotelProvider;

  @GET("/pms/hotels/{hotelId}")
  Future<HotelDetailModel> getHotel(@Path() String hotelId);

  @GET("/pms/hotels/{hotelId}/chambres/{roomTypeId}")
  Future<HotelRoomDetailModel> getRoomDetail(
    @Path() String hotelId,
    @Path() String roomTypeId,
  );

  @GET("/pms/hotels")
  Future<HotelsCollection> getHotels({
    @Query("_lat") double? lat,
    @Query("_long") double? long,
    @Query("_radius") double? radius,
    @Query("_villeId") String? villeId,
    @Query("_isSponsored") bool? isSponsored,
    @Query("_checkInDate") String? checkInDate,
    @Query("_checkOutDate") String? checkOutDate,
    @Query("adults") int? adults,
    @Query("children") int? children,
    @Query("lits") int? lits,
  });

  @GET("/pms/hotels/villes")
  Future<List<HotelVillesResponse>> getVilles();

  @POST("/pms/hotels/{hotelId}/reservations/estimation")
  Future<HotelEstimationResponse> getEstimation(
    @Path() String hotelId,
    @Body() HotelEstimationRequest request,
  );
}
