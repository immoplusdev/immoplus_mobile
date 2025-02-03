import 'package:freezed_annotation/freezed_annotation.dart';

part 'inner_file_data_model.freezed.dart';
part 'inner_file_data_model.g.dart';

@freezed
class InnerFileDataModel with _$InnerFileDataModel {
  factory InnerFileDataModel({
    String? type,
    String? title,
    String? folder,
    String? storage,
    String? description,
    int? fileSize,
    String? fileNameDisk,
    String? fileNameDownload,
    String? uploadedBy,
    String? charset,
    int? filesize,
    int? width,
    int? height,
    int? duration,
    String? embed,
    String? location,
    String? tags,
    String? metadata,
    double? focalPointX,
    double? focalPointY,
    String? tusId,
    String? tusData,
    String? id,
    DateTime? uploadedOn,
    DateTime? modifiedOn,
    DateTime? deletedOn,
  }) = _InnerFileDataModel;

  factory InnerFileDataModel.fromJson(Map<String, dynamic> json) =>
      _$InnerFileDataModelFromJson(json);
}
