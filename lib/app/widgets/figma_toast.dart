import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:toastification/toastification.dart';

enum FigmaToastType {
  error,
  success,
  info,
  warning;

  Color get color {
    switch (this) {
      case FigmaToastType.error:
        return AppColors.redFF0000;
      case FigmaToastType.success:
        return AppColors.green1CA53F;
      case FigmaToastType.info:
        return AppColors.primary;
      case FigmaToastType.warning:
        return _Constants.warningColor;
    }
  }
}

class _Constants {
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color descriptionColor = Color(0xFF9E9E9E);

  static const double horizontalMargin = 12;
  static const double verticalMargin = 6;
  static const double horizontalPadding = 16;
  static const double verticalPadding = 14;
  static const double borderRadius = 16;
  static const double shadowBlur = 12;
  static const double shadowAlpha = 0.06;
  static const double shadowOffsetY = 4;

  static const double titleFontSize = 16;
  static const double descriptionFontSize = 12;
  static const double iconSize = 22;
  static const double iconSpacing = 12;
  static const double descriptionSpacing = 4;
}

class FigmaToast extends StatelessWidget {
  const FigmaToast({
    super.key,
    required this.type,
    required this.title,
    required this.holder,
    this.description,
  });

  final FigmaToastType type;
  final String title;
  final String? description;
  final ToastificationItem holder;

  @override
  Widget build(BuildContext context) {
    final color = type.color;

    return GestureDetector(
      onTap: () => toastification.dismiss(holder),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: _Constants.horizontalMargin,
          vertical: _Constants.verticalMargin,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: _Constants.horizontalPadding,
          vertical: _Constants.verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_Constants.borderRadius),
          border: Border.all(color: _Constants.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _Constants.shadowAlpha),
              blurRadius: _Constants.shadowBlur,
              offset: const Offset(0, _Constants.shadowOffsetY),
            ),
          ],
        ),
        child: description != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: _Constants.titleFontSize,
                    ),
                  ),
                  const SizedBox(height: _Constants.descriptionSpacing),
                  Text(
                    description!,
                    style: TextStyle(
                        color: color.withOpacity(.8),
                        fontSize: _Constants.descriptionFontSize,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: _Constants.titleFontSize,
                      ),
                    ),
                  ),
                  const SizedBox(width: _Constants.iconSpacing),
                  Icon(
                    Icons.error_outline_rounded,
                    color: color,
                    size: _Constants.iconSize,
                  ),
                ],
              ),
      ),
    );
  }
}
