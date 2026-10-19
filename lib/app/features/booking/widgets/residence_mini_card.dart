import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

abstract class _Constants {
  static const cardBackground = Color(0xFFF0F4FE);
  static const cardBorderRadius = 16.0;
  static const cardPadding = 10.0;
  static const thumbnailWidth = 76.0;
  static const thumbnailHeight = 54.0;
  static const thumbnailBorderRadius = 10.0;
  static const thumbnailPlaceholderColor = Color(0xFFE0E0E0);
  static const thumbnailIconColor = Color(0xFF9E9E9E);
  static const spacingImageText = 12.0;
  static const titleColor = Color(0xFF101828);
  static const subtitleColor = Color(0xFF667085);
  static const priceColor = Color(0xFF101828);
  static const defaultTitle = 'Résidence';
  static const separator = ' · ';
  static const piecesSuffix = ' pièces';
  static const monthSuffix = ' / mois';
  static const currencySuffix = ' FCFA';
}

class ResidenceMiniCard extends StatelessWidget {
  final ReservationModel reservation;

  const ResidenceMiniCard({
    super.key,
    required this.reservation,
  });

  String _formatPrice(num amount) {
    try {
      final fmt = NumberFormat.decimalPattern('fr');
      return '${fmt.format(amount)}${_Constants.currencySuffix}';
    } catch (_) {
      return '$amount${_Constants.currencySuffix}';
    }
  }

  String _getImageUrl() {
    final res = reservation.residence;
    final rawImage = res.miniature.isNotEmpty
        ? res.miniature
        : (res.images.isNotEmpty ? res.images.first : '');

    if (rawImage.isEmpty) return '';
    return Utils.getImagePath(id: rawImage);
  }

  @override
  Widget build(BuildContext context) {
    final res = reservation.residence;
    final imageUrl = _getImageUrl();

    final locationPieces = [
      if (res.commune.isNotEmpty)
        res.commune
      else if (res.ville.isNotEmpty)
        res.ville,
      if (res.pieces.isNotEmpty)
        '${res.pieces.length}${_Constants.piecesSuffix}',
    ].join(_Constants.separator);

    final priceFormatted = res.prixReservation > 0
        ? '${_formatPrice(res.prixReservation)}${_Constants.monthSuffix}'
        : (reservation.montantTotalReservation > 0
            ? _formatPrice(reservation.montantTotalReservation)
            : '');

    return Container(
      padding: const EdgeInsets.all(_Constants.cardPadding),
      decoration: BoxDecoration(
        color: _Constants.cardBackground,
        borderRadius: BorderRadius.circular(_Constants.cardBorderRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(_Constants.thumbnailBorderRadius),
            child: SizedBox(
              width: _Constants.thumbnailWidth,
              height: _Constants.thumbnailHeight,
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _buildPlaceholder(),
                      placeholder: (_, __) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const Gap(_Constants.spacingImageText),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  res.nom.isNotEmpty ? res.nom : _Constants.defaultTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _Constants.titleColor,
                  ),
                ),
                if (locationPieces.isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    locationPieces,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: _Constants.subtitleColor,
                    ),
                  ),
                ],
                if (priceFormatted.isNotEmpty) ...[
                  const Gap(4),
                  Text(
                    priceFormatted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _Constants.priceColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: _Constants.thumbnailPlaceholderColor,
      child: const Icon(
        Icons.home,
        color: _Constants.thumbnailIconColor,
      ),
    );
  }
}
