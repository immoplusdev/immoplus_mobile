import 'package:flutter/material.dart';

/// `status` d'un relais — voir `immo-relais-status.enum.ts` côté backend.
enum ImmoRelaisStatus {
  upcoming('upcoming', 'À venir', Color(0xFFEFF6FF), Color(0xFF2548E5)),
  matching('matching', 'En correspondance', Color(0xFFFFF7E6), Color(0xFFB45309)),
  inProgress('in_progress', 'En cours', Color(0xFFEFFCF3), Color(0xFF1CA53F)),
  cancelled('cancelled', 'Annulé', Color(0xFFF3F4F6), Color(0xFF6B7280));

  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const ImmoRelaisStatus(this.value, this.label, this.backgroundColor, this.textColor);

  static ImmoRelaisStatus fromString(String? value) {
    return ImmoRelaisStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ImmoRelaisStatus.upcoming,
    );
  }
}
