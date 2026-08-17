import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/data/providers/reverse_search_provider.dart';
import 'package:immoplus/app/data/providers/residence_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class ReverseSearchRepository {
  final Dio _dioClient;
  late final ReverseSearchProvider _provider;
  late final ResidenceProvider _residenceProvider;

  ReverseSearchRepository(this._dioClient) {
    _provider = ReverseSearchProvider(_dioClient);
    _residenceProvider = ResidenceProvider(_dioClient);
  }

  Future<String> createSearch(ReverseSearchRequest request) async {
    try {
      final response = await _provider.createSearch(request);
      return response.data['id'] as String;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> cancelSearch(String id) async {
    try {
      await _provider.cancelSearch(id);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<void> selectResidence(String searchId, String residenceId) async {
    try {
      await _provider.selectResidence(searchId, {'residenceId': residenceId});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

//TODO
  Future<ResidencesCollection> getClassicResidences(
      ReverseSearchRequest request) async {
    try {
      final villeIds = request.zones.map((z) => z.id).join(',');
      final startDate = DateFormat('yyyy-MM-dd').format(request.dateDebut);
      final endDate = DateFormat('yyyy-MM-dd').format(request.dateFin);

      final whereQueries = {
        '_villeId': villeIds,
        '_where[0][_field]': 'nombreMaxOccupants',
        '_where[0][_op]': 'gte',
        '_where[0][_val]': request.nombrePersonnes,
        '_where[1][_field]': 'prixReservation',
        '_where[1][_op]': 'gte',
        '_where[1][_val]': request.budgetMin.toInt(),
        '_where[2][_field]': 'prixReservation',
        '_where[2][_op]': 'lte',
        '_where[2][_val]': request.budgetMax.toInt(),
      };

      final response = await _residenceProvider.getResidences(
        startDate: startDate,
        endDate: endDate,
        page: 1,
        perPage: 50,
        // where: whereQueries,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
