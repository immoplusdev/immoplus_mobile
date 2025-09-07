import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';
import 'package:intl/intl.dart';

class VisitHistoryCard extends StatelessWidget {
  VisitHistoryCard({super.key, required this.demandeVisiteModel});
  final DemandeVisiteModel demandeVisiteModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: AppColors.scafold,
            showDragHandle: true,
            enableDrag: true,
            isScrollControlled: true,
            useRootNavigator: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (context) => FractionallySizedBox(
                heightFactor: 0.7,
                child: VisitDetailPage(
                  id: demandeVisiteModel.id,
                )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Ombre douce
                  spreadRadius: 1, // L'étendue de l'ombre
                  blurRadius: 10, // Flou de l'ombre
                  offset: const Offset(0, 0), // Décalage horizontal et vertical
                ),
              ]),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //horizontalTitleGap: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomChip(
                      backgroundColor:
                          (demandeVisiteModel.typeDemandeVisite == 'express')
                              ? Colors.redAccent
                              : Colors.purple.shade300,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                      icon: FontAwesomeIcons.stopwatch20,
                      iconColor: Colors.white,
                      iconSize: 15,
                      label: demandeVisiteModel.typeDemandeVisite.toString()),
                  if (demandeVisiteModel.bienImmobilier != null)
                    CustomChip(
                      icon: FontAwesomeIcons.signHanging,
                      label: demandeVisiteModel.bienImmobilier!.nom,
                      iconSize: 15,
                      backgroundColor: CupertinoColors.systemFill,
                    ),
                ],
              ),
              const Gap(5),
              if (demandeVisiteModel.bienImmobilier != null)
                Text("📍 ${demandeVisiteModel.bienImmobilier!.adresse}"),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.circleUser,
                        size: 15,
                      ),
                      const Gap(5),
                      Text("${demandeVisiteModel.clientPhoneNumber}")
                    ],
                  ),
                  AutoSizeText(
                    maxLines: 1,
                    Utils.formatCurrency(
                        demandeVisiteModel.montantTotalDemandeVisite),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.shade300,
              ),
              if (!demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                Material(
                  child: ListTile(
                    leading: const Icon(
                      CupertinoIcons.calendar_badge_plus,
                      color: Colors.red,
                    ),
                    tileColor: Colors.white,
                    horizontalTitleGap: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const AutoSizeText(
                        maxLines: 2,
                        "Aucun jour de visite n'a été planifié pour le moment"),
                    // trailing: const Icon(
                    //   FontAwesomeIcons.circleChevronRight,
                    //   color: Colors.red,
                    //   size: 18,
                    // ),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.red),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                    Chip(
                      avatar: Icon(
                        color: AppColors.primary,
                        FontAwesomeIcons.triangleExclamation,
                        size: 15,
                      ),
                      backgroundColor: AppColors.scafold,
                      label: Text(Utils.formatDatOnly(
                          dateTime: demandeVisiteModel
                              .datesDemandeVisite.first.date!)),
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                    ),
                  if (demandeVisiteModel.datesDemandeVisite.isNotEmpty)
                    AutoSizeText(
                      Utils.formatTimeOnly(
                          dateTime: demandeVisiteModel
                              .datesDemandeVisite.first.date!),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.primary),
                    ),
                ],
              )
            ],
          ),

          // leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodySmall,
          // titleTextStyle: Theme.of(context).textTheme.bodyLarge,
          // subtitleTextStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
