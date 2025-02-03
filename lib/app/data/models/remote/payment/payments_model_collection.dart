import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment_itent_data.dart';

part 'payments_model_collection.freezed.dart';
part 'payments_model_collection.g.dart';

@freezed
class PaymentsModelCollection with _$PaymentsModelCollection {
  factory PaymentsModelCollection({
    @Default([]) List<PaymentItentData>? data,
    @Default(0) int? currentPage,
    @Default(0) int? totalPages,
    @Default(0) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _PaymentsModelCollection;

  factory PaymentsModelCollection.fromJson(Map<String, dynamic> json) =>
      _$PaymentsModelCollectionFromJson(json);
}
