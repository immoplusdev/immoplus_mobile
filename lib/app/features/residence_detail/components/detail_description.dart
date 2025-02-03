import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class DetailDescription extends StatefulWidget {
  final String markdownText;

  const DetailDescription({super.key, required this.markdownText});

  @override
  State<DetailDescription> createState() => _DetailDescriptionState();
}

class _DetailDescriptionState extends State<DetailDescription> {
  final bool _showFullText =
      false; // Contrôle si le texte est complètement affiché

  String truncateTextToLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required int maxLines,
    String suffix = "...",
  }) {
    // Utilisation de TextPainter pour mesurer le texte
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    // Si le texte dépasse le nombre de lignes max
    if (textPainter.didExceedMaxLines) {
      // On réduit le texte progressivement
      for (int i = text.length; i > 0; i--) {
        final truncatedText = text.substring(0, i) + suffix;
        final truncatedPainter = TextPainter(
          text: TextSpan(text: truncatedText, style: style),
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        )..layout(maxWidth: maxWidth);

        // On retourne le texte tronqué dès qu'il respecte la contrainte
        if (!truncatedPainter.didExceedMaxLines) {
          return truncatedText;
        }
      }
    }

    // Si le texte ne dépasse pas, on retourne le texte complet
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        //Utilisation d'un Widget de mesure pour déterminer le dépassement des lignes
        final textSpan = TextSpan(
          text: truncateTextToLines(
              text: widget.markdownText,
              style: Theme.of(context).textTheme.bodyMedium!,
              maxWidth: 4,
              maxLines: 2),
          style: Theme.of(context).textTheme.bodyMedium,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 4,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;
        final truncatedText = truncateTextToLines(
          text: widget.markdownText,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          maxWidth: constraints.maxWidth,
          maxLines: 4,
        );
        return RichText(
            text: TextSpan(
          children: [
            TextSpan(
              text: truncatedText,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
            const TextSpan(text: ' '),
            if (isOverflowing &&
                !_showFullText) // Espace entre le texte et "Voir Plus"
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.transparent,
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              automaticallyImplyLeading: false,
                              title: const Text('À propos du logement'),
                              titleTextStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            body: Markdown(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              data: widget
                                  .markdownText, //state.finishData.data!.description!,
                              //styleSheet: MarkdownStyleSheet(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Voir Plus...',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ));
      },
    );
  }

  void _onVoirPlus() {
    // Fonction vide pour personnaliser ultérieurement
  }
}
