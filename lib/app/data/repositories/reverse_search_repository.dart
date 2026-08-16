import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReverseSearchRepository {
  final Dio _dioClient;

  ReverseSearchRepository(this._dioClient);

  Future<String> createSearch(ReverseSearchRequest request) async {
    try {
      final response = await _dioClient.post(
        '/reverse-searches',
        data: request.toJson(),
      );
      // Supposons que l'ID de la recherche est renvoyé dans response.data['id']
      return response.data['id'] as String;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> cancelSearch(String id) async {
    try {
      await _dioClient.post('/reverse-searches/action/cancel/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> selectResidence(String searchId, String residenceId) async {
    try {
      await _dioClient.post(
        '/reverse-searches/action/select/$searchId',
        data: {'residenceId': residenceId},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
