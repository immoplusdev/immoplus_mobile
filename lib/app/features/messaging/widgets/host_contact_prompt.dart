import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class HostContactPrompt extends StatelessWidget {
  const HostContactPrompt({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryLite,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.font(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLite,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Pour protéger votre paiement, échangez toujours avec l’hôte et effectuez vos paiements sur ImmoPlus.',
                  style: AppTypography.font(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.immoTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
