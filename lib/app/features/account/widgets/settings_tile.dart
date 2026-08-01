import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Tuile de paramètres style premium : icône dans conteneur 40×40, typo alignée.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
    this.trailing,
    this.tileColor,
    this.shape,
    this.titleColor,
    this.trailingColor,
    this.titleStyle,
  });

  final Widget leading;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? tileColor;
  final ShapeBorder? shape;
  final Color? titleColor;
  final Color? trailingColor;
  final TextStyle? titleStyle;

  static const double kIconContainerSize = 40;

  /// Coins arrondis pour le premier élément d'un groupe.
  static ShapeBorder get shapeFirst => const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      );

  static ShapeBorder get shapeLast => const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      );

  static ShapeBorder get shapeSingle => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );

  static ShapeBorder get shapeMiddle => const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: shape ?? shapeSingle,
      tileColor: tileColor ?? Colors.white,
      onTap: onTap,
      horizontalTitleGap: 16,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      minLeadingWidth: kIconContainerSize,
      leading: SizedBox(
        width: kIconContainerSize,
        height: kIconContainerSize,
        child: leading,
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: titleStyle ??
              TextStyle(
                color: titleColor ?? const Color(0xFF0D0D0D),
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.25,
              ),
        ),
      ),
      trailing: trailing ??
          Icon(
            FontAwesomeIcons.chevronRight.data,
            size: 14,
            color: trailingColor ?? const Color(0xFF374151),
          ),
    );
  }
}
