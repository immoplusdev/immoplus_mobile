import 'package:freezed_annotation/freezed_annotation.dart';
import 'inner_file_data_model.dart';

part 'file_data_model.freezed.dart';
part 'file_data_model.g.dart';

@freezed
class FileDataModel with _$FileDataModel {
  const factory FileDataModel({
    InnerFileDataModel? data,
  }) = _FileDataModel;

  factory FileDataModel.fromJson(Map<String, dynamic> json) =>
      _$FileDataModelFromJson(json);
}
