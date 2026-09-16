import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_requests.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_received_interests_response.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_status_section.dart';
import 'package:immoplus/app/features/messaging/widgets/message_composer_sheet.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

const List<RelaisInterestStatus> _statusOrder = [
  RelaisInterestStatus.pending,
  RelaisInterestStatus.inProgress,
  RelaisInterestStatus.accepted,
  RelaisInterestStatus.declined,
  RelaisInterestStatus.completed,
];

const double _cardWidth = 280;

/// Sous-onglet "Demandes reçues" — intérêts reçus sur TOUS mes relais
/// (`GET /relais/interests/received`), groupés par statut, avec réponse
/// directe (accepter en planifiant une visite / décliner) sans avoir à
/// ouvrir chaque relais individuellement.
class RelaisReceivedInterestsSection extends StatefulWidget {
  const RelaisReceivedInterestsSection({super.key});

  @override
  State<RelaisReceivedInterestsSection> createState() => _RelaisReceivedInterestsSectionState();
}

class _RelaisReceivedInterestsSectionState extends State<RelaisReceivedInterestsSection>
    with AutomaticKeepAliveClientMixin {
  final _relaisRepository = getIt<RelaisRepository>();
  List<ReceivedRelaisInterestModel> _interests = [];
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
      final response = await _relaisRepository.getReceivedRelaisInterests();
      if (mounted) setState(() => _interests = response.data);
    } catch (_) {
      // Liste vide en cas d'erreur réseau.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _respond(ReceivedRelaisInterestModel interest, {required bool accept}) async {
    DateTime? meetingDate;
    if (accept) {
      meetingDate = await _pickMeetingDate();
      if (meetingDate == null) return;
    }
    try {
      await _relaisRepository.respondToInterest(
        interest.relaisId,
        interest.id,
        RelaisInterestResponseRequest(
          status: accept ? 'in_progress' : 'declined',
          meetingDate: meetingDate?.toIso8601String(),
        ),
      );
      _fetch();
    } catch (_) {
      if (mounted) CustomPopup.showErrorToast(text: "Impossible d'envoyer votre réponse");
    }
  }

  Future<DateTime?> _pickMeetingDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
    if (time == null) return date;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
            "Aucune demande reçue pour le moment.",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    final groups = <RelaisInterestStatus, List<ReceivedRelaisInterestModel>>{};
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
              RelaisStatusSection<ReceivedRelaisInterestModel>(
                title: status.label,
                items: groups[status]!,
                itemBuilder: (interest) => SizedBox(
                  width: _cardWidth,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: _ReceivedInterestCard(
                      interest: interest,
                      onAccept: () => _respond(interest, accept: true),
                      onDecline: () => _respond(interest, accept: false),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _ReceivedInterestCard extends StatelessWidget {
  final ReceivedRelaisInterestModel interest;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _ReceivedInterestCard({required this.interest, required this.onAccept, required this.onDecline});

  bool get _canContact =>
      interest.statusEnum == RelaisInterestStatus.inProgress ||
      interest.statusEnum == RelaisInterestStatus.accepted;

  @override
  Widget build(BuildContext context) {
    final isPending = interest.statusEnum == RelaisInterestStatus.pending;
    final relais = interest.relais;

    return Container(
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
            interest.clientName ?? 'Utilisateur',
            style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (relais != null) ...[
            const Gap(4),
            Text(
              '${relaisPropertyTypeLabel(relais.propertyType)} · ${relais.location}',
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (interest.message?.isNotEmpty == true) ...[
            const Gap(8),
            Text(
              interest.message!,
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (interest.meetingDate != null) ...[
            const Gap(8),
            Text(
              'Visite prévue le ${DateFormat('d MMM yyyy à HH:mm', 'fr_FR').format(interest.meetingDate!)}',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ],
          if (isPending) ...[
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Décliner', style: GoogleFonts.dmSans(color: Colors.red, fontWeight: FontWeight.w600)),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Planifier',
                        style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
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
                  title: 'Contacter ${interest.clientName ?? "le demandeur"}',
                  propertyLabel: relaisPropertyTypeLabel(relais.propertyType),
                  location: relais.location,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Contacter', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
