import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_login_body.freezed.dart';
part 'social_login_body.g.dart';

@freezed
class SocialLoginBody with _$SocialLoginBody {
  const factory SocialLoginBody({
    required String provider, // "google" ou "facebook"
    required String token,
    required String email,
    required String source, // "customer_app"
  }) = _SocialLoginBody;

  factory SocialLoginBody.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginBodyFromJson(json);
}
