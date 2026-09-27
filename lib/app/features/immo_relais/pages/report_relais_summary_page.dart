import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_request.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/models/relais_draft.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_success_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Écran 3 (récapitulatif) : "Ma demande" — relit le brouillon, envoie
/// `POST /relais` (flux B) au clic sur "Donner l'information".
class ReportRelaisSummaryPage extends StatefulWidget {
  final RelaisDraft draft;
  const ReportRelaisSummaryPage({super.key, required this.draft});
  static const String name = 'REPORT_RELAIS_SUMMARY_PAGE';

  @override
  State<ReportRelaisSummaryPage> createState() => _ReportRelaisSummaryPageState();
}

class _ReportRelaisSummaryPageState extends State<ReportRelaisSummaryPage> {
  final _relaisRepository = getIt<RelaisRepository>();
  bool _isSubmitting = false;

  RelaisDraft get _draft => widget.draft;

  DateTime get _estimatedAvailability {
    final now = DateTime.now();
    return switch (_draft.availabilityPreset?.value) {
      'immediate' => now,
      'two_weeks' => now.add(const Duration(days: 14)),
      'next_month' => DateTime(now.year, now.month + 1, 1),
      _ => now,
    };
  }

  String get _availabilityLabel {
    final formatted = DateFormat.yMMMM('fr_FR').format(_estimatedAvailability);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final photoIds = <String>[];
      for (final file in _draft.photos) {
        final id = await uploadFile(file: file);
        if (id != null) photoIds.add(id);
      }

      await _relaisRepository.createRelais(RelaisRequest(
        propertyType: _draft.propertyType!.backendSlug,
        location: _draft.commune!,
        landmark: _draft.landmarkAddress?.description,
        rooms: _draft.rooms,
        reporterRelation: _draft.reporterRelation!.value,
        reporterRelationDetails: _draft.reporterRelationDetails,
        availabilityPreset: _draft.availabilityPreset!.value,
        photos: photoIds,
      ));

      if (mounted) context.pushNamed(ReportRelaisSuccessPage.name);
    } catch (_) {
      if (mounted) {
        CustomPopup.showErrorToast(text: "Impossible d'envoyer votre demande, réessayez.");
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
          'Ma demande',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre demande de logement',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Gap(12),
              _buildSummaryCard(),
              const Gap(16),
              _buildPrivacyNote(),
              const Gap(16),
              _buildWhatsNext(),
              const Gap(32),
              CustomLoadingButtom(
                text: "Donner l'information",
                isLoading: _isSubmitting,
                onClick: _submit,
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Info active',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              Text(
                'Publication anonyme',
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Gap(16),
          _summaryRow('Quartier', _draft.commune ?? '—'),
          if (_draft.landmarkAddress?.description != null)
            _summaryRow('Repère ou adresse précise', _draft.landmarkAddress!.description!),
          _summaryRow(
            'Type',
            '${_draft.propertyType?.label ?? '—'} · ${_draft.rooms} chambre${_draft.rooms > 1 ? 's' : ''}',
          ),
          _summaryRow('Disponibilité', _availabilityLabel, noDivider: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool noDivider = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade500)),
              const Gap(12),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (!noDivider) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.location, size: 18, color: Colors.black87),
          const Gap(10),
          Expanded(
            child: Text(
              'Votre identité reste privée. Les utilisateurs voient uniquement l\'info de façon anonyme.',
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNext() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ce qui se passe ensuite',
            style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Gap(12),
          Text(
            'Votre info est envoyée à tous les utilisateurs qui cherchent des appartements à ${_draft.commune ?? ''}',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.primary, height: 1.4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          Text(
            "Imatch ne montre que l'information sans autre précision",
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.primary, height: 1.4),
          ),
        ],
      ),
    );
  }
}
