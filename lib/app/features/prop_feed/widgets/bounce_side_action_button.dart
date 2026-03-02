import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Bouton Réserver avec coins arrondis, couleur bleue et animation scale au tap.
/// Utilise Iconsax.calendar_tick par défaut pour suggérer une action confirmée.
class BounceSideActionButton extends StatefulWidget {
  const BounceSideActionButton({
    super.key,
    this.icon = Iconsax.calendar_tick,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  static const Color _ctaBlue = Color(0xFF2563EB);

  @override
  State<BounceSideActionButton> createState() => _BounceSideActionButtonState();
}

class _BounceSideActionButtonState extends State<BounceSideActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final labelColor = widget.labelColor ?? Colors.white;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 54,
          height: 64,
          decoration: BoxDecoration(
            color: BounceSideActionButton._ctaBlue,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: BounceSideActionButton._ctaBlue.withOpacity(0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
