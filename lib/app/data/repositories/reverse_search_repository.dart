import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/data/providers/reverse_search_provider.dart';
import 'package:immoplus/app/data/providers/residence_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final id = response.data.id;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('active_reverse_search_id', id);
      return id;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        String? existingId = data['id']?.toString() ??
            (data['data'] is Map ? data['data']['id']?.toString() : null) ??
            data['searchId']?.toString();
        if (existingId != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('active_reverse_search_id', existingId);
          return existingId;
        }
      }
      throw Exception(data is Map ? (data['message'] ?? e.message) : e.message);
    }
  }

  Future<void> cancelSearch(String id) async {
    try {
      await _provider.cancelSearch(id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_reverse_search_id');
    } on DioException catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_reverse_search_id');
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<List<ReverseSearchItem>> getReverseSearchesList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response =
          await _provider.getReverseSearches(page: page, limit: limit);
      return response.data;
    } catch (e, st) {
      debugPrint('getReverseSearchesList failed: $e\n$st');
      return [];
    }
  }

  Future<ReverseSearchItem?> getReverseSearchById(String id) async {
    try {
      final response = await _provider.getReverseSearchById(id);
      return response.data;
    } catch (e, st) {
      debugPrint('getReverseSearchById($id) failed: $e\n$st');
      return null;
    }
  }

  Future<ReverseSearchItem?> getActiveSearch() async {
    try {
      final list = await getReverseSearchesList(page: 1, limit: 10);
      if (list.isNotEmpty) {
        final first = list.first;
        if (first.statusEnum.isActive) {
          final detailed = await getReverseSearchById(first.id);
          return detailed ?? first;
        }
      }
      return null;
    } catch (e, st) {
      debugPrint('getActiveSearch failed: $e\n$st');
      return null;
    }
  }

  Future<String?> fetchActiveSearchId() async {
    try {
      final active = await getActiveSearch();
      return active?.id;
    } catch (_) {
      return null;
    }
  }

  Future<bool> cancelActiveSearch() async {
    final prefs = await SharedPreferences.getInstance();
    String? searchId = prefs.getString('active_reverse_search_id');

    searchId ??= await fetchActiveSearchId();

    if (searchId != null && searchId.isNotEmpty) {
      await cancelSearch(searchId);
      await prefs.remove('active_reverse_search_id');
      return true;
    }
    return false;
  }

  Future<void> selectResidence(String searchId, String residenceId) async {
    try {
      await _provider.selectResidence(searchId, {'residenceId': residenceId});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }


  Future<bool> isModuleActive() async {
    try {
      final response = await _dioClient.get('/reverse-searches/module-status');
      final data = response.data;
      if (data is Map && data['active'] is bool) {
        return data['active'] as bool;
      }
      return true;
    } catch (e) {
      debugPrint('isModuleActive failed: $e');
      return true;
    }
  }

  Future<ResidencesCollection> getClassicResidences(
      ReverseSearchRequest request) async {
    try {
      final startDate = DateFormat('yyyy-MM-dd').format(request.dateDebut);
      final endDate = DateFormat('yyyy-MM-dd').format(request.dateFin);

      final zonesList = request.zones
          .map((z) => {
                'lat': z.lat,
                'long': z.lng,
              })
          .toList();

      final zonesJson = jsonEncode(zonesList);

      final response = await _residenceProvider.searchResidencesPublic(
        zones: zonesJson,
        priceMin: request.budgetMin.toInt(),
        priceMax: request.budgetMax.toInt(),
        occupantsMin: request.nombrePersonnes,
        startDate: startDate,
        endDate: endDate,
        page: 1,
        perPage: 50,
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
