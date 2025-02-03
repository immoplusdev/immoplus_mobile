import 'package:freezed_annotation/freezed_annotation.dart';
import 'role_model.dart';
import 'additional_data_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'id') String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? language,
    String? phoneNumber,
    String? otp,
    String? otpExpiration,
    String? country,
    String? state,
    String? city,
    String? commune,
    String? address,
    String? address2,
    String? currency,
    bool? identityVerified,
    bool? emailVerified,
    bool? phoneNumberVerified,
    int? authLoginAttempts,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? avatar,
    required RoleModel role,
    required AdditionalDataModel additionalData,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
