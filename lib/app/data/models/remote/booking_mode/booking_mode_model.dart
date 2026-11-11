import 'package:immoplus/app/data/enums/booking_mode.dart';

/// Réponse de `GET /clients/me/booking-mode`.
///
/// [level] et [reasonCode] sont fournis par le serveur à titre informatif ;
/// l'app ne les interprète pas (pas de règle métier côté client).
class BookingModeModel {
  const BookingModeModel({
    required this.mode,
    this.level,
    this.reasonCode,
    this.reason,
  });

  final BookingMode mode;
  final String? level;
  final String? reasonCode;
  final String? reason;

  factory BookingModeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return BookingModeModel(
      mode: BookingMode.fromValue(data['mode']?.toString()),
      level: data['level']?.toString(),
      reasonCode: data['reasonCode']?.toString(),
      reason: data['reason']?.toString(),
    );
  }
}
