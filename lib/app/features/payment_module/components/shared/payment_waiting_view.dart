import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class PaymentWaitingView extends StatelessWidget {
  const PaymentWaitingView({
    super.key,
    this.onBack,
    this.operatorLogo,
    this.loaderColor,
    this.instructionMarkdown,
    this.actionButtonText,
    this.onActionTap,
    this.actionIcon,
    this.isWaveStyle = false,
    this.infoMessage,
    this.extraWidget,
  });

  final VoidCallback? onBack;
  final String? operatorLogo;
  final Color? loaderColor;
  final String? instructionMarkdown;
  final String? actionButtonText;
  final VoidCallback? onActionTap;
  final Widget? actionIcon;
  final bool isWaveStyle;
  final String? infoMessage;
  final Widget? extraWidget;

  @override
  Widget build(BuildContext context) {
    final logo = operatorLogo ?? OrderPaymentController.selectedOperator.logo;
    final color = loaderColor ?? AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── BOUTON RETOUR (SI FOURNI) ──
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.chevron_back,
                color: Colors.black,
              ),
              onPressed: onBack,
            ),
          ),

        // ── AVATAR OPÉRATEUR AVEC LOADER CIRCULAIRE ──
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                foregroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
              ),
              Transform.scale(
                scale: 2.5,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),

        const Gap(16),

        // ── INSTRUCTIONS MARKDOWN ──
        if (instructionMarkdown != null && instructionMarkdown!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 70,
              child: Markdown(
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  textAlign: WrapAlignment.center,
                ),
                selectable: true,
                data: instructionMarkdown!,
              ),
            ),
          ),

        // ── BOUTON D'ACTION (WAVE OU USSD) ──
        if (actionButtonText != null && onActionTap != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isWaveStyle
                ? ListTile(
                    onTap: onActionTap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: AppColors.primary,
                    leading: actionIcon ??
                        const Icon(
                          Icons.phone_android,
                          color: Colors.white,
                        ),
                    title: Text(actionButtonText!),
                    titleTextStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Colors.white,
                    ),
                  )
                : CustomButtom(
                    elevation: 2,
                    color: Colors.white,
                    text: actionButtonText!,
                    textColor: Colors.black,
                    onClick: onActionTap!,
                  ),
          ),
          const Gap(12),
        ],

        // ── WIDGET EXTRA ÉVENTUEL ──
        if (extraWidget != null) extraWidget!,

        // ── MESSAGE D'INFORMATION D'ATTENTE ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            infoMessage ??
                "Une fois le paiement validé, veuillez patienter quelques instants. "
                    "Vous serez notifié du statut de votre paiement, puis celui de votre demande par ImmoPlus.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
        ),

        const Gap(10),
        Gap(MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}
