import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// Options disponibles pour le type de propriété
enum PropertyType {
  meuble('Meublé'),
  terrain('Terrain'),
  location('Location'),
  achat('Achat');

  final String label;
  const PropertyType(this.label);
}

/// Callback quand une option est sélectionnée
typedef OnPropertyTypeSelected = void Function(PropertyType type);

/// Dropdown réutilisable pour filtrer par type de propriété
/// S'affiche directement sous l'onglet "Immobilier"
class PropertyTypeDropdown extends StatefulWidget {
  const PropertyTypeDropdown({
    super.key,
    required this.onSelected,
    this.selectedType,
  });

  final OnPropertyTypeSelected onSelected;
  final PropertyType? selectedType;

  @override
  State<PropertyTypeDropdown> createState() => _PropertyTypeDropdownState();
}

class _PropertyTypeDropdownState extends State<PropertyTypeDropdown> {
  late PropertyType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
  }

  void _onOptionTap(PropertyType type) {
    setState(() => _selectedType = type);
    widget.onSelected(type);
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                left: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: PropertyType.values.map((type) {
                final isSelected = _selectedType == type;
                return _PropertyTypeOption(
                  type: type,
                  isSelected: isSelected,
                  onTap: () => _onOptionTap(type),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Option individuelle du dropdown
class _PropertyTypeOption extends StatelessWidget {
  const _PropertyTypeOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final PropertyType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Text(
              type.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
