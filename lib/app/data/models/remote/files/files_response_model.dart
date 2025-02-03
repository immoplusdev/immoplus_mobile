import 'package:freezed_annotation/freezed_annotation.dart';
import 'file_data_model.dart';

part 'files_response_model.freezed.dart';
part 'files_response_model.g.dart';

@freezed
class FileResponseModel with _$FileResponseModel {
  const factory FileResponseModel({
    @JsonKey(name: 'data') FileDataModel? data,
  }) = _FileResponseModel;

  factory FileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FileResponseModelFromJson(json);
}
