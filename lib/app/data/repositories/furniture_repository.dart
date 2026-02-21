import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/data/providers/furniture_provider.dart';
import 'package:injectable/injectable.dart';

import '../models/remote/furniture/furniture_collection.dart';
import '../models/remote/furniture/furniture_response.dart';

@injectable
class FurnitureRepository {
  Dio dioClient;
  FurnitureRepository(this.dioClient);

  Future<FurnitureCollection> getFurnitures({
    required int page,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
    String? search,
    double? lat,
    double? long,
    int? perPage,
    double? radius,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await FurnitureProvider(dioClient).getFurnitures(
        page: page,
        orderBy: orderBy,
        orderDir: orderDir,
        where: where,
        search: search,
        lat: lat,
        long: long,
        perPage: perPage,
        radius: radius,
        startDate: startDate,
        endDate: endDate,
      );

      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load furniture: ${dioError.message}');
    } catch (error) {
      inspect(error);
      log('Error: $error');
      throw Exception('Failed to load furniture: $error');
    }
  }

  Future<FurnitureResponse> getFurniture(String id) async {
    try {
      final response = await FurnitureProvider(dioClient).getFurniture(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      rethrow;
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load furniture: $error');
    }
  }
}
