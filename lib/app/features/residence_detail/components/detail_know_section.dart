import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';

/// "À savoir" section with 3 info blocks matching Airbnb's layout:
/// • Règlement intérieur
/// • Sécurité et logement
/// • Conditions d'annulation
class DetailKnowSection extends StatelessWidget {
  const DetailKnowSection({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // ── Règlement intérieur ──
          _KnowCard(
            icon: Iconsax.document_text,
            title: 'Règlement intérieur',
            items: [
              if (residenceModel.heureEntree.isNotEmpty)
                'Arrivée à partir de ${residenceModel.heureEntree}',
              if (residenceModel.heureDepart.isNotEmpty)
                'Départ avant ${residenceModel.heureDepart}',
              if (residenceModel.nombreMaxOccupants > 0)
                '${residenceModel.nombreMaxOccupants} voyageurs maximum',
            ],
            onTap: () => _showRulesSheet(context),
          ),

          Divider(
              height: 32, thickness: 0.5, color: AppColors.immoBorderDefault),

          // ── Sécurité et logement ──
          _KnowCard(
            icon: Iconsax.shield_tick,
            title: 'Sécurité et logement',
            items: [
              if (!residenceModel.animauxAutorises) 'Animaux non autorisés',
              if (!residenceModel.fetesAutorises) 'Fêtes non autorisées',
              'Éviter les nuisances sonores',
            ],
          ),

          Divider(
              height: 32, thickness: 0.5, color: AppColors.immoBorderDefault),

          // ── Conditions d'annulation ──
          _KnowCard(
            icon: Iconsax.security,
            title: "Consignes de salubrité",
            items: const [
              'Maintenir les lieux propres',
              'Respecter les équipements et le mobilier',
              'Laisser la résidence dans un état acceptable à votre départ',
            ],
          ),
        ]),
      ),
    );
  }

  void _showRulesSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Règlement intérieur',
                style: AppTypography.font(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.immoTextPrimary,
                ),
              ),
              SizedBox(height: 24),
              _RuleRow(
                icon: Iconsax.clock,
                text: "Arrivée à partir de ${residenceModel.heureEntree}",
              ),
              _RuleRow(
                icon: Iconsax.clock,
                text: 'Départ avant ${residenceModel.heureDepart}',
              ),
              if (residenceModel.nombreMaxOccupants > 0)
                _RuleRow(
                  icon: Iconsax.people,
                  text:
                      '${residenceModel.nombreMaxOccupants} voyageurs maximum',
                ),
              if (!residenceModel.animauxAutorises)
                const _RuleRow(
                  icon: Iconsax.pet,
                  text: 'Animaux non autorisés',
                ),
              if (!residenceModel.fetesAutorises)
                const _RuleRow(
                  icon: Iconsax.music,
                  text: 'Fêtes non autorisées',
                ),
              const _RuleRow(
                icon: Iconsax.volume_slash,
                text: 'Éviter les nuisances sonores',
              ),
              if (residenceModel.reglesSupplementaires.isNotEmpty) ...[
                Divider(
                    height: 32,
                    thickness: 0.5,
                    color: AppColors.immoBorderDefault),
                Text(
                  'Règles supplémentaires',
                  style: AppTypography.font(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.immoTextPrimary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  residenceModel.reglesSupplementaires,
                  style: AppTypography.font(
                    fontSize: 15,
                    color: AppColors.immoTextSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Know Card ──────────────────────────────────────────────────────────────
class _KnowCard extends StatelessWidget {
  const _KnowCard({
    required this.icon,
    required this.title,
    required this.items,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final List<String> items;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.immoBrandPrimary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: AppColors.immoBrandPrimary),
          ),
          SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.font(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.immoTextPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                ...items.take(3).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          item,
                          style: AppTypography.font(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.immoTextSecondary,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          // Arrow
          if (onTap != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Iconsax.arrow_right_3,
                size: 18,
                color: AppColors.immoTextDisabled,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Rule Row (for bottom sheet) ────────────────────────────────────────────
class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.immoTextLabel),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: AppTypography.font(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.immoTextPrimary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
