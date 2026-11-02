import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';
import 'package:immoplus/app/data/providers/banner_provider.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BannerRepository {
  final dioClient = getIt<Dio>();

  Future<BannerResponse> getBanners({required String source}) async {
    try {
      final response = await BannerProvider(dioClient).getBanners(source);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }
}
