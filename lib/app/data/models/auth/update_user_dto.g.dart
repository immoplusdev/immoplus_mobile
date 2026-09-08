// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserDtoImpl _$$UpdateUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UpdateUserDtoImpl(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$UpdateUserDtoImplToJson(_$UpdateUserDtoImpl instance) {
  final val = <String, dynamic>{
    'firstName': instance.firstName,
    'lastName': instance.lastName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null && (value is! String || value.isNotEmpty)) {
      val[key] = value;
    }
  }

  writeNotNull('avatar', instance.avatar);
  writeNotNull('email', instance.email);
  val['phoneNumber'] = instance.phoneNumber;
  return val;
}
