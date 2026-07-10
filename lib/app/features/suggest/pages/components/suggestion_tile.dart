import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/suggest/suggestion_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class SuggestionTile extends StatelessWidget {
  final SuggestionModel suggestion;
  final String query;
  final VoidCallback onTap;
  final ValueChanged<String> onCopy;

  const SuggestionTile({
    super.key,
    required this.suggestion,
    required this.query,
    required this.onTap,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final type = suggestion.type ?? SuggestionType.unknown;
    final IconData leadingIcon = type.icon;

    return ListTile(
      leading: Icon(
        leadingIcon,
        color: Colors.grey.shade500,
        size: 20,
      ),
      title: _buildHighlightText(suggestion.label ?? '', query),
      subtitle: (suggestion.sublabel != null && suggestion.sublabel!.isNotEmpty)
          ? Text(
              suggestion.sublabel!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (suggestion.miniatureUrl != null &&
              suggestion.miniatureUrl!.isNotEmpty) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  Utils.getImagePath(id: suggestion.miniatureUrl!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
            const Gap(8),
          ],
          IconButton(
            icon: Icon(
              Icons.arrow_outward_rounded,
              color: Colors.grey.shade400,
              size: 18,
            ),
            onPressed: () => onCopy(suggestion.label ?? ''),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildHighlightText(String text, String highlight) {
    if (highlight.isEmpty ||
        !text.toLowerCase().contains(highlight.toLowerCase())) {
      return Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      );
    }

    final matchIndex = text.toLowerCase().indexOf(highlight.toLowerCase());
    final preText = text.substring(0, matchIndex);
    final matchText = text.substring(matchIndex, matchIndex + highlight.length);
    final postText = text.substring(matchIndex + highlight.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: preText),
          TextSpan(
            text: matchText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          TextSpan(text: postText),
        ],
      ),
    );
  }
}
