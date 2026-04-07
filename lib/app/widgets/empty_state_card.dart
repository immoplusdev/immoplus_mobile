import 'dart:async';
import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.imageHeight = 200,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double imageHeight;

  /// Affiche la card en tant que modal flottante.
  /// [autoDismissDuration] : si fourni, la modal se ferme automatiquement après ce délai.
  static Future<void> showAsModal(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onButtonPressed,
    double imageHeight = 200,
    Duration? autoDismissDuration,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        clipBehavior: Clip.antiAlias,
        child: _EmptyStateCardModal(
          imagePath: imagePath,
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
          imageHeight: imageHeight,
          autoDismissDuration: autoDismissDuration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EmptyStateCardContent(
      imagePath: imagePath,
      title: title,
      subtitle: subtitle,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      imageHeight: imageHeight,
    );
  }
}

class _EmptyStateCardModal extends StatefulWidget {
  const _EmptyStateCardModal({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.imageHeight = 200,
    this.autoDismissDuration,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double imageHeight;
  final Duration? autoDismissDuration;

  @override
  State<_EmptyStateCardModal> createState() => _EmptyStateCardModalState();
}

class _EmptyStateCardModalState extends State<_EmptyStateCardModal> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoDismissDuration != null) {
      _timer = Timer(widget.autoDismissDuration!, () {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _EmptyStateCardContent(
          imagePath: widget.imagePath,
          title: widget.title,
          subtitle: widget.subtitle,
          buttonText: widget.buttonText,
          onButtonPressed: widget.onButtonPressed,
          imageHeight: widget.imageHeight,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyStateCardContent extends StatelessWidget {
  const _EmptyStateCardContent({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.imageHeight = 200,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.customBlue,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                if (buttonText != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.customBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonText!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
