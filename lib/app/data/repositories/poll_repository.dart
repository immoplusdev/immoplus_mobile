import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/polls/poll_model.dart';
import 'package:immoplus/app/data/providers/poll_provider.dart';
import 'package:immoplus/app/services/device_id_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class PollRepository {
  final Dio _dio;
  final DeviceIdService _deviceIdService;
  final SessionManager _sessionManager;

  PollRepository(this._dio, this._deviceIdService, this._sessionManager);

  Future<PollModel> getPoll(String pollId) async {
    final deviceId = await _deviceIdService.getDeviceId();
    final response = await PollProvider(_dio).getPoll(pollId, deviceId: deviceId);
    return response.data;
  }

  /// Vote pour [optionId] puis renvoie le sondage rafraîchi (résultats à
  /// jour, `userHasVoted: true`). Un 409 (déjà voté — même device ou même
  /// utilisateur) n'est pas remonté comme erreur : on considère juste que
  /// le vote existe déjà et on recharge les résultats normalement.
  ///
  /// Body exact attendu par `POST /polls/:pollId/vote` (polls.controller.ts) :
  /// `optionId` (camelCase, pas `option_id`), et `deviceId` uniquement pour
  /// un vote anonyme — ignoré (et donc omis ici) si connecté, `userId` ne
  /// se met jamais dans le body (il vient du JWT côté serveur).
  Future<PollModel> vote({required String pollId, required String optionId}) async {
    final userId = _sessionManager.currentUser?.userId;
    try {
      await PollProvider(_dio).vote(pollId, {
        'optionId': optionId,
        if (userId == null) 'deviceId': await _deviceIdService.getDeviceId(),
      });
    } on DioException catch (e) {
      if (e.response?.statusCode != 409) {
        log('DioError (vote poll $pollId): ${e.message}');
        rethrow;
      }
    }
    return getPoll(pollId);
  }

  /// Change un vote existant vers [optionId] (`PATCH`) — reclic sur une
  /// option différente de celle déjà votée.
  Future<PollModel> changeVote({required String pollId, required String optionId}) async {
    try {
      await PollProvider(_dio).changeVote(pollId, {'optionId': optionId});
    } on DioException catch (e) {
      log('DioError (changeVote poll $pollId): ${e.message}');
      rethrow;
    }
    return getPoll(pollId);
  }

  /// Annule le vote existant (`DELETE`) — reclic sur l'option déjà votée.
  /// `device_id` (snake_case), même convention que `GET /polls/:pollId`.
  Future<PollModel> cancelVote({required String pollId}) async {
    final userId = _sessionManager.currentUser?.userId;
    try {
      await PollProvider(_dio).cancelVote(
        pollId,
        deviceId: userId == null ? await _deviceIdService.getDeviceId() : null,
      );
    } on DioException catch (e) {
      log('DioError (cancelVote poll $pollId): ${e.message}');
      rethrow;
    }
    return getPoll(pollId);
  }
}
