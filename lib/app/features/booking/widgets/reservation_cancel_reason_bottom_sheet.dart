import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/failure_reasons/motif_item.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/booking/widgets/cancel_reason_recap_card.dart';
import 'package:immoplus/app/features/booking/widgets/residence_mini_card.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

enum ClientFailureReasonCode {
  autre('AUTRE');

  final String value;

  const ClientFailureReasonCode(this.value);
}

class ReservationCancelReasonBottomSheet extends StatefulWidget {
  final String reservationId;
  final ReservationModel? reservation;

  const ReservationCancelReasonBottomSheet({
    super.key,
    required this.reservationId,
    this.reservation,
  });

  static Future<void> show(
    BuildContext context, {
    required String reservationId,
    ReservationModel? reservation,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ReservationCancelReasonBottomSheet(
        reservationId: reservationId,
        reservation: reservation,
      ),
    );
  }

  @override
  State<ReservationCancelReasonBottomSheet> createState() =>
      _ReservationCancelReasonBottomSheetState();
}

class _ReservationCancelReasonBottomSheetState
    extends State<ReservationCancelReasonBottomSheet> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<MotifItem> _motifs = [];
  String? _selectedCode;
  final TextEditingController _commentController = TextEditingController();

  // Step 1: Formulaire de choix du motif / Step 2: Remerciement
  int _currentStep = 1;
  String _selectedReasonLabel = '';
  DateTime _respondedAt = DateTime.now();

  static const List<MotifItem> _fallbackMotifs = [
    // MotifItem(code: 'PRIX_TROP_ELEVE', label: 'Le prix était trop élevé'),
    // MotifItem(code: 'TROUVE_AUTRE_LOGEMENT', label: 'J’ai trouvé un autre logement'),
    // MotifItem(code: 'CHANGEMENT_DATES', label: 'Je dois changer les dates'),
    // MotifItem(code: 'PROBLEME_PAIEMENT', label: 'Problème lors du paiement'),
    // MotifItem(
    //   code: 'ATTENTE_TROP_LONGUE',
    //   label: 'Le pro a mis trop de temps à répondre',
    // ),
    // MotifItem(
    //   code: 'CHANGEMENT_PROJET',
    //   label: 'Mon projet de séjour a changé',
    // ),
    // MotifItem(code: 'AUTRE', label: 'Autre raison'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchMotifs();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchMotifs() async {
    try {
      final response = await getIt<ResidenceRepository>().getMotifsEchec(
        widget.reservationId,
      );
      if (mounted) {
        setState(() {
          _motifs = response.data.motifs.isNotEmpty
              ? response.data.motifs
              : _fallbackMotifs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _motifs = _fallbackMotifs;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitReason() async {
    if (_selectedCode == null) return;

    setState(() => _isSubmitting = true);

    final comment = _selectedCode == ClientFailureReasonCode.autre.value
        ? _commentController.text.trim()
        : null;

    final motif = _motifs.firstWhere(
      (m) => m.code == _selectedCode,
      orElse: () => MotifItem(code: _selectedCode!, label: _selectedCode!),
    );

    try {
      final response = await getIt<ResidenceRepository>().submitMotifEchec(
        reservationId: widget.reservationId,
        reasonCode: _selectedCode!,
        comment: comment,
      );

      if (mounted) {
        final rawDate = response.data.respondedAt;
        final respDate = rawDate != null ? DateTime.tryParse(rawDate) : null;
        setState(() {
          _isSubmitting = false;
          _selectedReasonLabel = motif.label;
          _respondedAt = respDate ?? DateTime.now();
          _currentStep = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        // En cas d'erreur de requête, on affiche quand même la confirmation locale
        setState(() {
          _isSubmitting = false;
          _selectedReasonLabel = motif.label;
          _respondedAt = DateTime.now();
          _currentStep = 2;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.04),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _currentStep == 1
              ? _buildReasonSelectionStep()
              : _buildThankYouStep(),
        ),
      ),
    );
  }

  // ── STEP 1 : Sélection du motif ─────────────────────────────────────────────
  Widget _buildReasonSelectionStep() {
    return SingleChildScrollView(
      key: const ValueKey('step_select_reason'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header avec Titre et Bouton Fermer
          Row(
            children: [
              const Spacer(),
              Text(
                'Pourquoi avez-vous annulé',
                style: AppTypography.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close,
                  size: 22,
                  color: Color(0xFF667085),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Gap(16),

          // Carte Résumé du Logement (si disponible)
          if (widget.reservation != null) ...[
            ResidenceMiniCard(reservation: widget.reservation!),
            const Gap(16),
          ],

          // Sous-titre
          Text(
            'Choisissez le motif principal. Votre réponse nous aide à améliorer les réservations.',
            style: AppTypography.bodySmall.copyWith(
              color: const Color(0xFF667085),
              height: 1.4,
            ),
          ),
          const Gap(16),

          // Liste des motifs
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CupertinoActivityIndicator()),
            )
          else ...[
            ..._motifs.map((motif) => _buildMotifItem(motif)),
            if (_selectedCode == ClientFailureReasonCode.autre.value) ...[
              const Gap(12),
              Text(
                'Précisions',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF344054),
                ),
              ),
              const Gap(6),
              TextField(
                controller: _commentController,
                maxLines: 3,
                minLines: 2,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText:
                      'Ex : Un enfant, un quartier calme, un grand jardin avec piscine...',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF98A2B3),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFEAECF0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ],

          const Gap(24),

          // Bouton primaire : Envoyer ma réponse
          CustomButtom(
            text: 'Envoyer ma réponse',
            clickable: _selectedCode != null && !_isSubmitting,
            isLoading: _isSubmitting,
            borderRadius: BorderRadius.circular(28),
            onClick: _submitReason,
          ),
          const Gap(12),

          // Bouton secondaire : Plus tard
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Plus tard',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF667085),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotifItem(MotifItem motif) {
    final isSelected = _selectedCode == motif.code;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            _selectedCode = motif.code;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC7D2FE) : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : const Color(0xFFEAECF0),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFFD0D5DD),
                          width: 1.5,
                        ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  motif.label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF1E3A8A)
                        : const Color(0xFF101828),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── STEP 2 : Remerciement ───────────────────────────────────────────────────
  Widget _buildThankYouStep() {
    return SingleChildScrollView(
      key: const ValueKey('step_thank_you'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(10),
          // Badge vert festonné / checkmark
          Center(
            child: _buildThankYouBadge(),
          ),
          const Gap(20),

          // Titre
          Text(
            'Merci, c’est noté',
            textAlign: TextAlign.center,
            style: AppTypography.h3.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101828),
            ),
          ),
          const Gap(8),

          // Sous-titre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Votre réponse nous aide à améliorer l’expérience de réservation',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: const Color(0xFF667085),
                height: 1.4,
              ),
            ),
          ),
          const Gap(28),

          // Carte récapitulative
          CancelReasonRecapCard(
            reasonLabel: _selectedReasonLabel,
            respondedAt: _respondedAt,
          ),
          const Gap(32),

          // Bouton Aller à l'accueil
          CustomButtom(
            text: 'Aller à l’accueil',
            borderRadius: BorderRadius.circular(28),
            onClick: () {
              Navigator.pop(context);
              context.goNamed(HomePage.name);
            },
          ),
          const Gap(8),
        ],
      ),
    );
  }

  Widget _buildThankYouBadge() {
    return SizedBox(
      width: 78,
      height: 78,
      child: Image.asset('assets/img/verify.png'),
    );
  }
}
