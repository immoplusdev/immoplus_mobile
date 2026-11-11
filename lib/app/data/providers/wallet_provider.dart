import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'wallet_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class WalletProvider {
  factory WalletProvider(Dio dio, {String baseUrl}) = _WalletProvider;

  @GET("/wallet/my-wallet")
  Future<dynamic> getMyWallet();

  @GET("/wallet/my-transactions")
  Future<dynamic> getMyTransactions(
    @Query("_page") int page,
    @Query("_per_page") int perPage,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  );

  @POST("/wallet/withdrawal-request/create")
  Future<dynamic> createWithdrawalRequest(@Body() Map<String, dynamic> body);

  @GET("/wallet/my-withdrawal-request")
  Future<dynamic> getMyWithdrawalRequests(
    @Query("_page") int page,
    @Query("_per_page") int perPage,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  );
}
