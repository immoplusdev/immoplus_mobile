import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/remote/messaging/message_model.dart';
import '../../../utils/app_colors.dart';
import '../utils/messaging_time_format.dart';

/// Bulle de message (spec §5.3/5.4) : à droite/primary pour le client, à
/// gauche/neutre pour le pro. Avatar affiché seulement sur la première
/// bulle d'un groupe consécutif (contrôlé par [showAvatar]).
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.showReadMarker,
    this.onRetry,
    this.onDelete,
  });

  final MessageModel message;
  final bool showAvatar;
  final bool showReadMarker;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isClient = message.isFromClient;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Padding(
      padding: EdgeInsets.only(
        left: isClient ? 48 : 16,
        right: isClient ? 16 : 48,
        top: 2,
        bottom: 2,
      ),
      child: Column(
        crossAxisAlignment:
            isClient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isClient) ...[
                SizedBox(
                  width: 28,
                  height: 28,
                  child: showAvatar
                      ? CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primaryLite,
                          child: Icon(Icons.person,
                              size: 16, color: AppColors.primary),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isClient ? AppColors.primary : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isClient ? 18 : 4),
                      bottomRight: Radius.circular(isClient ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      height: 1.4,
                      color: isClient ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isClient ? 0 : 36,
              right: isClient ? 0 : 0,
            ),
            child: _StatusRow(
              message: message,
              showReadMarker: showReadMarker,
              onRetry: onRetry,
              onDelete: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.message,
    required this.showReadMarker,
    this.onRetry,
    this.onDelete,
  });

  final MessageModel message;
  final bool showReadMarker;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isClient = message.isFromClient;
    final timeLabel = formatBubbleTime(message.createdAt);

    if (isClient && message.deliveryState == MessageDeliveryState.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 14, color: AppColors.redFF0000),
          const SizedBox(width: 4),
          Text(
            'Échec',
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.redFF0000),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Text('Réessayer',
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Text('Supprimer',
                  style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey)),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeLabel,
            style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey.shade500)),
        if (isClient) ...[
          const SizedBox(width: 4),
          if (message.deliveryState == MessageDeliveryState.sending)
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.grey.shade400,
              ),
            )
          else
            Icon(Icons.done, size: 13, color: Colors.grey.shade400),
        ],
        if (isClient && showReadMarker) ...[
          const SizedBox(width: 6),
          Text('Lu',
              style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}

/// Séparateur de jour centré dans la liste de messages.
class DaySeparator extends StatelessWidget {
  const DaySeparator({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
                fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
