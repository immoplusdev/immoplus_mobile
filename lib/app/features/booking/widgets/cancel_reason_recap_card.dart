import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';

abstract class _Constants {
  static const cardBackground = AppColors.white;
  static const cardBorderRadius = 16.0;
  static const cardBorderColor = Color(0xFFEAECF0);
  static const cardBorderWidth = 1.2;
  static const cardPadding = 16.0;
  static const titleLabel = 'Votre motif';
  static const titleLabelColor = Color(0xFF667085);
  static const reasonColor = Color(0xFF101828);
  static const defaultReason = 'Motif enregistré.';
  static const dividerColor = Color(0xFFF2F4F7);
  static const cancellationStatusLabel = 'Réservation annulée';
  static const cancellationStatusColor = Color(0xFF667085);
  static const dateColor = Color(0xFF344054);
}

class CancelReasonRecapCard extends StatelessWidget {
  final String reasonLabel;
  final DateTime respondedAt;

  const CancelReasonRecapCard({
    super.key,
    required this.reasonLabel,
    required this.respondedAt,
  });

  @override
  Widget build(BuildContext context) {
    final formattedReason = reasonLabel.isNotEmpty
        ? (reasonLabel.endsWith('.') ? reasonLabel : '$reasonLabel.')
        : _Constants.defaultReason;

    final dateLabel = Utils.formatCancelDate(dateTime: respondedAt);

    return Container(
      padding: const EdgeInsets.all(_Constants.cardPadding),
      decoration: BoxDecoration(
        color: _Constants.cardBackground,
        borderRadius: BorderRadius.circular(_Constants.cardBorderRadius),
        border: Border.all(
          color: _Constants.cardBorderColor,
          width: _Constants.cardBorderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _Constants.titleLabel,
            style: AppTypography.caption.copyWith(
              color: _Constants.titleLabelColor,
            ),
          ),
          const Gap(6),
          Text(
            formattedReason,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: _Constants.reasonColor,
            ),
          ),
          const Gap(14),
          const Divider(
            color: _Constants.dividerColor,
            height: 1,
          ),
          const Gap(14),
          Row(
            children: [
              Text(
                _Constants.cancellationStatusLabel,
                style: AppTypography.bodySmall.copyWith(
                  color: _Constants.cancellationStatusColor,
                ),
              ),
              const Spacer(),
              Text(
                dateLabel,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _Constants.dateColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
