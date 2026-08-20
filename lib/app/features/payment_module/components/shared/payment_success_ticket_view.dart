import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/payment_module/components/shared/ticket_clipper.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/circle_button.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_button_secondary.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

class PaymentSuccessTicketView extends StatefulWidget {
  const PaymentSuccessTicketView({
    super.key,
    required this.paymentData,
    required this.paymentIntentData,
    this.phoneNumber,
  });

  final PaymentData paymentData;
  final PaymentItentData paymentIntentData;
  final String? phoneNumber;

  @override
  State<PaymentSuccessTicketView> createState() =>
      _PaymentSuccessTicketViewState();
}

class _PaymentSuccessTicketViewState extends State<PaymentSuccessTicketView>
    with SingleTickerProviderStateMixin {
  final GlobalKey _previewContainer = GlobalKey();
  bool _isExporting = false;
  bool _showConfetti = true;
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    final user = sessionManager.currentUser;

    // Calcul des valeurs à afficher
    final paymentId = widget.paymentIntentData.id;
    final displayPaymentId = paymentId.isNotEmpty
        ? (paymentId.length > 20 ? paymentId.substring(0, 20) : paymentId)
        : widget.paymentData.orderID;

    final amount = widget.paymentIntentData.amount;
    final formattedAmount = Utils.formatCurrency(amount);

    final date = widget.paymentIntentData.createdAt ?? DateTime.now();
    final formattedDate = DateFormat("d MMMM yyyy HH:mm", "fr_FR").format(date);

    final displayName = ((user?.firstName?.isNotEmpty == true ||
            user?.lastName?.isNotEmpty == true)
        ? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim()
        : OrderPaymentController.selectedOperator.name);

    final displayMasked = _maskPhoneNumber(widget.phoneNumber);

    final operatorLogo = OrderPaymentController.selectedOperator.logo;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── TICKET REÇU AVEC REPAINTBOUNDARY ──
              RepaintBoundary(
                key: _previewContainer,
                child: _buildTicketCard(
                  context: context,
                  displayPaymentId: displayPaymentId,
                  formattedAmount: formattedAmount,
                  formattedDate: formattedDate,
                  displayName: displayName,
                  displayMasked: displayMasked,
                  operatorLogo: operatorLogo,
                ),
              ),

              const Gap(24),

              // ── BOUTON DS : ALLER A L'ACCUEIL (SECONDAIRE AVEC BORDURES) ──
              CustomButtonSecondary(
                text: "Aller a l'accueil",
                onClick: () {
                  AppRouter.router.goNamed(HomePage.name);
                },
                color: AppColors.primary,
                textColor: AppColors.primary,
                backgroundColor: Colors.white,
                buttonHeight: 52,
                borderRadius: BorderRadius.circular(30),
              ),

              const Gap(14),

              // ── BOUTON DS : VOIR RESERVATION (PRIMAIRE PLEIN) ──
              CustomButtom(
                text: "Voir reservation",
                onClick: () {
                  AppRouter.router.go(
                    "/payment/${widget.paymentData.productType}/${widget.paymentData.orderID}",
                  );
                },
                color: AppColors.primary,
                textColor: Colors.white,
                buttonHeight: 52,
                borderRadius: BorderRadius.circular(30),
              ),

              const Gap(20),

              // ── ACTIONS SECONDAIRES DS : TÉLÉCHARGER & PARTAGER ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleButton(
                    icon: CupertinoIcons.arrow_down_to_line,
                    iconColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF1F5FD),
                    onTap: _isExporting
                        ? () {}
                        : () => _downloadScreenshot(displayPaymentId),
                  ),
                  const Gap(20),
                  CircleButton(
                    icon: CupertinoIcons.share,
                    iconColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF1F5FD),
                    onTap: _isExporting
                        ? () {}
                        : () => _shareScreenshot(
                              displayPaymentId,
                              formattedAmount,
                              formattedDate,
                            ),
                  ),
                ],
              ),

              const Gap(16),
            ],
          ),
        ),
        if (_showConfetti)
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/lotties/confetti.json',
                controller: _confettiController,
                repeat: false,
                fit: BoxFit.cover,
                onLoaded: (composition) {
                  _confettiController
                    ..duration = composition.duration
                    ..forward().then((_) {
                      if (mounted) {
                        setState(() => _showConfetti = false);
                      }
                    });
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _shareScreenshot(
    String paymentId,
    String amount,
    String date,
  ) async {
    try {
      setState(() => _isExporting = true);
      final fileName = "recu_paiement_$paymentId.jpg";
      final shareText = "Paiement ImmoPlus validé avec succès !\n"
          "Réf: $paymentId\n"
          "Montant: $amount\n"
          "Date: $date";

      await ShareFilesAndScreenshotWidgets().shareScreenshot(
        _previewContainer,
        800,
        "Details",
        fileName,
        "image/jpg",
        text: shareText,
      );
    } catch (e) {
      EasyLoading.showError("Impossible de partager le reçu");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _downloadScreenshot(String paymentId) async {
    try {
      setState(() => _isExporting = true);
      await ShareFilesAndScreenshotWidgets().takeScreenshot(
        _previewContainer,
        800,
      );
      EasyLoading.showSuccess("Reçu téléchargé avec succès");
    } catch (e) {
      EasyLoading.showError("Erreur lors du téléchargement");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  String _maskPhoneNumber(String? number, {int visibleDigits = 4}) {
    if (number == null || number.trim().isEmpty) return '....';
    final cleaned = number.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length <= visibleDigits) {
      return '.... $cleaned';
    }
    final lastDigits = cleaned.substring(cleaned.length - visibleDigits);
    return '.... $lastDigits';
  }

  Widget _buildTicketCard({
    required BuildContext context,
    required String displayPaymentId,
    required String formattedAmount,
    required String formattedDate,
    required String displayName,
    required String displayMasked,
    required String operatorLogo,
  }) {
    return TicketCardBackground(
      punchOffsetY: 118.0,
      borderColor: const Color(0xFFD6E2FB),
      borderWidth: 1.2,
      scallopCount: 7,
      scallopDepth: 9.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── EN-TÊTE : MERCI ! ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 16),
            child: Column(
              children: [
                const Text(
                  "Merci!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
                const Gap(6),
                const Text(
                  "Votre paiement a été traité\navec succès.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A94A6),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          // ── SÉPARATEUR EN POINTILLÉS (ALIGNE AVEC LES ENCOCHES) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildDottedLine(
              color: const Color(0xFFCBD5E1),
              dashWidth: 6,
              dashSpace: 5,
            ),
          ),

          // ── DÉTAILS DE LA TRANSACTION ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
            child: Column(
              children: [
                // Ligne 1 : Payement ID & Montant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: displayPaymentId),
                          );
                          EasyLoading.showSuccess("ID copié !");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Payement ID",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF8A94A6),
                                  ),
                                ),
                                const Gap(4),
                                const Icon(
                                  CupertinoIcons.doc_on_doc,
                                  size: 13,
                                  color: Color(0xFF8A94A6),
                                ),
                              ],
                            ),
                            const Gap(4),
                            Text(
                              displayPaymentId,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Montant",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8A94A6),
                          ),
                        ),
                        const Gap(4),
                        Text(
                          formattedAmount,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Gap(16),

                // Ligne 2 : Date & heure
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date & heure",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8A94A6),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(18),

                // ── BADGE MOYEN DE PAIEMENT / UTILISATEUR ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        foregroundImage: operatorLogo.isNotEmpty
                            ? NetworkImage(operatorLogo)
                            : null,
                        child: operatorLogo.isEmpty
                            ? const Icon(
                                CupertinoIcons.creditcard_fill,
                                size: 18,
                                color: Color(0xFF2B52F5),
                              )
                            : null,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              displayMasked,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── POINTILLÉS INFÉRIEURS ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildDottedLine(
              color: const Color(0xFFE2E8F0),
              dashWidth: 6,
              dashSpace: 5,
            ),
          ),

          // ── SIGNATURE / WATERMARK ──
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 36),
            child: Text(
              "@afriqsolus",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine({
    required Color color,
    double dashWidth = 5.0,
    double dashSpace = 4.0,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1.2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
