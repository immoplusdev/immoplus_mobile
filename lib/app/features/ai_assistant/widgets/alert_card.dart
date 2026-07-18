import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../models/chat_alert_payload.dart';
import 'chat_tokens.dart';
import 'property_mini_card.dart';

enum AlertCardVariant { created, updated, results }

/// AlertCard (spec §8) — animation slide up 300ms + fade post stream.
class AlertCard extends StatefulWidget {
  const AlertCard({
    super.key,
    required this.payload,
    this.variant = AlertCardVariant.created,
    this.onSeeAll,
    this.onManage,
    this.onPropertyTap,
    this.onNavigateToPropositions,
    this.maxInline = 3,
  });

  final ChatAlertPayload payload;
  final AlertCardVariant variant;
  final VoidCallback? onSeeAll;
  final VoidCallback? onManage;
  final void Function(String propertyId, String entityType)? onPropertyTap;
  final void Function(String alertId)? onNavigateToPropositions;
  final int maxInline;

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _enter.forward();
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _handleSeeAll() {
    HapticFeedback.lightImpact();
    widget.onSeeAll?.call();
  }

  void _handleManage() {
    HapticFeedback.lightImpact();
    widget.onManage?.call();
  }

  @override
  Widget build(BuildContext context) {
    final chips = widget.payload.criteriaChips;
    final matches = widget.payload.matches;
    final inline = matches.take(widget.maxInline).toList(growable: false);
    final extra =
        (widget.payload.totalMatches ?? matches.length) - inline.length;

    final fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    final slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(fade);

    return Padding(
      padding: const EdgeInsets.only(top: ChatTokens.s12),
      child: FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: Container(
            decoration: BoxDecoration(
              color: ChatTokens.neutral0,
              borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
              border: Border.all(color: ChatTokens.borderStandard, width: 0.5),
              boxShadow: ChatTokens.cardShadow,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(
                  variant: widget.variant,
                  chips: chips,
                  onManage: _handleManage,
                ),
                if (inline.isEmpty)
                  const _EmptyMatches()
                else ...[
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: ChatTokens.divider,
                  ),
                  for (var i = 0; i < inline.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: ChatTokens.divider,
                      ),
                    _StaggerIn(
                      delay: Duration(milliseconds: 60 * i),
                      child: PropertyMiniCard(
                        property: inline[i],
                        onTap: widget.onPropertyTap == null
                            ? null
                            : () => widget.onPropertyTap!(
                                  inline[i].id,
                                  inline[i].entityType ?? 'BIEN_IMMOBILIER',
                                ),
                      ),
                    ),
                  ],
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: ChatTokens.divider,
                  ),
                  _Footer(
                    extraCount: extra > 0 ? extra : 0,
                    alertId: widget.payload.alertId,
                    onNavigateToPropositions: widget.onNavigateToPropositions,
                    onSeeAll: _handleSeeAll,
                    onManage: _handleManage,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.variant,
    required this.chips,
    required this.onManage,
  });

  final AlertCardVariant variant;
  final List<String> chips;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (variant) {
      AlertCardVariant.created => (Iconsax.notification_bing, 'Alerte active'),
      AlertCardVariant.updated => (Iconsax.refresh, 'Alerte mise à jour'),
      AlertCardVariant.results => (Iconsax.search_normal, 'Résultats trouvés'),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: ChatTokens.brand500),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ChatTokens.neutral900,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              InkWell(
                onTap: onManage,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Iconsax.more,
                    size: 18,
                    color: ChatTokens.neutral400,
                  ),
                ),
              ),
            ],
          ),
          if (chips.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 6, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: chips.map((c) => _CriteriaChip(label: c)).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CriteriaChip extends StatelessWidget {
  const _CriteriaChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ChatTokens.brandSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ChatTokens.brand500,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _EmptyMatches extends StatelessWidget {
  const _EmptyMatches();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: ChatTokens.s24, horizontal: 14),
      child: Column(
        children: [
          Icon(Iconsax.search_status, size: 32, color: ChatTokens.skeleton),
          SizedBox(height: 10),
          Text(
            'Aucun bien ne matche pour le moment.\nJe te notifie dès qu\'un apparaît.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: ChatTokens.neutral400,
              height: 1.45,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.extraCount,
    required this.onSeeAll,
    required this.onManage,
    this.alertId,
    this.onNavigateToPropositions,
  });

  final int extraCount;
  final VoidCallback onSeeAll;
  final VoidCallback onManage;
  final String? alertId;
  final void Function(String alertId)? onNavigateToPropositions;

  void _handleSeeAll() {
    HapticFeedback.lightImpact();
    final id = alertId;
    if (id != null && onNavigateToPropositions != null) {
      onNavigateToPropositions!(id);
    } else {
      onSeeAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleSeeAll,
              child: Text(
                extraCount > 0
                    ? 'Voir tous les matches ($extraCount)'
                    : 'Voir les matches',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ChatTokens.brand500,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onManage,
            child: const Text(
              'Gérer l\'alerte',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ChatTokens.neutral400,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper : entrée fade + slide-left avec délai (pour stagger des mini-cards).
class _StaggerIn extends StatefulWidget {
  const _StaggerIn({required this.child, required this.delay});
  final Widget child;
  final Duration delay;

  @override
  State<_StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<_StaggerIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(-0.04, 0),
      end: Offset.zero,
    ).animate(fade);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: widget.child),
    );
  }
}
