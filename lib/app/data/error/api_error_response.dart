import 'package:immoplus/app/data/enums/api_error_code.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error_response.g.dart';

@JsonSerializable()
class ApiErrorResponse {
  final int statusCode;
  final String? message;
  final String? error;
  final String? code;
  final String? timestamp;
  final String? path;

  const ApiErrorResponse({
    required this.statusCode,
    required this.message,
    required this.error,
    required this.code,
    required this.timestamp,
    required this.path,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);

  @override
  String toString() {
    return 'ApiErrorResponse(statusCode: $statusCode, message: $message, code: $code)';
  }

  /// Convertit le code string en enum
  ApiErrorCode get errorCode => ApiErrorCode.fromString(code);

  /// Vérifie si l'erreur est liée à l'authentification
  bool get isAuthError => errorCode.isAuthRelated;

  /// Vérifie si l'erreur nécessite une déconnexion
  bool get requiresLogout => errorCode.requiresLogout;
}
