import 'package:freezed_annotation/freezed_annotation.dart';

import 'bien_immobilier_model.dart';

part 'bien_immobilier_single.freezed.dart';
part 'bien_immobilier_single.g.dart';

@freezed
class BienImmobilierSingle with _$BienImmobilierSingle {
  factory BienImmobilierSingle({
    BienImmobilierModel? data,
  }) = _BienImmobilierSingle;

  factory BienImmobilierSingle.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierSingleFromJson(json);
}
