import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_dto.freezed.dart';
part 'update_user_dto.g.dart';

@freezed
class UpdateUserDto with _$UpdateUserDto {
  const factory UpdateUserDto({
    @Default('') String firstName,
    @Default('') String lastName,
    @JsonKey(includeIfNull: false) String? avatar,
    @JsonKey(includeIfNull: false) String? email,
    @Default('') String phoneNumber,
  }) = _UpdateUserDto;

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);
}
