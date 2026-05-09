import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'chat_tokens.dart';

/// Composer du chat — aligné sur le hero composer de l'EmptyState.
/// Pilule transparente, bordure 0.8px, icône `message_edit` à gauche,
/// bouton envoi à droite. Pas de bouton `+`, pas de micro.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    required this.isStreaming,
    this.hint,
  });

  final void Function(String text) onSend;
  final bool isStreaming;
  /// Hint contextuel — null affiche le placeholder par défaut.
  final String? hint;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
  }

  void _onChange() {
    final has = _controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isStreaming) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.mediumImpact();
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _hasText && !widget.isStreaming;

    return SafeArea(
      top: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            height: 20,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ChatTokens.s12,
              ChatTokens.s8,
              ChatTokens.s12,
              ChatTokens.s12,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 54),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(ChatTokens.inputRadius),
                border: Border.all(
                  color: ChatTokens.borderStandard,
                  width: 0.8,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.message_edit,
                    size: 18,
                    color: ChatTokens.placeholder,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: ChatTokens.brand500,
                      cursorWidth: 1.6,
                      cursorRadius: const Radius.circular(1),
                      style: const TextStyle(
                        fontSize: 14,
                        color: ChatTokens.neutral900,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hint ?? 'Demande quoi que ce soit sur l\'immo…',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: ChatTokens.placeholder,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        isCollapsed: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: widget.isStreaming
                        ? _PrimaryButton(
                            key: const ValueKey('stop'),
                            icon: Iconsax.stop,
                            iconSize: 16,
                            background: ChatTokens.neutral900,
                            onTap: () => HapticFeedback.mediumImpact(),
                          )
                        : _PrimaryButton(
                            key: const ValueKey('send'),
                            icon: Iconsax.arrow_up_3,
                            iconSize: 18,
                            background: canSend
                                ? ChatTokens.brand500
                                : ChatTokens.brand500.withValues(alpha: 0.35),
                            onTap: canSend ? _submit : null,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final Color background;
  final VoidCallback? onTap;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = false),
      onTapCancel:
          widget.onTap == null ? null : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.background,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, size: widget.iconSize, color: Colors.white),
        ),
      ),
    );
  }
}
