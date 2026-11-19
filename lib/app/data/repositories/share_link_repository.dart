import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/data/models/remote/share_link/share_link_open_model.dart';
import 'package:immoplus/app/services/device_id_service.dart';
import 'package:injectable/injectable.dart';

/// Lien de partage d'une résidence (`https://app.immoplus.ci/rt{token}`).
@injectable
class ShareLinkRepository {
  ShareLinkRepository(this._dio, this._deviceIdService);

  final Dio _dio;
  final DeviceIdService _deviceIdService;

  static final _pathPattern = RegExp(r'^/rt([^/]+)/?$');

  /// Token d'un chemin `/rt{token}` ; `null` si le chemin n'est pas un lien
  /// de partage.
  static String? tokenFromPath(String path) =>
      _pathPattern.firstMatch(path)?.group(1);

  /// Enregistre l'ouverture réelle du lien (compte le clic) et renvoie la
  /// résidence à afficher.
  Future<ShareLinkOpenModel> recordOpen(String token) async {
    final deviceId = await _deviceIdService.getDeviceId();
    final response = await _dio.post(
      '/public/share-links/${Uri.encodeComponent(token)}/open',
      options: Options(
        headers: {'x-device-id': deviceId},
        extra: {AppErrorMapper.silentKey: true},
      ),
    );
    return _parse(response.data);
  }

  /// Résout le lien sans compter de clic : sert de repli quand l'ouverture
  /// est refusée (lien remplacé, limite de débit…) pour afficher quand même
  /// la fiche.
  Future<ShareLinkOpenModel> resolve(String token) async {
    final response = await _dio.get(
      '/public/share-links/${Uri.encodeComponent(token)}',
      options: Options(extra: {AppErrorMapper.silentKey: true}),
    );
    return _parse(response.data);
  }

  /// Ouvre le lien ; en cas d'échec, tente la résolution simple. `null` si
  /// aucune résidence n'a pu être déterminée.
  Future<ShareLinkOpenModel?> open(String token) async {
    try {
      final opened = await recordOpen(token);
      if (opened.residenceId.isNotEmpty) return opened;
    } catch (e) {
      log('ShareLink open failed: $e', name: 'SHARE_LINK');
    }
    try {
      final resolved = await resolve(token);
      if (resolved.residenceId.isNotEmpty) return resolved;
    } catch (e) {
      log('ShareLink resolve failed: $e', name: 'SHARE_LINK');
    }
    return null;
  }

  ShareLinkOpenModel _parse(Object? data) => ShareLinkOpenModel.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
      );
}
