import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/payment_module/utils/visit_utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';

class VisitPendingPage extends StatefulWidget {
  static const String name = 'visit_pending';

  final BienImmobilierModel bienImmo;
  final String visitType;
  final String visitId;
  final bool fromHistory;

  const VisitPendingPage({
    super.key,
    required this.bienImmo,
    required this.visitType,
    required this.visitId,
    this.fromHistory = false,
  });

  @override
  State<VisitPendingPage> createState() => _VisitPendingPageState();
}

class _VisitPendingPageState extends State<VisitPendingPage>
    with SingleTickerProviderStateMixin {
  // ── Couleurs ──────────────────────────────────────────────────────────────
  static const Color _primaryBlue = Color(0xFF2744DE);
  static const Color _successGreen = Color(0xFF22C55E);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _bgColor = Color(0xFFFFFFFF);

  // ── État de la visite (polling) ───────────────────────────────────────────
  DemandeVisiteModel? _visitData;
  Timer? _pollTimer;
  static const Duration _pollInterval = Duration(seconds: 8);

  // ── Messages rotatifs ─────────────────────────────────────────────────────
  static const List<String> _waitingMessages = [
    'Votre demande a bien été envoyée',
    'Le propriétaire va consulter votre demande…',
    'Vous serez notifié dès qu\'il y a du nouveau',
    'Restez serein, on s\'occupe de tout',
  ];

  static const List<String> _confirmedMessages = [
    'Le propriétaire a validé votre demande !',
    'Finalisez le paiement pour confirmer',
  ];

  int _messageIndex = 0;
  Timer? _messageTimer;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool get _isExpress => widget.visitType == 'express';

  // ── Logique statut (même que visit_detail_page) ───────────────────────────
  bool get _hasDateVisite =>
      _visitData != null && _visitData!.datesDemandeVisite.isNotEmpty;

  bool get _hasNotPaid =>
      _visitData?.statusFacture?.toString() == PaymentStatus.non_paye.name;

  bool get _isConfirmedByOwner => _hasDateVisite;

  bool get _hasPaid =>
      _visitData?.statusFacture?.toString() == PaymentStatus.paye.name;

  bool get _shouldShowPayment =>
      _isExpress && _isConfirmedByOwner && _hasNotPaid;

  bool get _shouldShowOwnerPhone {
    if (_visitData == null) return false;
    if (_isExpress) return _hasPaid;
    return _hasDateVisite;
  }

  List<String> get _activeMessages =>
      _isConfirmedByOwner ? _confirmedMessages : _waitingMessages;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _startMessageRotation();
    _fetchVisit();
    _startPolling();
  }

  // ── Polling ───────────────────────────────────────────────────────────────
  void _startPolling() {
    _pollTimer = Timer.periodic(_pollInterval, (_) => _fetchVisit());
  }

  Future<void> _fetchVisit() async {
    try {
      final repo = getIt<BienImmobilierRepository>();
      final response = await repo.getVisit(id: widget.visitId);
      if (!mounted) return;
      final oldConfirmed = _isConfirmedByOwner;
      setState(() => _visitData = response.data);
      // Si le statut vient de changer, reset les messages
      if (!oldConfirmed && _isConfirmedByOwner) {
        _messageIndex = 0;
      }
    } catch (_) {
      // silently ignore polling errors
    }
  }

  // ── Messages rotatifs ─────────────────────────────────────────────────────
  void _startMessageRotation() {
    _messageTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _rotateMessage();
    });
  }

  Future<void> _rotateMessage() async {
    await _fadeController.reverse();
    if (!mounted) return;
    setState(
        () => _messageIndex = (_messageIndex + 1) % _activeMessages.length);
    await _fadeController.forward();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _pollTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _isConfirmedByOwner ? 'Demande confirmée' : 'Demande envoyée',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(HomePage.name);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // ── Lottie ────────────────────────────────────────────────────────
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            height: 450,
            child: Lottie.asset(
              _isConfirmedByOwner
                  ? 'assets/lotties/success.json'
                  : 'assets/lotties/agenda.json',
              fit: BoxFit.contain,
              repeat: !_isConfirmedByOwner,
            ),
          ),

          // ── Sheet ─────────────────────────────────────────────────────────
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.50,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Badge type visite ─────────────────────────────────
                      _buildVisitTypeBadge(),
                      const SizedBox(height: 16),

                      // ── Nom du bien ───────────────────────────────────────
                      Text(
                        widget.bienImmo.nom,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ── Adresse ───────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.location,
                                size: 14, color: _textSecondary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                widget.bienImmo.adresse,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Status card ───────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _isConfirmedByOwner
                            ? _buildConfirmedStatusCard()
                            : _buildWaitingStatusCard(),
                      ),
                      const SizedBox(height: 16),

                      // ── Info contextuelle ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _isConfirmedByOwner
                              ? _buildConfirmedInfoCard()
                              : _buildWaitingInfoCard(),
                        ),
                      ),
                      const SizedBox(height: 20),

     // ── Jour de visite ──────────────────────────────────
                      if (_visitData != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildVisitDateSection(),
                        ),
                      if (_visitData != null) const SizedBox(height: 12),

                      // ── Actions (itinéraire, propriétaire, service client)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildDetailActions(),
                      ),
                     

                      // ── Statuts (service + paiement) ────────────────────
                      if (_visitData != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildStatusSection(),
                        ),
                      if (_visitData != null) const SizedBox(height: 12),

                  // ── Identifiant de la demande ───────────────────────
                      if (_visitData != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildIdSection(),
                        ),
                      if (_visitData != null) const SizedBox(height: 12),
                      const SizedBox(height: 24),

                      // ── Boutons ───────────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: _buildActions(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Badge type visite ─────────────────────────────────────────────────────
  Widget _buildVisitTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isExpress ? const Color(0xFFFEF3F2) : const Color(0xFFF4F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isExpress ? Iconsax.flash_1 : Iconsax.calendar_1,
            size: 14,
            color:
                _isExpress ? const Color(0xFFF04438) : const Color(0xFF7A5AF8),
          ),
          const SizedBox(width: 6),
          Text(
            _isExpress ? 'VISITE EXPRESS' : 'VISITE NORMALE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _isExpress
                  ? const Color(0xFFF04438)
                  : const Color(0xFF7A5AF8),
            ),
          ),
        ],
      ),
    );
  }

  // ── En attente ────────────────────────────────────────────────────────────
  Widget _buildWaitingStatusCard() {
    return Padding(
      key: const ValueKey('waiting'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _primaryBlue.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.tick_circle,
                  color: _primaryBlue, size: 22),
            ),
            const SizedBox(height: 12),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                _activeMessages[_messageIndex % _activeMessages.length],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirmé par le propriétaire ──────────────────────────────────────────
  Widget _buildConfirmedStatusCard() {
    return Padding(
      key: const ValueKey('confirmed'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEBFFF3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child:
                  Icon(Iconsax.tick_circle, color: _successGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Demande validée par le propriétaire',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166534),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _shouldShowPayment
                        ? 'Finalisez votre paiement pour confirmer la visite'
                        : 'Votre visite est confirmée',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFF166534).withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info en attente ───────────────────────────────────────────────────────
  Widget _buildWaitingInfoCard() {
    return Container(
      key: const ValueKey('info_waiting'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.notification,
                color: _primaryBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isExpress ? 'Intervention rapide' : 'Nous vous contacterons',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _primaryBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isExpress
                      ? 'Vous serez notifié de la date et heure très bientôt'
                      : 'La date et l\'heure vous seront communiquées par notification',
                  style: TextStyle(
                    fontSize: 11,
                    color: _primaryBlue.withValues(alpha: 0.65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info confirmée ────────────────────────────────────────────────────────
  Widget _buildConfirmedInfoCard() {
    if (_shouldShowPayment && _visitData != null) {
      return Container(
        key: const ValueKey('info_payment'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF68A3A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.wallet_2,
                  color: Color(0xFFF68A3A), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paiement requis : ${Utils.formatCurrency(_visitData!.montantTotalDemandeVisite)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF68A3A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Payez pour confirmer définitivement votre visite',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xFFF68A3A).withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Visite normale confirmée ou déjà payée
    return Container(
      key: const ValueKey('info_confirmed'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBFFF3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _successGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.calendar_tick,
                color: _successGreen, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visite planifiée',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Vous serez notifié de la date et l\'heure exactes',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF3D8B5E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Boutons ───────────────────────────────────────────────────────────────
  Widget _buildActions() {
    if (_shouldShowPayment && _visitData != null) {
      return Column(
        key: const ValueKey('actions_payment'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pushNamed(
                  OperatorsSelectorPage.name,
                  extra: PaymentPageAdapter(
                    itemId: _visitData!.id,
                    collection: ProductType.demandes_visites.name,
                    amount: _visitData!.montantTotalDemandeVisite.toInt(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.wallet_2, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Payer ${Utils.formatCurrency(_visitData!.montantTotalDemandeVisite)}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  if (widget.fromHistory && context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(HomePage.name);
                  }
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text(
                  widget.fromHistory ? 'Retour' : 'Sauvegarder et Quitter',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      key: const ValueKey('actions_quit'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (widget.fromHistory && context.canPop()) {
              context.pop();
            } else {
              context.goNamed(HomePage.name);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: _primaryBlue, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.fromHistory ? Iconsax.arrow_left : Iconsax.save_2, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.fromHistory ? 'Retour' : 'Sauvegarder et Quitter',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Identifiant de la demande ──────────────────────────────────────────────
  Widget _buildIdSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Iconsax.document_text, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Identifiant',
                  style: TextStyle(fontSize: 11, color: _textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  _visitData!.id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: _visitData!.id)).then((_) {
                EasyLoading.showToast('Identifiant copié');
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Iconsax.copy, size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Statuts (service + paiement) ───────────────────────────────────────────
  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        children: [
          // Statut du service
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getServiceStatusBgColor(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getServiceStatusIcon(),
                  size: 18,
                  color: _getServiceStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statut du service',
                      style: TextStyle(fontSize: 11, color: _textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Utils.getServiceStatus(
                          _visitData!.statusDemandeVisite ?? ''),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getServiceStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF2F4F7)),
          ),
          // Statut de paiement
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _hasPaid
                      ? const Color(0xFFECFDF3)
                      : const Color(0xFFFFF4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _hasPaid ? Iconsax.tick_circle : Iconsax.wallet_2,
                  size: 18,
                  color: _hasPaid
                      ? const Color(0xFF12B76A)
                      : const Color(0xFFF68A3A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statut de paiement',
                      style: TextStyle(fontSize: 11, color: _textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _visitData!.statusFacture?.toString() ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _hasPaid
                            ? const Color(0xFF12B76A)
                            : const Color(0xFFF68A3A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getServiceStatusColor() {
    final status = _visitData?.statusDemandeVisite ?? '';
    return Utils.getServiceStatusColor(status);
  }

  Color _getServiceStatusBgColor() {
    final color = _getServiceStatusColor();
    return color.withValues(alpha: 0.1);
  }

  IconData _getServiceStatusIcon() {
    final status = _visitData?.statusDemandeVisite ?? '';
    if (status == 'en_attente') return Iconsax.clock;
    if (status == 'en_cours') return Iconsax.refresh;
    if (status == 'termine') return Iconsax.tick_circle;
    if (status == 'annule') return Iconsax.close_circle;
    return Iconsax.info_circle;
  }

  // ── Jour de visite ─────────────────────────────────────────────────────────
  Widget _buildVisitDateSection() {
    final hasDate = _visitData!.datesDemandeVisite.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: hasDate ? AppColors.primaryLite : const Color(0xFFFFFAEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.calendar_1,
              size: 18,
              color: hasDate ? AppColors.primary : const Color(0xFFF79009),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jour de visite',
                  style: TextStyle(fontSize: 11, color: _textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  hasDate
                      ? VisitUtils.formatDateTime(_visitData!
                          .datesDemandeVisite.last.date!
                          .toIso8601String())
                      : 'Aucune date programmée',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: hasDate ? AppColors.primary : const Color(0xFFB54708),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Actions détaillées (itinéraire, propriétaire, service client) ──────────
  Widget _buildDetailActions() {
    return Column(
      children: [
        // Itinéraire
        _buildActionTile(
          icon: Iconsax.location,
          title: "Voir l'itinéraire",
          subtitle: "Ouvrir dans Maps",
          onTap: _openMaps,
        ),
        const SizedBox(height: 8),

        // Propriétaire (conditionnel)
        if (_shouldShowOwnerPhone && _visitData?.proprietaire != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildActionTile(
              icon: Iconsax.user,
              title: "Propriétaire",
              subtitle:
                  _visitData!.proprietaire!.phoneNumber.split('-').last,
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.call,
                    size: 18, color: Color(0xFF12B76A)),
              ),
              onTap: () {
                final phone =
                    _visitData!.proprietaire!.phoneNumber.split('-');
                Utils.makePhoneCall(phone.last);
              },
            ),
          ),

        // Service client
        _buildActionTile(
          icon: Iconsax.headphone,
          title: "Service client",
          subtitle: "Besoin d'aide ?",
          onTap: () => ContactUtils.showContact(id: widget.visitId),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF2F4F7)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(Iconsax.arrow_right_3,
                    size: 18, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }

  // ── Ouvrir Maps ────────────────────────────────────────────────────────────
  Future<void> _openMaps() async {
    final bienImmo = widget.bienImmo;
    if (bienImmo.position.coordinates == null ||
        bienImmo.position.coordinates!.length < 2) {
      EasyLoading.showToast('Position non disponible');
      return;
    }

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
      if (availableMaps.isNotEmpty) {
        await availableMaps.first.showDirections(
          destinationTitle: bienImmo.nom,
          destination: destination,
          directionsMode: DirectionsMode.driving,
        );
      }
    }
  }
}
