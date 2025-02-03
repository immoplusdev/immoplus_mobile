import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_authenticate_body.freezed.dart';
part 'payment_authenticate_body.g.dart';

@freezed
class PaymentAuthenticateBody with _$PaymentAuthenticateBody {
  factory PaymentAuthenticateBody({
    @Default('') String otp,
    @Default('') String itemId,
    @Default('') String collection,
  }) = _PaymentAuthenticateBody;

  factory PaymentAuthenticateBody.fromJson(Map<String, dynamic> json) =>
      _$PaymentAuthenticateBodyFromJson(json);
}
