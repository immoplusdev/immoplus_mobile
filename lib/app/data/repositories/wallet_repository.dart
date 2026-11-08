import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/data/providers/wallet_provider.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:injectable/injectable.dart';

@injectable
class WalletRepository {
  WalletRepository(this._dio);

  final Dio _dio;

  WalletProvider get _provider => WalletProvider(_dio);

  Future<WalletModel> getMyWallet() => _run('my-wallet', () async {
        final json = await _provider.getMyWallet();
        return WalletModel.fromJson(_asMap(json));
      });

  Future<PagedResult<WalletTransactionModel>> getMyTransactions({
    required int page,
    int perPage = 20,
  }) =>
      _run('my-transactions', () async {
        final json = await _provider.getMyTransactions(
            page, perPage, 'createdAt', 'desc');
        return PagedResult.fromJson(
            _asMap(json), WalletTransactionModel.fromJson);
      });

  Future<WithdrawalRequestModel> createWithdrawalRequest(
          WithdrawalRequestBody body) =>
      _run('withdrawal-request/create', () async {
        final json = await _provider.createWithdrawalRequest(body.toJson());
        return WithdrawalRequestModel.fromJson(_asMap(json));
      });

  Future<PagedResult<WithdrawalRequestModel>> getMyWithdrawalRequests({
    required int page,
    int perPage = 20,
  }) =>
      _run('my-withdrawal-request', () async {
        final json = await _provider.getMyWithdrawalRequests(
            page, perPage, 'createdAt', 'desc');
        return PagedResult.fromJson(
            _asMap(json), WithdrawalRequestModel.fromJson);
      });

  Map<String, dynamic> _asMap(Object? json) =>
      json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};

  /// Convertit toute erreur en `AppError` (code, message et statut du back
  /// conservés), comme les autres dépôts.
  Future<T> _run<T>(String endpoint, Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (dioError) {
      log('DioError (wallet/$endpoint): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error (wallet/$endpoint): $error');
      throw AppErrorMapper.from(error);
    }
  }
}
