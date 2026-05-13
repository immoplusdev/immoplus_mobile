import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/chat_action.dart';
import 'chat_tokens.dart';

class ChatResponseActions extends StatefulWidget {
  const ChatResponseActions({
    super.key,
    required this.quickReplies,
    required this.actions,
    this.onQuickReplyTap,
    this.onActionTap,
  });

  final List<String> quickReplies;
  final List<ChatActionModel> actions;
  final void Function(String text)? onQuickReplyTap;
  final void Function(ChatActionModel action)? onActionTap;

  @override
  State<ChatResponseActions> createState() => _ChatResponseActionsState();
}

class _ChatResponseActionsState extends State<ChatResponseActions> {
  bool _used = false;

  @override
  Widget build(BuildContext context) {
    if (widget.quickReplies.isEmpty && widget.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: _used ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.only(top: ChatTokens.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.actions.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.actions
                    .map(
                      (action) => _ActionButton(
                        action: action,
                        onTap: _used || widget.onActionTap == null
                            ? null
                            : () {
                                setState(() => _used = true);
                                widget.onActionTap!(action);
                              },
                      ),
                    )
                    .toList(),
              ),
            if (widget.actions.isNotEmpty && widget.quickReplies.isNotEmpty)
              const SizedBox(height: ChatTokens.s10),
            if (widget.quickReplies.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.quickReplies
                    .map(
                      (reply) => _QuickReplyChip(
                        label: reply,
                        onTap: _used || widget.onQuickReplyTap == null
                            ? null
                            : () {
                                setState(() => _used = true);
                                widget.onQuickReplyTap!(reply);
                              },
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    this.onTap,
  });

  final ChatActionModel action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(action);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap!();
              },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: colors.border, width: 0.8),
          ),
          child: Text(
            action.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }

  _ActionColors _colorsFor(ChatActionModel action) {
    if (action.isPrimary) {
      return const _ActionColors(
        background: ChatTokens.brand500,
        foreground: ChatTokens.neutral0,
        border: ChatTokens.brand500,
      );
    }
    if (action.isTertiary) {
      return const _ActionColors(
        background: ChatTokens.neutral0,
        foreground: ChatTokens.neutral400,
        border: ChatTokens.borderStandard,
      );
    }
    return _ActionColors(
      background: ChatTokens.brandSurface,
      foreground: ChatTokens.brand500,
      border: ChatTokens.brandBorder15,
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  const _QuickReplyChip({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: ChatTokens.neutral0,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ChatTokens.borderStandard, width: 0.8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ChatTokens.neutral700,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionColors {
  const _ActionColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
