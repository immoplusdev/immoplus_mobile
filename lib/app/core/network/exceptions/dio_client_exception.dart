import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class DioClientException implements Exception {
  static const sendTimeout =
      "Délai d'envoi dépassé : Veuillez vérifier votre connexion Internet ou réessayer.";

  static const connectionTimeout =
      "Délai de connexion dépassé : Veuillez vérifier votre connexion Internet ou réessayer.";

  static const String receiveTimeout =
      "Délai de réponse dépassé : Veuillez vérifier votre connexion Internet ou réessayer.";

  static const String badCertificate =
      "Erreur de certificat : Le certificat de sécurité du serveur n'a pas pu être vérifié.";

  static const String badResponse =
      "Réponse invalide : Veuillez réessayer ou contacter le support technique si le problème persiste.";

  static const String serverError =
      "Service temporairement indisponible. Merci de réessayer plus tard.";

  static const String cancel =
      "Requête annulée : L'opération a été interrompue avant son achèvement. Veuillez réessayer si nécessaire.";

  static const String connectionError =
      "Problème de connexion : Veuillez vérifier votre connexion Internet et réessayer.";

  static const String unknown =
      "Un problème inattendu est survenu. Veuillez réessayer, et si le problème persiste, contactez le support technique.";

  final DioException dioException;

  DioClientException(this.dioException);

  @override
  String toString() {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return DioClientException.connectionTimeout;
      case DioExceptionType.sendTimeout:
        return DioClientException.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return DioClientException.receiveTimeout;
      case DioExceptionType.badCertificate:
        return DioClientException.badCertificate;
      case DioExceptionType.badResponse:
        if (HttpStatus(dioException.response?.statusCode).isServerError) {
          return DioClientException.serverError;
        }
        try {
          return dioException.response?.data["message"];
        } catch (e) {
          return DioClientException.badResponse;
        }
      case DioExceptionType.cancel:
        return DioClientException.cancel;
      case DioExceptionType.connectionError:
        return DioClientException.connectionError;
      case DioExceptionType.unknown:
        return DioClientException.unknown;

      case DioExceptionType.transformTimeout:
        return DioClientException.unknown;
    }
  }
}
