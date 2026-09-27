import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_cancel_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_action_responses.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_requests.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_list_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_matches_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_module_status_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_my_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_received_interests_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_request.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_response.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_update_request.dart';
import 'package:immoplus/app/data/providers/relais_provider.dart';
import 'package:injectable/injectable.dart';

@injectable
class RelaisRepository {
  final Dio dioClient;
  RelaisRepository(this.dioClient);

  /// Statut d'activation globale du module Immo Relais (GET /relais/module-status).
  Future<RelaisModuleStatusResponse> getModuleStatus() async {
    try {
      return await RelaisProvider(dioClient).getModuleStatus();
    } on DioException catch (dioError) {
      log('DioError (getModuleStatus): ${dioError.message}');
      return const RelaisModuleStatusResponse(active: true);
    } catch (error) {
      log('getModuleStatus error: $error');
      return const RelaisModuleStatusResponse(active: true);
    }
  }

  /// Helper booléen pour vérifier si le module Relais est actif.
  Future<bool> isModuleActive() async {
    try {
      final response = await getModuleStatus();
      return response.active;
    } catch (_) {
      return true;
    }
  }

  Future<RelaisResponse> createRelais(RelaisRequest request) async {
    try {
      return await RelaisProvider(dioClient).createRelais(request);
    } on DioException catch (dioError) {
      log('DioError (createRelais): ${dioError.message}');
      throw Exception('Failed to create relais: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to create relais: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to create relais: $error');
    }
  }

  Future<RelaisListResponse> getRelais({
    String? status,
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
  }) async {
    try {
      return await RelaisProvider(dioClient).getRelais(
        status: status,
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
    } on DioException catch (dioError) {
      log('DioError (getRelais): ${dioError.message}');
      throw Exception('Failed to load relais: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load relais: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load relais: $error');
    }
  }

  Future<RelaisResponse> getRelaisById(String id) async {
    try {
      return await RelaisProvider(dioClient).getRelaisById(id);
    } on DioException catch (dioError) {
      log('DioError (getRelaisById): ${dioError.message}');
      throw Exception('Failed to load relais detail: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load relais detail: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load relais detail: $error');
    }
  }

  Future<RelaisResponse> updateRelais(String id, RelaisUpdateRequest request) async {
    try {
      final body = request.toJson()..removeWhere((_, value) => value == null);
      return await RelaisProvider(dioClient).updateRelais(id, body);
    } on DioException catch (dioError) {
      log('DioError (updateRelais): ${dioError.message}');
      throw Exception('Failed to update relais: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to update relais: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to update relais: $error');
    }
  }

  Future<RelaisCancelResponse> cancelRelais(String id) async {
    try {
      return await RelaisProvider(dioClient).cancelRelais(id);
    } on DioException catch (dioError) {
      log('DioError (cancelRelais): ${dioError.message}');
      throw Exception('Failed to cancel relais: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to cancel relais: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to cancel relais: $error');
    }
  }

  Future<RelaisMatchesResponse> getRelaisMatches(String id) async {
    try {
      return await RelaisProvider(dioClient).getRelaisMatches(id);
    } on DioException catch (dioError) {
      log('DioError (getRelaisMatches): ${dioError.message}');
      throw Exception('Failed to load relais matches: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load relais matches: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load relais matches: $error');
    }
  }

  Future<RelaisInterestsResponse> getRelaisInterests(String id) async {
    try {
      return await RelaisProvider(dioClient).getRelaisInterests(id);
    } on DioException catch (dioError) {
      log('DioError (getRelaisInterests): ${dioError.message}');
      throw Exception('Failed to load relais interests: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load relais interests: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load relais interests: $error');
    }
  }

  Future<RelaisRespondInterestResponse> respondToInterest(
    String id,
    String interestId,
    RelaisInterestResponseRequest request,
  ) async {
    try {
      return await RelaisProvider(dioClient).respondToInterest(id, interestId, request);
    } on DioException catch (dioError) {
      log('DioError (respondToInterest): ${dioError.message}');
      throw Exception('Failed to respond to interest: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to respond to interest: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to respond to interest: $error');
    }
  }

  Future<RelaisExpressInterestResponse> expressInterest(
    String id,
    RelaisExpressInterestRequest request,
  ) async {
    try {
      return await RelaisProvider(dioClient).expressInterest(id, request);
    } on DioException catch (dioError) {
      log('DioError (expressInterest): ${dioError.message}');
      throw Exception('Failed to express interest: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to express interest: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to express interest: $error');
    }
  }

  Future<RelaisListResponse> getRelaisMarketplace({
    String? location,
    String? propertyType,
    int? roomsMin,
    int? roomsMax,
    int? priceMin,
    int? priceMax,
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
  }) async {
    try {
      return await RelaisProvider(dioClient).getRelaisMarketplace(
        location: location,
        propertyType: propertyType,
        roomsMin: roomsMin,
        roomsMax: roomsMax,
        priceMin: priceMin,
        priceMax: priceMax,
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
    } on DioException catch (dioError) {
      log('DioError (getRelaisMarketplace): ${dioError.message}');
      throw Exception('Failed to load relais marketplace: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load relais marketplace: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load relais marketplace: $error');
    }
  }

  Future<MyRelaisInterestsResponse> getMyRelaisInterests({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await RelaisProvider(dioClient).getMyRelaisInterests(
        status: status,
        page: page,
        limit: limit,
      );
    } on DioException catch (dioError) {
      log('DioError (getMyRelaisInterests): ${dioError.message}');
      throw Exception('Failed to load my relais interests: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load my relais interests: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load my relais interests: $error');
    }
  }

  Future<ReceivedRelaisInterestsResponse> getReceivedRelaisInterests({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await RelaisProvider(dioClient).getReceivedRelaisInterests(
        status: status,
        page: page,
        limit: limit,
      );
    } on DioException catch (dioError) {
      log('DioError (getReceivedRelaisInterests): ${dioError.message}');
      throw Exception('Failed to load received relais interests: ${dioError.message}');
    } on RequestResponseExeption catch (e) {
      throw Exception('Failed to load received relais interests: $e');
    } catch (error, s) {
      log('Error: $error $s');
      throw Exception('Failed to load received relais interests: $error');
    }
  }
}
