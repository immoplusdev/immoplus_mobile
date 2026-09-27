import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/enums/relais_availability_preset.dart';
import 'package:immoplus/app/data/enums/relais_reporter_relation.dart';
import 'package:immoplus/app/features/immo_relais/models/relais_draft.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_summary_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_intro_header.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Écran 2/2 du flux B : disponibilité + lien du déclarant avec le
/// logement + confirmation.
class ReportRelaisStep2Page extends StatefulWidget {
  final RelaisDraft draft;
  const ReportRelaisStep2Page({super.key, required this.draft});
  static const String name = 'REPORT_RELAIS_STEP2_PAGE';

  @override
  State<ReportRelaisStep2Page> createState() => _ReportRelaisStep2PageState();
}

class _ReportRelaisStep2PageState extends State<ReportRelaisStep2Page> {
  final _detailsController = TextEditingController();
  bool _confirmed = false;

  RelaisDraft get _draft => widget.draft;

  @override
  void initState() {
    super.initState();
    _detailsController.text = _draft.reporterRelationDetails ?? '';
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_draft.availabilityPreset == null) {
      CustomPopup.showErrorToast(text: 'Veuillez choisir une disponibilité');
      return;
    }
    if (_draft.reporterRelation == null) {
      CustomPopup.showErrorToast(text: 'Veuillez préciser votre lien avec ce logement');
      return;
    }
    if (!_confirmed) {
      CustomPopup.showErrorToast(
          text: 'Veuillez confirmer que ce logement ne vous appartient pas');
      return;
    }
    _draft.reporterRelationDetails =
        _detailsController.text.trim().isEmpty ? null : _detailsController.text.trim();
    context.pushNamed(ReportRelaisSummaryPage.name, extra: _draft);
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
          'Publiez votre ancien logement',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RelaisIntroHeader(),
              const Gap(24),
              _sectionLabel('Disponible à partir de'),
              const Gap(12),
              ...RelaisAvailabilityPreset.values.map(_buildAvailabilityOption),
              const Gap(24),
              _sectionLabel('Quel est votre lien avec ce logement ?'),
              const Gap(12),
              ...RelaisReporterRelation.values.map(_buildRelationOption),
              if (_draft.reporterRelation == RelaisReporterRelation.other) ...[
                const Gap(12),
                TextField(
                  controller: _detailsController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Précisez votre lien avec ce logement',
                    hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
              const Gap(16),
              _buildConfirmCheckbox(),
              const Gap(32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(43),
                          ),
                        ),
                        child: Text(
                          'Retour',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: CustomLoadingButtom(
                      text: 'Continuer',
                      isLoading: false,
                      onClick: _continue,
                    ),
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAvailabilityOption(RelaisAvailabilityPreset preset) {
    final isSelected = _draft.availabilityPreset == preset;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _draft.availabilityPreset = preset),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Text(
            preset.label,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelationOption(RelaisReporterRelation relation) {
    final isSelected = _draft.reporterRelation == relation;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => setState(() => _draft.reporterRelation = relation),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                relation.label,
                style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const Gap(2),
              Text(
                relation.description,
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _confirmed,
          activeColor: AppColors.primary,
          onChanged: (value) => setState(() => _confirmed = value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _confirmed = !_confirmed),
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Je confirme que ce logement ne m'appartient pas et que je signale simplement sa disponibilité, à titre d'information.",
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
