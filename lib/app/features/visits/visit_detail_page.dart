// ignore_for_file: prefer_is_empty

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

  /// verifier si la demande de visite contient des dates
  bool hasDateVisite(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.datesDemandeVisite.isNotEmpty;
  }

  /// verifier si la demande de visite est payé
  bool hasPaid(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.statusFacture.toString() ==
        PaymentStatus.paye.name;
  }

  bool hasNotPaid(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.statusFacture.toString() ==
        PaymentStatus.non_paye.name;
  }

  /// verifier si la demande de visite contient une facture
  bool hasExpress(DemandeVisitResponse demandeVisitResponse) {
    return demandeVisitResponse.data.typeDemandeVisite.toString() == "express";
  }

  /// Getter pour determiner si on doit afficher le bouton de paiement
  bool shouldShowPaymentButton(DemandeVisitResponse demandeVisitResponse) {
    // Cas 1: Express - afficher si pas payé ET qu'il y a des dates de visite
    if (hasExpress(demandeVisitResponse)) {
      return hasNotPaid(demandeVisitResponse) &&
          hasDateVisite(demandeVisitResponse);
    }
    return false;
  }

  /// Getter pour determiner si on doit afficher le numéro du propriétaire
  bool shouldShowOwnerPhone(DemandeVisitResponse demandeVisitResponse) {
    // Cas 1: Express - afficher si on a payé
    if (hasExpress(demandeVisitResponse)) {
      return hasPaid(demandeVisitResponse);
    }
    // Cas 2: Normal (pas express) - afficher si une date existe
    else {
      return hasDateVisite(demandeVisitResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitCubit, VisitRequestState>(
      builder: (context, state) {
        if (state is RECEIVE_VISIT) {
          return Scaffold(
            backgroundColor: AppColors.scafold,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      this.context.read<VisitCubit>().getVisit(id: widget.id);
                    },
                  ),
                  SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: EstateInfo(
                        bienImmobilierModel:
                            state.demandeVisitResponse.data.bienImmobilier!),
                  )),
                  const SliverGap(10),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Identifiant de la demande:'),
                        subtitle: SelectableText(
                            state.demandeVisitResponse.data.id.toString()),
                        dense: true,
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(FontAwesomeIcons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text: state.demandeVisitResponse.data.id
                                        .toString()))
                                .then((value) {
                              //Vibrate.feedback(FeedbackType.impact);
                              EasyLoading.showToast('Identifiant copié');
                            }).catchError((err) {
                              EasyLoading.showToast(err.toString());
                            });
                          },
                        ),
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                        subtitleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.purple),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                  SliverToBoxAdapter(
                    child: ServiceStatusSection(
                        status: state.demandeVisitResponse.data
                                .statusDemandeVisite ??
                            ''),
                  ),
                  SliverToBoxAdapter(
                    child: PaymentStatusSection(
                        demandeVisitModel: state.demandeVisitResponse.data),
                  ),
                  SliverToBoxAdapter(
                    child: ListTile(
                      //contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.calendar_month)),
                      horizontalTitleGap: 0,
                      //dense: true,
                      title: const Text(
                        'Jour de visite:',
                      ),
                      subtitle: Text(
                        (state.demandeVisitResponse.data.datesDemandeVisite
                                .isEmpty)
                            ? "Aucune date programmée"
                            : VisitUtils.formatDateTime(state
                                .demandeVisitResponse
                                .data
                                .datesDemandeVisite
                                .last
                                .date!
                                .toIso8601String()),
                        style:
                            GoogleFonts.inter(color: Colors.red, fontSize: 18),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            FontAwesomeIcons.headset,
                            color: AppColors.primary,
                          ),
                          title: const Text("Contacter nous"),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.primary),
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: AppColors.primary,
                          ),
                          onTap: () async {
                            ContactUtils.showContact(id: widget.id);
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(bottom: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: ListTile(
                          tileColor: Colors.white,
                          enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            CupertinoIcons.location,
                            color: AppColors.primary,
                          ),
                          title: const Text("Voir l'itinéraire"),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.primary),
                          trailing: Icon(
                            CupertinoIcons.chevron_right_circle_fill,
                            color: AppColors.primary,
                          ),
                          onTap: () async {
                            if (await MapLauncher.isMapAvailable(
                                    MapType.google) ??
                                false) {
                              MapLauncher.showDirections(
                                destinationTitle: state.demandeVisitResponse
                                    .data.bienImmobilier!.nom,
                                destination: Coords(
                                  state.demandeVisitResponse.data
                                      .bienImmobilier!.position.coordinates![1],
                                  state.demandeVisitResponse.data
                                      .bienImmobilier!.position.coordinates![0],
                                ),
                                directionsMode: DirectionsMode.driving,
                                mapType: MapType.google,
                              );
                            } else {
                              final availableMaps =
                                  await MapLauncher.installedMaps;
                              print(availableMaps);
                              await availableMaps.first.showDirections(
                                destinationTitle: state.demandeVisitResponse
                                    .data.bienImmobilier!.nom,
                                destination: Coords(
                                  state.demandeVisitResponse.data
                                      .bienImmobilier!.position.coordinates![1],
                                  state.demandeVisitResponse.data
                                      .bienImmobilier!.position.coordinates![0],
                                ),
                                directionsMode: DirectionsMode.driving,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  if (shouldShowOwnerPhone(state.demandeVisitResponse))
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(bottom: 10),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: ListTile(
                            tileColor: Colors.white,
                            enabled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const CircleAvatar(
                              //backgroundColor: Colors.white,
                              child: Icon(
                                FontAwesomeIcons.userTie,
                                //color: Colors.green,
                              ),
                            ),
                            title: const Text("Propriétaire"),
                            subtitle: Text(state.demandeVisitResponse.data
                                .proprietaire!.phoneNumber
                                .split('-')
                                .last
                                .toString()),
                            titleTextStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            trailing: Icon(
                              FontAwesomeIcons.phoneVolume,
                              color: AppColors.primary,
                            ),
                            subtitleTextStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.primary),
                            onTap: () async {
                              final phone = state.demandeVisitResponse.data
                                  .proprietaire!.phoneNumber
                                  .split('-');
                              Utils.makePhoneCall(phone.last);
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10)
                  .copyWith(bottom: 20),
              child: Visibility(
                visible: shouldShowPaymentButton(state.demandeVisitResponse),
                child: ListTile(
                  tileColor: Colors.red.shade400,
                  onTap: () {
                    context.pushNamed(
                      OperatorsSelectorPage.name,
                      extra: PaymentPageAdapter(
                          itemId: state.demandeVisitResponse.data.id,
                          collection: ProductType.reservations.name,
                          amount: state.demandeVisitResponse.data
                              .montantTotalDemandeVisite
                              .toInt()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 15,
                    child: Icon(
                      FontAwesomeIcons.coins,
                    ),
                  ),
                  horizontalTitleGap: 3,
                  dense: true,
                  title: Text(
                      'Payer maintenant  ${state.demandeVisitResponse.data.montantTotalDemandeVisite} Fcfa'),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                  trailing: const Icon(
                    CupertinoIcons.chevron_right_circle_fill,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        } else if (state is Error_VISITSS) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.remove_circle,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 250,
                    child: Text(
                      "Vous n'avez pas accès à cet élément ou aucun élément correspondant",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Gap(50),
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      onTap: () {
                        //context.goNamed(BookingPage.name);
                      },
                      horizontalTitleGap: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      tileColor: AppColors.primaryLite,
                      leading:
                          const Icon(CupertinoIcons.chevron_left_circle_fill),
                      title: const Text("Retour a la page d'historique"),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const LoadingPage();
      },
    );
  }
}
