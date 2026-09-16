import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/features/suggest/widgets/selection_countdown.dart';
import 'package:immoplus/app/widgets/ads/components/ad_tap.dart';

/// Pub "offre flash" : fond illustré + titre + compte à rebours jusqu'à
/// `campaign.endDate`. Pas de valeur backend dédiée au fond — on alterne
/// entre les 2 assets `bleu`/`rose` selon la parité de `campaign.id`, pour
/// varier visuellement sans champ supplémentaire côté API.
class AdFlashOfferWidget extends StatelessWidget {
  final AdCampaignModel campaign;

  const AdFlashOfferWidget({super.key, required this.campaign});

  static const double _height = 113;

  String get _background => campaign.id.isEven
      ? 'assets/img/pubs/bleu.png'
      : 'assets/img/pubs/rose.png';

  @override
  Widget build(BuildContext context) {
    final endDate = campaign.endDate;
    if (endDate == null || endDate.isBefore(DateTime.now())) {
      return const SizedBox.shrink();
    }

    final badge = campaign.content.badge;
    final title = campaign.content.title;

    return AdTap(
      campaign: campaign,
      child: Container(
        height: _height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(_background),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge?.isNotEmpty == true)
                Text(
                  badge!,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              if (title?.isNotEmpty == true) ...[
                const Gap(4),
                Text(
                  title!,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Gap(10),
              SelectionCountdown(
                expireAt: endDate,
                builder: (context, remaining, expired) {
                  if (expired) return const SizedBox.shrink();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CountdownPill(
                        value: remaining.inHours,
                        suffix: 'h',
                      ),
                      const Gap(6),
                      _CountdownPill(
                        value: remaining.inMinutes.remainder(60),
                        suffix: 'm',
                      ),
                      const Gap(6),
                      _CountdownPill(
                        value: remaining.inSeconds.remainder(60),
                        suffix: 's',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownPill extends StatelessWidget {
  final int value;
  final String suffix;

  const _CountdownPill({required this.value, required this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${value.toString().padLeft(2, '0')}$suffix',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
