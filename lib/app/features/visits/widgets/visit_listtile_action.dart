import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitListTileAction extends StatelessWidget {
  const VisitListTileAction({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.price,
    this.icon,
    this.backgroundImage,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final void Function()? onTap;
  final String? price;
  final IconData? icon;
  final ImageProvider<Object>? backgroundImage;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Leading icon / image
            Container(
              width: 56,
              // height: 56,
              // decoration: BoxDecoration(
              //   color: primaryColor.withOpacity(0.08),
              //   borderRadius: BorderRadius.circular(16),
              // ),
              child: backgroundImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image: backgroundImage!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      icon ?? CupertinoIcons.calendar,
                      color: primaryColor,
                      size: 28,
                    ),
            ),

            const SizedBox(width: 14),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title row with optional price
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (price != null && price!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$price Fcfa',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
              ),
            ),
                    const SizedBox(width: 8),

            // Trailing
            trailing ??
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
          ],
          
        ),
      ),
    );
  }
}