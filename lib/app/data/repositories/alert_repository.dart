import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_request.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_response.dart';
import 'package:immoplus/app/data/models/remote/alert/alerts_response.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_matches_response.dart';
import 'package:immoplus/app/data/providers/alert_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

@injectable
class AlertRepository {
  final Dio dioClient;
  AlertRepository(this.dioClient);

  Future<AlertsResponse> getAlerts({
    int page = 1,
    int pageSize = 10,
    String? status,
  }) async {
    log('AlertRepository: getAlerts called with status = $status');
    try {
      final response = await AlertProvider(dioClient).getAlerts(
        page: page,
        pageSize: pageSize,
        status: status,
      );
      return response;
    } on DioException catch (dioError) {
      log('DioError (getAlerts): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error, s) {
      log('Error: $error $s');
      throw AppErrorMapper.from(error);
    }
  }

  Future<AlertResponse> getAlertById(String id) async {
    try {
      final response = await AlertProvider(dioClient).getAlertById(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError (getAlertById): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<AlertResponse> createAlert(AlertRequest request) async {
    try {
      final response = await AlertProvider(dioClient).createAlert(request);
      return response;
    } on DioException catch (dioError) {
      log('DioError (createAlert): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error, s) {
      log('Error: $error $s');
      throw AppErrorMapper.from(error);
    }
  }

  Future<AlertResponse> updateAlert(String id, AlertRequest request) async {
    try {
      final response = await AlertProvider(dioClient).updateAlert(id, request);
      return response;
    } on DioException catch (dioError) {
      log('DioError (updateAlert): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HttpResponse> deleteAlert(String id) async {
    try {
      final response = await AlertProvider(dioClient).deleteAlert(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError (deleteAlert): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HttpResponse> markAsViewed(String id) async {
    try {
      final response = await AlertProvider(dioClient).markAsViewed(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError (markAsViewed): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<int> getImatchBadgeCount() async {
    try {
      final response = await dioClient.get('/alerts/badge-count');
      return (response.data['data']['count'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<AlertMatchesResponse> getAlertMatches({
    required String id,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await AlertProvider(dioClient).getAlertMatches(
        id: id,
        page: page,
        pageSize: pageSize,
      );
      return response.data;
    } on DioException catch (dioError) {
      log('DioError (getAlertMatches): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } on RequestResponseExeption catch (e) {
      AppFeedback.showError(e.toString());
      throw AppErrorMapper.from(e);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }
}
