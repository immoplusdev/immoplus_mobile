import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_password_dto.freezed.dart';
part 'update_password_dto.g.dart';

@freezed
class UpdatePasswordDto with _$UpdatePasswordDto {
  factory UpdatePasswordDto({
    required String oldPassword,
    required String newPassword,
  }) = _UpdatePasswordDto;

  factory UpdatePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordDtoFromJson(json);
}
