import 'package:freezed_annotation/freezed_annotation.dart';

import 'next_action_model.dart';

part 'payment_itent_data.freezed.dart';
part 'payment_itent_data.g.dart';

@freezed
class PaymentItentData with _$PaymentItentData {
  factory PaymentItentData({
    @Default('') String id,
    @Default(0) int amount,
    @Default(0) int amountNoFees,
    @Default('') String paymentType,
    @Default('') String collection,
    @Default('') String paymentStatus,
    @Default('') String paymentMethod,
    @Default('') String itemId,
    @Default('') String hub2PaymentId,
    String? hub2Exception,
    Hub2NextAction? hub2NextAction,
    @Default('') String hub2Token,
    //Hub2Metadata? hub2Metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    //@Default('') String customerId,
    //UserModel? customer,
  }) = _PaymentItentData;

  factory PaymentItentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentItentDataFromJson(json);
}
