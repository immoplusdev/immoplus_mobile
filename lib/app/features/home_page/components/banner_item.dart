import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';
import 'package:immoplus/app/features/home_page/components/banner_button.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

enum BannerAction {
  annulerReservation('/annuler_reservation'),
  payerReservation('/payer_reservation'),
  unknown('');

  final String url;
  const BannerAction(this.url);

  static BannerAction fromUrl(String? url) {
    if (url == null) return BannerAction.unknown;
    return BannerAction.values.firstWhere(
      (e) => e.url == url,
      orElse: () => BannerAction.unknown,
    );
  }
}

class BannerItem extends StatelessWidget {
  final BannerModel banner;

  const BannerItem({super.key, required this.banner});

  void _handleAction(BuildContext context, String? url) {
    if (url == null) return;

    final action = BannerAction.fromUrl(url);
    final metadata = banner.metadata ?? {};
    final reservationId = metadata['reservation_id']?.toString();
    final amount = metadata['montant_paye'];

    switch (action) {
      case BannerAction.payerReservation:
        if (reservationId != null && amount != null) {
          context.pushNamed(
            OperatorsSelectorPage.name,
            extra: PaymentPageAdapter(
              itemId: reservationId,
              collection: ProductType.reservations.name,
              amount:
                  amount is int ? amount : int.tryParse(amount.toString()) ?? 0,
            ),
          );
        }
        break;
      case BannerAction.annulerReservation:
        if (reservationId != null) {
          _showCancelConfirmation(context, reservationId);
        }
        break;
      default:
        // Gérer d'autres URLs ou liens profonds ici
        break;
    }
  }

  void _showCancelConfirmation(BuildContext context, String reservationId) {
    AppDialog.show(
      title: 'Annuler la réservation',
      description: 'Voulez-vous vraiment annuler cette réservation ?',
      primaryButtonText: 'Oui, annuler',
      secondButtonText: 'Non',
      onPrimary: () async {
        try {
          await getIt<ResidenceRepository>().annulerReservationClient(
            reservationId: reservationId,
            notes: 'Annulé depuis la bannière promotionnelle',
          );
          ToastUtils.showSuccess(
            description: 'Réservation annulée avec succès',
          );
        } catch (e) {
          ToastUtils.showError(
            description: 'Erreur lors de l\'annulation',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (banner.icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Icon(
              _getIconData(banner.icon!),
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(4),
              Text(
                banner.subtitle ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (banner.ctaLabel != null) ...[
                const Gap(7),
                Row(
                  children: [
                    BannerButton(
                      label: banner.ctaLabel!,
                      onPressed: () => _handleAction(context, banner.ctaUrl),
                      isPrimary: true,
                    ),
                    if (banner.cta2Label != null) ...[
                      const Gap(12),
                      BannerButton(
                        label: banner.cta2Label!,
                        onPressed: () => _handleAction(context, banner.cta2Url),
                        isPrimary: false,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'calendar-check':
        return Iconsax.calendar_tick;
      case 'notification':
        return Iconsax.notification;
      default:
        return Iconsax.notification;
    }
  }
}
