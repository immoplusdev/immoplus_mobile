import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interest_requests.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_interests_response.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:intl/intl.dart';

/// Demandeurs intéressés par mon relais — `GET /relais/:id/interests`, et
/// réponse (accepter/décliner) via `PATCH /relais/:id/interests/:interestId`.
class RelaisInterestsPage extends StatefulWidget {
  final String relaisId;
  const RelaisInterestsPage({super.key, required this.relaisId});
  static const String name = 'RELAIS_INTERESTS_PAGE';

  @override
  State<RelaisInterestsPage> createState() => _RelaisInterestsPageState();
}

class _RelaisInterestsPageState extends State<RelaisInterestsPage> {
  final _relaisRepository = getIt<RelaisRepository>();
  List<RelaisInterestModel> _interests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final response = await _relaisRepository.getRelaisInterests(widget.relaisId);
      if (mounted) setState(() => _interests = response.data.interestedParties);
    } catch (_) {
      // Liste vide en cas d'erreur réseau — pas de crash, juste rien à montrer.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _respond(RelaisInterestModel interest, {required bool accept}) async {
    DateTime? meetingDate;
    if (accept) {
      meetingDate = await _pickMeetingDate();
      if (meetingDate == null) return; // Annulé par l'utilisateur.
    }

    try {
      await _relaisRepository.respondToInterest(
        widget.relaisId,
        interest.id,
        RelaisInterestResponseRequest(
          status: accept ? 'in_progress' : 'declined',
          meetingDate: meetingDate?.toIso8601String(),
        ),
      );
      _fetch();
    } catch (_) {
      if (mounted) CustomPopup.showErrorToast(text: 'Impossible d\'envoyer votre réponse');
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Personnes intéressées',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _interests.isEmpty
                ? Center(
                    child: Text(
                      'Personne ne s\'est encore manifesté.',
                      style: GoogleFonts.dmSans(color: Colors.grey.shade500),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetch,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _interests.length,
                      separatorBuilder: (context, index) => const Gap(16),
                      itemBuilder: (context, index) => _InterestCard(
                        interest: _interests[index],
                        onAccept: () => _respond(_interests[index], accept: true),
                        onDecline: () => _respond(_interests[index], accept: false),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  final RelaisInterestModel interest;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _InterestCard({required this.interest, required this.onAccept, required this.onDecline});

  @override
  Widget build(BuildContext context) {
    final status = interest.statusEnum;
    final isPending = status == RelaisInterestStatus.pending;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  interest.clientName ?? 'Utilisateur',
                  style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.label,
                  style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: status.textColor),
                ),
              ),
            ],
          ),
          if (interest.message?.isNotEmpty == true) ...[
            const Gap(8),
            Text(
              interest.message!,
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
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
                    child: Text('Planifier une visite',
                        style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
