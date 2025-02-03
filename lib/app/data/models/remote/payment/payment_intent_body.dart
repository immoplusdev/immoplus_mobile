import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_intent_body.freezed.dart';
part 'payment_intent_body.g.dart';

@freezed
class PaymentIntentBody with _$PaymentIntentBody {
  const factory PaymentIntentBody({
    @Default('') String collection,
    @Default('') String itemId,
    @Default('') String paymentMethod,
    @Default('') String paymentCredentials,
  }) = _PaymentIntentBody;

  factory PaymentIntentBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentBodyFromJson(json);
}
