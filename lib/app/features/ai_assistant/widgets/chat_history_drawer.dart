import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../models/conversation_summary.dart';
import '../services/chat_history_service.dart';
import 'chat_tokens.dart';

/// Vue historique plein-écran (Option B — view switch).
/// Pas de Drawer wrapper — c'est un widget normal qui remplace le chat.
class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({
    super.key,
    required this.service,
    required this.currentSessionId,
    required this.onSessionSelected,
    required this.onNewConversation,
  });

  final ChatHistoryService service;
  final String? currentSessionId;
  final ValueChanged<String> onSessionSelected;
  final VoidCallback onNewConversation;

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  List<ConversationSummary> _conversations = [];
  bool _loading = true;
  bool _deleting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await widget.service.getConversations(limit: 50);
      if (mounted) setState(() => _conversations = list);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Impossible de charger l\'historique');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      await widget.service.deleteSession(sessionId);
      setState(
          () => _conversations.removeWhere((c) => c.sessionId == sessionId));
      if (sessionId == widget.currentSessionId) {
        widget.onNewConversation();
      }
    } catch (_) {}
  }

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Supprimer tout ?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: ChatTokens.neutral900,
          ),
        ),
        content: const Text(
          'Toutes tes conversations seront supprimées définitivement.',
          style: TextStyle(fontSize: 14, color: ChatTokens.neutral400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler',
                style: TextStyle(color: ChatTokens.neutral400)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer',
                style: TextStyle(color: ChatTokens.danger500)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    try {
      await widget.service.deleteAllHistory();
      setState(() => _conversations = []);
      widget.onNewConversation();
    } catch (_) {
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  // ─── Groupement par date ──────────────────────────────────────────────────

  Map<String, List<ConversationSummary>> _grouped() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const order = ["Aujourd'hui", 'Hier', 'Cette semaine', 'Plus tôt'];
    final groups = {for (final l in order) l: <ConversationSummary>[]};

    for (final c in _conversations) {
      final d = DateTime(
          c.lastMessageAt.year, c.lastMessageAt.month, c.lastMessageAt.day);
      final diff = today.difference(d).inDays;
      final label = switch (diff) {
        0 => "Aujourd'hui",
        1 => 'Hier',
        _ when diff <= 7 => 'Cette semaine',
        _ => 'Plus tôt',
      };
      groups[label]!.add(c);
    }

    groups.removeWhere((_, v) => v.isEmpty);
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final showHeader = !_loading && _error == null && _conversations.isNotEmpty;
    return ColoredBox(
      color: ChatTokens.neutral0,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showHeader)
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  ChatTokens.s16,
                  ChatTokens.s4,
                  ChatTokens.s16,
                  ChatTokens.s8,
                ),
                child: Text(
                  'Récents',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: ChatTokens.neutral900,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            Expanded(child: _buildBody()),
            if (_conversations.isNotEmpty) _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: ChatTokens.brand500,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.warning_2,
                color: ChatTokens.neutral400, size: 32),
            const SizedBox(height: ChatTokens.s8),
            Text(_error!,
                style: const TextStyle(
                    fontSize: 14, color: ChatTokens.neutral400)),
            const SizedBox(height: ChatTokens.s16),
            TextButton(
              onPressed: _load,
              child: const Text('Réessayer',
                  style: TextStyle(color: ChatTokens.brand500)),
            ),
          ],
        ),
      );
    }

    if (_conversations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.message, color: ChatTokens.neutral200, size: 40),
            SizedBox(height: ChatTokens.s12),
            Text(
              'Aucune conversation',
              style: TextStyle(
                  fontSize: 15,
                  color: ChatTokens.neutral400,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: ChatTokens.s4),
            Text(
              'Tes échanges avec Immo AI\napparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: ChatTokens.neutral400),
            ),
          ],
        ),
      );
    }

    final grouped = _grouped();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: ChatTokens.s8),
      itemCount:
          grouped.entries.fold<int>(0, (acc, e) => acc + 1 + e.value.length),
      itemBuilder: (context, index) {
        int cursor = 0;
        for (final entry in grouped.entries) {
          if (index == cursor) return _GroupHeader(label: entry.key);
          cursor++;
          for (final conv in entry.value) {
            if (index == cursor) {
              return _ConversationTile(
                conversation: conv,
                isActive: conv.sessionId == widget.currentSessionId,
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onSessionSelected(conv.sessionId);
                },
                onDelete: () => _deleteSession(conv.sessionId),
              );
            }
            cursor++;
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(height: 1, color: ChatTokens.divider),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ChatTokens.s8,
            vertical: ChatTokens.s4,
          ),
          child: _deleting
              ? const Padding(
                  padding: EdgeInsets.all(ChatTokens.s12),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: ChatTokens.danger500),
                )
              : TextButton.icon(
                  onPressed: _deleteAll,
                  icon: const Icon(Iconsax.trash,
                      size: 16, color: ChatTokens.danger500),
                  label: const Text(
                    'Tout supprimer',
                    style: TextStyle(
                        color: ChatTokens.danger500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─── Widgets internes ─────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ChatTokens.s16,
        ChatTokens.s16,
        ChatTokens.s16,
        ChatTokens.s4,
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: ChatTokens.neutral400,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  final ConversationSummary conversation;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(conversation.sessionId),
      direction: DismissDirection.endToStart,
      background: _SwipeBackground(),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ChatTokens.s12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(
              horizontal: ChatTokens.s8, vertical: 2),
          padding: const EdgeInsets.symmetric(
              horizontal: ChatTokens.s12, vertical: ChatTokens.s10),
          decoration: BoxDecoration(
            color: isActive ? ChatTokens.brandSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(ChatTokens.s12),
            border: isActive
                ? Border.all(color: ChatTokens.brandBorder15, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: ChatTokens.neutral900,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(conversation.lastMessageAt),
                      style: const TextStyle(
                          fontSize: 12, color: ChatTokens.neutral400),
                    ),
                  ],
                ),
              ),
              if (isActive)
                const Padding(
                  padding: EdgeInsets.only(left: ChatTokens.s8),
                  child: Icon(Iconsax.message_text,
                      size: 14, color: ChatTokens.brand500),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    if (diff == 1) return 'Hier';
    const months = [
      '',
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'juin',
      'juil',
      'août',
      'sep',
      'oct',
      'nov',
      'déc',
    ];
    return '${date.day} ${months[date.month]}';
  }
}

class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin:
          const EdgeInsets.symmetric(horizontal: ChatTokens.s8, vertical: 2),
      padding: const EdgeInsets.only(right: ChatTokens.s16),
      decoration: BoxDecoration(
        color: ChatTokens.dangerSurface,
        borderRadius: BorderRadius.circular(ChatTokens.s12),
      ),
      child: const Icon(Iconsax.trash, color: ChatTokens.danger500, size: 20),
    );
  }
}
