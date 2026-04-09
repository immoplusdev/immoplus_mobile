import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';

/// "À savoir" section for estate with 3 info blocks matching residence layout.
class DetailEstateKnowSection extends StatelessWidget {
  const DetailEstateKnowSection({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: appPadding),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // ── Planification de visite ──
          _KnowCard(
            icon: Iconsax.calendar,
            title: 'Planification de visite',
            items: [
              bienImmobilier.aLouer
                  ? 'Disponible à la location'
                  : 'Disponible à l\'achat',
              // if ((bienImmobilier.nombreMaxOccupants ?? 0) > 0)
              //   '${bienImmobilier.nombreMaxOccupants} occupants maximum',
              'Contactez l\'agent pour planifier une visite',
            ],
          ),

          Divider(height: 32, thickness: 0.5, color: Colors.grey.shade200),

          // ── Informations légales ──
          const _KnowCard(
            icon: Iconsax.verify,
            title: 'Propriété certifiée',
            items: [
              'Bien vérifié et conforme',
'Agence certifiée et fiable',
            ],
          ),

          Divider(height: 32, thickness: 0.5, color: Colors.grey.shade200),

          // ── Contact agent ──
          // const _KnowCard(
          //   icon: Iconsax.call,
          //   title: 'Contact agent',
          //   items: [
          //     'Réponse rapide sous 24h',
          //     'Visite sur rendez-vous uniquement',
          //   ],
          // ),
        ]),
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
  });
  final IconData icon;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 22, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              ...items.take(3).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
