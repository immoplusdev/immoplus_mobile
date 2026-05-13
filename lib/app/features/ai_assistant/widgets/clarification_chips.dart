import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../models/chat_clarification.dart';
import 'chat_tokens.dart';

/// ClarificationBlock (spec §10).
class ClarificationBlock extends StatefulWidget {
  const ClarificationBlock({
    super.key,
    required this.clarification,
    required this.onSend,
    this.quickReplies = const [],
  });

  final ChatClarification clarification;
  final void Function(String text) onSend;
  final List<String> quickReplies;

  @override
  State<ClarificationBlock> createState() => _ClarificationBlockState();
}

class _ClarificationBlockState extends State<ClarificationBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _enter.forward();
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _handleTap(String value) {
    HapticFeedback.lightImpact();
    setState(() => _dismissed = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      widget.onSend(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final understood = widget.clarification.partialChips;
    final options = _optionsFor(widget.clarification.askedField);
    if (understood.isEmpty && options.isEmpty) return const SizedBox.shrink();

    final totalSteps =
        understood.length + widget.clarification.missingFields.length;
    final doneSteps = understood.length;

    final fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
    final slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(fade);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: _dismissed
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: ChatTokens.s10),
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ChatTokens.neutral0,
                      borderRadius: BorderRadius.circular(ChatTokens.cardRadius),
                      border: Border.all(
                        color: ChatTokens.borderStandard,
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (totalSteps > 1) ...[
                          _ProgressIndicator(done: doneSteps, total: totalSteps),
                          const SizedBox(height: 12),
                        ],
                        if (understood.isNotEmpty) ...[
                          const _SectionLabel(
                            icon: Iconsax.tick_circle,
                            label: 'Compris',
                            color: ChatTokens.success500,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: understood
                                .map((c) => _ReadOnlyChip(label: c))
                                .toList(),
                          ),
                          if (options.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: ChatTokens.divider,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                        if (options.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: options
                                .map((o) => ChoiceChip(
                                      label: o.label,
                                      onTap: () => _handleTap(o.value),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  List<_ChipOption> _optionsFor(String? askedField) {
    if (widget.quickReplies.isNotEmpty) {
      return widget.quickReplies
          .map((value) => _ChipOption(value, value))
          .toList(growable: false);
    }

    switch (askedField?.toLowerCase()) {
      case 'transaction_type':
      case 'transactiontype':
        return const [
          _ChipOption('Acheter', 'Acheter'),
          _ChipOption('Louer', 'Louer'),
          _ChipOption('Réserver', 'Réserver'),
        ];
      case 'property_type':
      case 'propertytype':
        return const [
          _ChipOption('Appart', 'Appartement'),
          _ChipOption('Villa', 'Villa'),
          _ChipOption('Maison', 'Maison'),
          _ChipOption('Studio', 'Studio'),
          _ChipOption('Duplex', 'Duplex'),
          _ChipOption('Bureau', 'Bureau'),
          _ChipOption('Terrain', 'Terrain'),
        ];
      case 'rooms_min':
      case 'roomsmin':
      case 'rooms':
        return const [
          _ChipOption('1 pièce', '1 pièce'),
          _ChipOption('2 pièces', '2 pièces'),
          _ChipOption('3 pièces', '3 pièces'),
          _ChipOption('4 pièces', '4 pièces'),
          _ChipOption('5+ pièces', '5 pièces ou plus'),
        ];
      case 'extras':
        return const [
          _ChipOption('Piscine', 'Avec piscine'),
          _ChipOption('Parking', 'Avec parking'),
          _ChipOption('Meublé', 'Meublé'),
          _ChipOption('Sécurité', 'Avec sécurité'),
          _ChipOption('Climatisation', 'Avec climatisation'),
        ];
      case 'location':
        return const [
          _ChipOption('Cocody', 'Cocody'),
          _ChipOption('Plateau', 'Plateau'),
          _ChipOption('Yopougon', 'Yopougon'),
          _ChipOption('Marcory', 'Marcory'),
          _ChipOption('Bingerville', 'Bingerville'),
          _ChipOption('Abobo', 'Abobo'),
        ];
      case 'price_max':
      case 'pricemax':
        return const [
          _ChipOption('300k F', '300 000 FCFA'),
          _ChipOption('500k F', '500 000 FCFA'),
          _ChipOption('1M F', '1 000 000 FCFA'),
          _ChipOption('2M F', '2 000 000 FCFA'),
          _ChipOption('Pas de limite', 'Pas de limite'),
        ];
      case 'surface_min':
      case 'surfacemin':
        return const [
          _ChipOption('30 m²', '30 m²'),
          _ChipOption('50 m²', '50 m²'),
          _ChipOption('70 m²', '70 m²'),
          _ChipOption('100 m²', '100 m²'),
          _ChipOption('150 m²', '150 m²'),
        ];
      default:
        return const [];
    }
  }
}

class _ChipOption {
  const _ChipOption(this.label, this.value);
  final String label;
  final String value;
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            width: i < done ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i < done ? ChatTokens.success500 : ChatTokens.neutral200,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
        const SizedBox(width: 8),
        Text(
          '$done/$total critères',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ChatTokens.neutral400,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyChip extends StatelessWidget {
  const _ReadOnlyChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ChatTokens.neutral100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ChatTokens.readOnlyChipText,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

/// Chip de choix (spec §10 / §11) — réutilisable.
class ChoiceChip extends StatelessWidget {
  const ChoiceChip({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: ChatTokens.brandSurface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ChatTokens.brandBorder20, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ChatTokens.brand500,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chips de reformulation après une erreur (spec §11) — stagger 80ms.
class ErrorReformulationChips extends StatefulWidget {
  const ErrorReformulationChips({super.key, required this.onSend});

  final void Function(String text) onSend;

  static const List<String> _suggestions = [
    'Je cherche un appart',
    'Combien vaut un bien à Cocody ?',
    'Conseil marché',
  ];

  @override
  State<ErrorReformulationChips> createState() =>
      _ErrorReformulationChipsState();
}

class _ErrorReformulationChipsState extends State<ErrorReformulationChips> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < ErrorReformulationChips._suggestions.length; i++)
          _StaggeredChip(
            delay: Duration(milliseconds: 80 * i),
            child: ChoiceChip(
              label: ErrorReformulationChips._suggestions[i],
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onSend(ErrorReformulationChips._suggestions[i]);
              },
            ),
          ),
      ],
    );
  }
}

class _StaggeredChip extends StatefulWidget {
  const _StaggeredChip({required this.child, required this.delay});
  final Widget child;
  final Duration delay;

  @override
  State<_StaggeredChip> createState() => _StaggeredChipState();
}

class _StaggeredChipState extends State<_StaggeredChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
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
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(fade);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: widget.child),
    );
  }
}
