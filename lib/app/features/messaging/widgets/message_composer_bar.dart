import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';

/// Composer bas d'écran du fil (spec §5.8) : champ extensible + bouton
/// d'envoi, désactivé tant que le champ est vide.
class MessageComposerBar extends StatefulWidget {
  const MessageComposerBar({
    super.key,
    required this.onChanged,
    required this.onSend,
    required this.onOpenActions,
    this.topAccessory,
  });

  final ValueChanged<String> onChanged;
  final Future<bool> Function(String) onSend;
  final VoidCallback onOpenActions;
  final Widget? topAccessory;

  @override
  State<MessageComposerBar> createState() => _MessageComposerBarState();
}

class _MessageComposerBarState extends State<MessageComposerBar> {
  static const _maxLength = 2000;
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final sent = await widget.onSend(text);
    if (!mounted || !sent) return;
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            alignment: Alignment.bottomCenter,
            child: widget.topAccessory == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: widget.topAccessory,
                  ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: AppColors.immoBgSurfaceMuted,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: widget.onOpenActions,
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Iconsax.add,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: _maxLength,
                    buildCounter: (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) =>
                        currentLength > 1800
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 2),
                                child: Text(
                                  '$currentLength/$maxLength',
                                  style: AppTypography.font(
                                    fontSize: 10,
                                    color: currentLength >= _maxLength
                                        ? AppColors.immoFeedbackError
                                        : AppColors.immoTextSecondary,
                                  ),
                                ),
                              )
                            : null,
                    textCapitalization: TextCapitalization.sentences,
                    style: AppTypography.font(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Écrire un message…',
                      hintStyle: AppTypography.font(
                        color: AppColors.immoTextDisabled,
                      ),
                      filled: true,
                      fillColor: AppColors.immoBgSurfaceMuted,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      widget.onChanged(value);
                      final hasText = value.trim().isNotEmpty;
                      if (hasText != _hasText) {
                        setState(() => _hasText = hasText);
                      }
                    },
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedScale(
                scale: _hasText ? 1 : .94,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _hasText
                        ? AppColors.primary
                        : AppColors.immoBgSurfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: _hasText ? _send : null,
                    icon: Icon(
                      Iconsax.send_2,
                      color: _hasText
                          ? AppColors.white
                          : AppColors.immoBorderStrong,
                    ),
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
