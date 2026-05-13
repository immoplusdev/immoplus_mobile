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
import 'package:immoplus/app/features/alert/pages/alert_list_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_propositions_page.dart';

enum BannerAction {
  annulerReservation('/annuler_reservation'),
  payerReservation('/payer_reservation'),
  payerExpress('/payer_express'),
  // annulerVisite('/annuler_visite'),
  mesAlertes('/mes_alertes'),
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

// final List<BannerModel> testBanners = [
//   BannerModel(
//     id: 1,
//     title: 'Paiement Express',
//     subtitle: 'Réglez votre visite en un clic',
//     ctaLabel: 'Payer 5 000 FCFA',
//     ctaUrl: '/payer_express',
//     metadata: {
//       'demande_visite_id': 'VISIT-123',
//       'montant_total': 5000,
//     },
//   ),
//   BannerModel(
//     id: 2,
//     title: 'Mes propositions',
//     subtitle: '5 nouvelles offres correspondent à vos critères',
//     ctaLabel: 'Voir les offres',
//     ctaUrl: '/mes_alertes',
//     metadata: {
//       'alert_id': 'ALERT-456',
//       'nb_propositions': 5,
//     },
//   ),
//   BannerModel(
//     id: 3,
//     title: 'Gérer mes alertes',
//     subtitle: 'Modifiez vos critères de recherche',
//     ctaLabel: 'Mes alertes',
//     ctaUrl: '/mes_alertes',
//     metadata: {
//       'nb_propositions': 0,
//     },
//   ),
// ];

class BannerItem extends StatelessWidget {
  final BannerModel banner;

  const BannerItem({super.key, required this.banner});

  void _handleAction(BuildContext context, String? url) {
    if (url == null) return;

    final action = BannerAction.fromUrl(url);
    final metadata = banner.metadata ?? {};

    switch (action) {
      case BannerAction.payerReservation:
        final reservationId = metadata['reservation_id']?.toString();
        final amount = metadata['montant_paye'];
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
        final reservationId = metadata['reservation_id']?.toString();
        if (reservationId != null) {
          _showCancelConfirmation(context, reservationId);
        }
        break;
      case BannerAction.payerExpress:
        final visiteId = metadata['demande_visite_id']?.toString();
        final montant = metadata['montant_total'];
        if (visiteId != null && montant != null) {
          context.pushNamed(
            OperatorsSelectorPage.name,
            extra: PaymentPageAdapter(
              itemId: visiteId,
              collection: ProductType.demandes_visites.name,
              amount: montant is int
                  ? montant
                  : int.tryParse(montant.toString()) ?? 0,
            ),
          );
        }
        break;
      // case BannerAction.annulerVisite:
      //   final visiteId = metadata['demande_visite_id']?.toString();
      //   final bienNom = metadata['bien_nom']?.toString();
      //   if (visiteId != null) {
      //     _showCancelVisiteConfirmation(context, visiteId, bienNom);
      //   }
      //   break;
      case BannerAction.mesAlertes:
        final alertId = metadata['alert_id']?.toString();
        final nbPropositions =
            int.tryParse(metadata['nb_propositions']?.toString() ?? '0') ?? 0;

        if (alertId != null && nbPropositions > 0) {
          context.pushNamed(
            AlertPropositionsPage.name,
            pathParameters: {'id': alertId},
          );
        } else {
          context.pushNamed(AlertListPage.name);
        }
        break;
      default:
        // Gérer d'autres URLs ou liens profonds ici
        break;
    }
  }

  // void _showCancelVisiteConfirmation(
  //     BuildContext context, String visiteId, String? bienNom) {
  //   AppDialog.show(
  //     title: 'Annuler la visite',
  //     description:
  //         'Voulez-vous vraiment annuler votre demande de visite pour ${bienNom ?? "ce bien"} ?',
  //     primaryButtonText: 'Oui, annuler',
  //     secondButtonText: 'Non',
  //     onPrimary: () async {
  //       try {
  //         await getIt<BienImmobilierRepository>().annulerVisiteClient(
  //           visiteId: visiteId,
  //           notes: 'Annulé depuis la bannière promotionnelle',
  //         );
  //         ToastUtils.showSuccess(
  //           description: 'Demande de visite annulée avec succès',
  //         );
  //       } catch (e) {
  //         ToastUtils.showError(
  //           description: 'Erreur lors de l\'annulation de la visite',
  //         );
  //       }
  //     },
  //   );
  // }

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
