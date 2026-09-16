import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_my_interests_response.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_detail_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_status_section.dart';
import 'package:immoplus/app/features/messaging/widgets/message_composer_sheet.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Ordre d'affichage — en attente/en cours d'abord (ça bouge encore),
/// décliné/terminé en dernier.
const List<RelaisInterestStatus> _statusOrder = [
  RelaisInterestStatus.pending,
  RelaisInterestStatus.inProgress,
  RelaisInterestStatus.accepted,
  RelaisInterestStatus.declined,
  RelaisInterestStatus.completed,
];

const double _cardWidth = 240;

/// Sous-onglet "Mes intérêts" — relais sur lesquels j'ai cliqué "je suis
/// intéressé" (`GET /relais/interests/mine`), groupés par statut de
/// traitement par l'occupant.
class RelaisMyInterestsSection extends StatefulWidget {
  const RelaisMyInterestsSection({super.key});

  @override
  State<RelaisMyInterestsSection> createState() => _RelaisMyInterestsSectionState();
}

class _RelaisMyInterestsSectionState extends State<RelaisMyInterestsSection>
    with AutomaticKeepAliveClientMixin {
  final _relaisRepository = getIt<RelaisRepository>();
  List<MyRelaisInterestModel> _interests = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final response = await _relaisRepository.getMyRelaisInterests();
      if (mounted) setState(() => _interests = response.data);
    } catch (_) {
      // Liste vide en cas d'erreur réseau.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_interests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            "Vous n'avez encore exprimé aucun intérêt.\nParcourez \"Autour de moi\" pour découvrir des logements.",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    final groups = <RelaisInterestStatus, List<MyRelaisInterestModel>>{};
    for (final interest in _interests) {
      groups.putIfAbsent(interest.statusEnum, () => []).add(interest);
    }

    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          for (final status in _statusOrder)
            if (groups[status]?.isNotEmpty == true)
              RelaisStatusSection<MyRelaisInterestModel>(
                title: status.label,
                items: groups[status]!,
                itemBuilder: (interest) => SizedBox(
                  width: _cardWidth,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: _MyInterestCard(interest: interest),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _MyInterestCard extends StatelessWidget {
  final MyRelaisInterestModel interest;
  const _MyInterestCard({required this.interest});

  bool get _canContact =>
      interest.statusEnum == RelaisInterestStatus.inProgress ||
      interest.statusEnum == RelaisInterestStatus.accepted;

  @override
  Widget build(BuildContext context) {
    final relais = interest.relais;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: relais == null
          ? null
          : () => context.pushNamed(
                RelaisDetailPage.name,
                extra: RelaisDetailArgs(relais, false),
              ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: .2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              relais != null ? relaisPropertyTypeLabel(relais.propertyType) : 'Logement',
              style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (relais != null) ...[
              const Gap(2),
              Text(
                relais.location,
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (interest.message?.isNotEmpty == true) ...[
              const Gap(8),
              Text(
                interest.message!,
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (interest.meetingDate != null) ...[
              const Gap(8),
              Text(
                'Visite le ${DateFormat('d MMM à HH:mm', 'fr_FR').format(interest.meetingDate!)}',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
            if (_canContact && relais != null) ...[
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => MessageComposerSheet.showForRelais(
                    context,
                    relaisId: relais.id,
                    title: 'Contacter le propriétaire',
                    propertyLabel: relaisPropertyTypeLabel(relais.propertyType),
                    location: relais.location,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Contacter', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
