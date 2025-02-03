import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment_itent_data.dart';

part 'payment_itent_model.freezed.dart';
part 'payment_itent_model.g.dart';

@freezed
class PaymentItentModel with _$PaymentItentModel {
  factory PaymentItentModel({
    required PaymentItentData data,
  }) = _PaymentItentModel;

  factory PaymentItentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentItentModelFromJson(json);
}
