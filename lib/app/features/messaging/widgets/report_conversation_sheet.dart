import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/remote/messaging/report_reason.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/toast_utils.dart';

/// Bottom sheet de signalement (spec §7.1).
class ReportConversationSheet extends StatefulWidget {
  const ReportConversationSheet({super.key, required this.onSubmit});

  /// Retourne `true` si le signalement a été envoyé avec succès.
  final Future<bool> Function({required String reason, String? details}) onSubmit;

  static Future<void> show(
    BuildContext context, {
    required Future<bool> Function({required String reason, String? details})
        onSubmit,
  }) {
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
      builder: (_) => ReportConversationSheet(onSubmit: onSubmit),
    );
  }

  @override
  State<ReportConversationSheet> createState() => _ReportConversationSheetState();
}

class _ReportConversationSheetState extends State<ReportConversationSheet> {
  ReportReason? _selected;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _selected;
    if (reason == null) return;
    setState(() => _isSubmitting = true);
    final success = await widget.onSubmit(
      reason: reason.value,
      details: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ToastUtils.showSuccess(description: 'Signalement envoyé, merci.');
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() => _isSubmitting = false);
      ToastUtils.showError(description: "Le signalement n'a pas pu être envoyé.");
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
            Text('Signaler cette conversation',
                style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...ReportReason.values.map((reason) {
              final isSelected = _selected == reason;
              return RadioListTile<ReportReason>(
                value: reason,
                groupValue: _selected,
                onChanged: (value) => setState(() => _selected = value),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  reason.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Text('Détails (facultatif)',
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade700)),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: (_selected != null && !_isSubmitting) ? _submit : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  disabledForegroundColor: Colors.grey.shade400,
                  side: BorderSide(
                    color: _selected != null ? AppColors.primary : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary))
                    : Text('Envoyer le signalement',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
