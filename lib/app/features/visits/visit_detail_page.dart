// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/payment_module/utils/visit_utils.dart';
import 'package:immoplus/app/features/visits/logic/visit_cubit.dart';
import 'package:immoplus/app/features/visits/logic/visit_request_state.dart';
import 'package:immoplus/app/features/visits/widgets/estate_info.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/payment_status_section.dart';
import 'package:immoplus/app/widgets/service_status_section.dart';
import 'package:map_launcher/map_launcher.dart';

class VisitDetailPage extends StatefulWidget {
  const VisitDetailPage({super.key, required this.id});
  final String id;
  @override
  State<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<VisitCubit>().getVisit(id: widget.id);
  }

  bool hasDateVisite(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.datesDemandeVisite.isNotEmpty;
  }

  bool hasPaid(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.statusFacture.toString() ==
        PaymentStatus.paye.name;
  }

  bool hasNotPaid(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.statusFacture.toString() ==
        PaymentStatus.non_paye.name;
  }

  bool hasExpress(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.typeDemandeVisite.toString() == "express";
  }

  bool shouldShowPaymentButton(DemandeVisitResponse demandeVisitResponse) {
    if (hasExpress(demandeVisitResponse)) {
      return hasNotPaid(demandeVisitResponse) &&
          hasDateVisite(demandeVisitResponse);
    }
    return false;
  }

  bool shouldShowOwnerPhone(DemandeVisitResponse demandeVisitResponse) {
    if (hasExpress(demandeVisitResponse)) {
      return hasPaid(demandeVisitResponse);
    } else {
      return hasDateVisite(demandeVisitResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitCubit, VisitRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_VISIT) {
          final data = state.demandeVisitResponse.data;
          final isExpress = data.typeDemandeVisite.toString() == "express";

          return Scaffold(
            backgroundColor: AppColors.whiteBackground,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      this.context.read<VisitCubit>().getVisit(id: widget.id);
                    },
                  ),

                  // Info du bien immobilier
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EstateInfo(
                          bienImmobilierModel: data.bienImmobilier!),
                    ),
                  ),
                  const SliverGap(16),

                  // Badge type visite + Identifiant
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF2F4F7)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Type visite badge
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isExpress
                                        ? const Color(0xFFFEF3F2)
                                        : const Color(0xFFF4F3FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isExpress
                                            ? Iconsax.flash_1
                                            : Iconsax.calendar_1,
                                        size: 14,
                                        color: isExpress
                                            ? const Color(0xFFF04438)
                                            : const Color(0xFF7A5AF8),
                                      ),
                                      const Gap(4),
                                      Text(
                                        isExpress
                                            ? 'VISITE EXPRESS'
                                            : 'VISITE NORMALE',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isExpress
                                              ? const Color(0xFFF04438)
                                              : const Color(0xFF7A5AF8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(12),

                            // Identifiant
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Identifiant de la demande',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: const Color(0xFF667085),
                                            ),
                                      ),
                                      const Gap(2),
                                      SelectableText(
                                        data.id.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF344054),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                            text: data.id.toString()))
                                        .then((_) {
                                      EasyLoading.showToast('Identifiant copié');
                                    }).catchError((err) {
                                      EasyLoading.showToast(err.toString());
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLite,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Iconsax.copy,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverGap(12),

                  // Statut du service + Statut paiement
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF2F4F7)),
                        ),
                        child: Column(
                          children: [
                            ServiceStatusSection(
                                status:
                                    data.statusDemandeVisite ?? ''),
                            Divider(
                                height: 1, color: const Color(0xFFF2F4F7)),
                            PaymentStatusSection(
                                demandeVisitModel: data),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverGap(12),

                  // Jour de visite
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF2F4F7)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: data.datesDemandeVisite.isEmpty
                                    ? const Color(0xFFFFFAEB)
                                    : AppColors.primaryLite,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Iconsax.calendar_1,
                                size: 20,
                                color: data.datesDemandeVisite.isEmpty
                                    ? const Color(0xFFF79009)
                                    : AppColors.primary,
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jour de visite',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF667085),
                                        ),
                                  ),
                                  const Gap(2),
                                  Text(
                                    data.datesDemandeVisite.isEmpty
                                        ? "Aucune date programmée"
                                        : VisitUtils.formatDateTime(data
                                            .datesDemandeVisite
                                            .last
                                            .date!
                                            .toIso8601String()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: data
                                                  .datesDemandeVisite.isEmpty
                                              ? const Color(0xFFB54708)
                                              : AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverGap(12),

                  // Actions: Itinéraire
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildActionTile(
                        context,
                        icon: Iconsax.location,
                        title: "Voir l'itinéraire",
                        subtitle: "Ouvrir dans Maps",
                        onTap: () => _openMaps(state),
                      ),
                    ),
                  ),
                  const SliverGap(8),

                  // Propriétaire
                  if (shouldShowOwnerPhone(state.demandeVisitResponse))
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildActionTile(
                          context,
                          icon: Iconsax.user,
                          title: "Propriétaire",
                          subtitle: data.proprietaire!.phoneNumber
                              .split('-')
                              .last,
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Iconsax.call,
                              size: 20,
                              color: Color(0xFF12B76A),
                            ),
                          ),
                          onTap: () {
                            final phone = data.proprietaire!.phoneNumber
                                .split('-');
                            Utils.makePhoneCall(phone.last);
                          },
                        ),
                      ),
                    ),
                  if (shouldShowOwnerPhone(state.demandeVisitResponse))
                    const SliverGap(8),

                  // Service client
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildActionTile(
                        context,
                        icon: Iconsax.headphone,
                        title: "Service client",
                        subtitle: "Besoin d'aide ?",
                        onTap: () {
                          ContactUtils.showContact(id: widget.id);
                        },
                      ),
                    ),
                  ),

                  // Espace pour le bouton de paiement en bas
                  SliverGap(shouldShowPaymentButton(state.demandeVisitResponse)
                      ? 100
                      : 30),
                ],
              ),
            ),

            // Bouton payer en bas
            bottomSheet: shouldShowPaymentButton(state.demandeVisitResponse)
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16)
                        .copyWith(bottom: 24, top: 12),
                    decoration: BoxDecoration(
                      color: AppColors.whiteBackground,
                      border: const Border(
                        top: BorderSide(color: Color(0xFFF2F4F7)),
                      ),
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.pushNamed(
                              OperatorsSelectorPage.name,
                              extra: PaymentPageAdapter(
                                  itemId: data.id,
                                  collection:
                                      ProductType.demandes_visites.name,
                                  amount: data
                                      .montantTotalDemandeVisite
                                      .toInt()),
                            );
                          },
                          icon: const Icon(Iconsax.card, size: 20),
                          label: Text(
                            'Payer ${Utils.formatCurrency(data.montantTotalDemandeVisite)}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          );
        } else if (state is Error_VISITSS) {
          return Scaffold(
            backgroundColor: AppColors.whiteBackground,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: AppColors.whiteBackground,
              surfaceTintColor: Colors.transparent,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Iconsax.info_circle,
                        size: 36,
                        color: Color(0xFFF04438),
                      ),
                    ),
                    const Gap(24),
                    Text(
                      "Élément introuvable",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Gap(8),
                    Text(
                      "Vous n'avez pas accès à cet élément ou aucun élément correspondant n'a été trouvé.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF667085),
                            height: 1.5,
                          ),
                    ),
                    const Gap(32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (context.canPop()) context.pop();
                        },
                        icon: const Icon(Iconsax.arrow_left, size: 18),
                        label: const Text("Retour"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const LoadingPage();
      },
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF2F4F7)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF667085),
                        ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: const Color(0xFF98A2B3),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMaps(RECEIVE_VISIT state) async {
    final bienImmo = state.demandeVisitResponse.data.bienImmobilier!;
    final destination = Coords(
      bienImmo.position.coordinates![1],
      bienImmo.position.coordinates![0],
    );

    if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
      MapLauncher.showDirections(
        destinationTitle: bienImmo.nom,
        destination: destination,
        directionsMode: DirectionsMode.driving,
        mapType: MapType.google,
      );
    } else {
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showDirections(
        destinationTitle: bienImmo.nom,
        destination: destination,
        directionsMode: DirectionsMode.driving,
      );
    }
  }
}
