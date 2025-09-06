import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/error/api_error_response.dart';
import 'package:immoplus/app/data/models/auth/refresh_token_body.dart';
import 'package:immoplus/app/data/models/auth/refresh_token_response.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/utils/request_path.dart';

class AuthService {
  /// Refresh le token d'accès
  static Future<bool> refreshToken(SessionManager sessionManager) async {
    try {
      // Récupérer le refresh token actuel
      final currentUser = await sessionManager.getCurrentUser();
      final refreshToken = currentUser?.refreshToken;

      if (refreshToken == null || currentUser == null) {
        log('Pas de refresh token disponible', name: 'AUTH_SERVICE');
        await sessionManager.logout();
        return false;
      }

      // Créer le body de la requête
      final body = RefreshTokenBody(refreshToken: refreshToken);

      // Instance Dio séparée pour éviter la récursion
      final dio = Dio();
      dio.options.baseUrl = RequestPath.baseUrl;

      final response = await dio.post(
        '/auth/refresh-token',
        data: body.toJson(),
      );

      // Parser la réponse
      final refreshResponse = RefreshTokenResponse.fromJson(response.data);

      // Mettre à jour l'utilisateur avec les nouveaux tokens
      final updatedUser = UserModelSchema()
        ..userId = currentUser.userId
        ..firstName = currentUser.firstName
        ..lastName = currentUser.lastName
        ..phoneNumber = currentUser.phoneNumber
        ..email = currentUser.email
        ..accessToken = refreshResponse.data.accessToken
        ..refreshToken = refreshResponse.data.refreshToken
        ..roleName = currentUser.roleName
        ..activite = currentUser.activite
        ..nomEntreprise = currentUser.nomEntreprise
        ..emailEntreprise = currentUser.emailEntreprise
        ..photoIdentite = currentUser.photoIdentite
        ..pieceIdentite = currentUser.pieceIdentite
        ..avatar = currentUser.avatar
        ..role = currentUser.role;

      // Sauvegarder en session
      await sessionManager.saveUser(updatedUser);

      log('Token refresh réussi', name: 'AUTH_SERVICE');
      return true;
    } on DioException catch (e) {
      // Si c'est une erreur de refresh token invalide, déconnecter
      if (e.response?.data != null) {
        try {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          if (errorResponse.requiresLogout) {
            await sessionManager.logout();
          }
        } catch (parseError) {
          log('Erreur parsing response: $parseError', name: 'AUTH_SERVICE');
        }
      }
      return false;
    } catch (e) {
      log('Erreur lors du refresh token: $e', name: 'AUTH_SERVICE');
      return false;
    }
  }
}
