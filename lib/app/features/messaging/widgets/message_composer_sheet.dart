import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/injection.dart';
import '../../../data/models/remote/messaging/create_conversation_response.dart';
import '../../../data/models/remote/residence/residence_model.dart';
import '../../../data/repositories/messaging_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/toast_utils.dart';
import '../../../utils/utils.dart';
import '../pages/message_thread_page.dart';

/// Composer premier message (spec §3), générique pour les 3 types de fil —
/// seuls le titre, le placeholder, la carte de contexte et l'appel API
/// changent selon le point d'entrée (résidence / visite / support).
class MessageComposerSheet extends StatefulWidget {
  const MessageComposerSheet({
    super.key,
    required this.title,
    required this.placeholder,
    required this.contextCard,
    required this.onSubmit,
  });

  final String title;
  final String placeholder;

  /// `null` pour le support (spec §3 : remplacé par un texte court).
  final Widget? contextCard;

  final Future<CreateConversationResponse> Function(String message) onSubmit;

  static Future<void> showForResidence(
    BuildContext context, {
    required ResidenceModel residenceModel,
  }) {
    return _show(
      context,
      MessageComposerSheet(
        title: "Contacter l'hôte",
        placeholder: 'Posez votre question à l\'hôte…',
        contextCard: _ResidenceContextCard(residence: residenceModel),
        onSubmit: (message) => getIt<MessagingRepository>()
            .createOrResumeConversation(
                residenceId: residenceModel.id, message: message),
      ),
    );
  }

  static Future<void> showForVisite(
    BuildContext context, {
    required String demandeVisiteId,
    required String bienTitle,
    String? bienPhotoUrl,
  }) {
    return _show(
      context,
      MessageComposerSheet(
        title: 'Contacter le propriétaire',
        placeholder: 'Posez votre question à l\'hôte…',
        contextCard: _SimpleContextCard(title: bienTitle, photoUrl: bienPhotoUrl),
        onSubmit: (message) => getIt<MessagingRepository>()
            .createVisiteConversation(
                demandeVisiteId: demandeVisiteId, message: message),
      ),
    );
  }

  static Future<void> showForRelais(
    BuildContext context, {
    required String relaisId,
    required String title,
    required String propertyLabel,
    String? location,
  }) {
    return _show(
      context,
      MessageComposerSheet(
        title: title,
        placeholder: 'Écrivez votre message…',
        contextCard: _SimpleContextCard(title: propertyLabel, subtitle: location),
        onSubmit: (message) => getIt<MessagingRepository>()
            .createRelaisConversation(relaisId: relaisId, message: message),
      ),
    );
  }

  static Future<void> showForSupport(BuildContext context) {
    return _show(
      context,
      MessageComposerSheet(
        title: 'Contacter le support',
        placeholder: 'Décrivez votre problème…',
        contextCard: null,
        onSubmit: (message) =>
            getIt<MessagingRepository>().createSupportConversation(message: message),
      ),
    );
  }

  static Future<void> _show(BuildContext context, MessageComposerSheet sheet) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.whiteBackground,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (_) => sheet,
    );
  }

  @override
  State<MessageComposerSheet> createState() => _MessageComposerSheetState();
}

class _MessageComposerSheetState extends State<MessageComposerSheet> {
  final _controller = TextEditingController();
  bool _isSending = false;
  String? _moderationBanner;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty && !_isSending;

  Future<void> _send() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _isSending = true;
      _moderationBanner = null;
    });

    try {
      final response = await widget.onSubmit(message);
      if (!mounted) return;
      Navigator.of(context).pop();
      context.pushNamed(
        MessageThreadPage.name,
        pathParameters: {'conversationId': response.conversation.id},
      );
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      final data = dioError.response?.data;
      final code = data is Map ? data['code']?.toString() : null;

      if (statusCode == 403) {
        if (!mounted) return;
        Navigator.of(context).pop();
        ToastUtils.showError(
          description: "Vous n'avez pas accès à cette action.",
        );
        return;
      }
      if (code == 'CONTACT_INFO_DETECTED') {
        setState(() {
          _isSending = false;
          _moderationBanner = data is Map ? data['message']?.toString() : null;
          _moderationBanner ??= 'Ce message ne peut pas être envoyé : les '
              'numéros de téléphone, e-mails, liens et réseaux sociaux ne '
              'sont pas autorisés dans la conversation.';
        });
        return;
      }
      setState(() => _isSending = false);
      ToastUtils.showError(
        description: "Le message n'a pas pu être envoyé. Réessayer.",
      );
    } catch (_) {
      setState(() => _isSending = false);
      ToastUtils.showError(
        description: "Le message n'a pas pu être envoyé. Réessayer.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.contextCard != null) ...[
              widget.contextCard!,
              const SizedBox(height: 16),
            ] else ...[
              Text(
                'Notre équipe vous répond généralement sous quelques heures.',
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
            ],
            if (_moderationBanner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redFF0000.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.redFF0000.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _moderationBanner!,
                  style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.redFF0000),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 3,
              enabled: !_isSending,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                if (_moderationBanner != null) {
                  setState(() => _moderationBanner = null);
                }
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _canSend ? _send : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  disabledForegroundColor: Colors.grey.shade400,
                  side: BorderSide(
                    color: _canSend ? AppColors.primary : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                child: _isSending
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      )
                    : Text(
                        'Envoyer',
                        style: GoogleFonts.dmSans(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidenceContextCard extends StatelessWidget {
  const _ResidenceContextCard({required this.residence});
  final ResidenceModel residence;

  @override
  Widget build(BuildContext context) {
    final coverImageId = residence.images.isNotEmpty ? residence.images.first : null;
    return _SimpleContextCard(
      title: residence.nom,
      subtitle: residence.ville.isNotEmpty ? residence.ville : null,
      photoUrl: coverImageId != null ? Utils.getImagePath(id: coverImageId) : null,
    );
  }
}

class _SimpleContextCard extends StatelessWidget {
  const _SimpleContextCard({required this.title, this.subtitle, this.photoUrl});
  final String title;
  final String? subtitle;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 48,
            height: 48,
            child: (photoUrl?.isNotEmpty ?? false)
                ? CachedNetworkImage(imageUrl: photoUrl!, fit: BoxFit.cover)
                : Container(
                    color: Colors.grey.shade100,
                    child: Icon(Icons.home_outlined, color: Colors.grey.shade400),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(subtitle!,
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
