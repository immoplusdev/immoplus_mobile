import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/remote/suggest/suggest_response.dart';
import '../models/remote/suggest/suggest_click_payload.dart';
import '../providers/suggest_provider.dart';

@injectable
class SuggestRepository {
  final Dio dioClient;
  SuggestRepository(this.dioClient);

  Future<SuggestResponse> getSuggestions({
    required String query,
    int? limit,
    double? lat,
    double? lng,
    String? category,
  }) async {
    try {
      final response = await SuggestProvider(dioClient).getSuggestions(
        query: query,
        limit: limit,
        lat: lat,
        lng: lng,
        category: category,
      );
      return response;
    } on DioException catch (e) {
      log('DioError suggestions: ${e.message}');
      rethrow;
    } catch (e) {
      log('Error suggestions: $e');
      rethrow;
    }
  }

  Future<void> trackClick({
    required String query,
    required String type,
    required String id,
  }) async {
    try {
      await SuggestProvider(dioClient).trackClick(
        SuggestClickPayload(query: query, type: type, id: id),
      );
    } on DioException catch (e) {
      log('DioError track click: ${e.message}');
    } catch (e) {
      log('Error track click: $e');
    }
  }
}
