import 'package:flutter/material.dart';
import 'property_type_dropdown.dart';

/// Barre de navigation supérieure du feed : onglets + recherche.
class TopNavBar extends StatefulWidget {
  const TopNavBar({
    super.key,
    this.initialIndex = 0,
    this.onTabSelected,
    this.onSearchTap,
    this.onPropertyTypeSelected,
  });

  final int initialIndex;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onSearchTap;
  final ValueChanged<PropertyType>? onPropertyTypeSelected;

  static const List<String> _tabs = [ 'Pour Toi'];

  /// Espacement horizontal entre les onglets.
  static const double tabSpacing = 12;

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();
  bool _showPropertyDropdown = false;
  PropertyType? _selectedPropertyType;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TopNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
    widget.onTabSelected?.call(index);
  }

  void _onImmobilierLongPress() {
    setState(() => _showPropertyDropdown = true);
  }

  /// Retourne le label de l'onglet (affiche le type sélectionné pour Immobilier)
  String _getTabLabel(int index) {
    if (index == 2 && _selectedPropertyType != null) {
      return _selectedPropertyType!.label;
    }
    return TopNavBar._tabs[index];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  TopNavBar._tabs.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index < TopNavBar._tabs.length - 1
                          ? TopNavBar.tabSpacing
                          : 0,
                    ),
                    child: index == 2
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _TabItem(
                                label: _getTabLabel(index),
                                isSelected: _selectedIndex == index,
                                onTap: () => _onTabTap(index),
                                onLongPress: _onImmobilierLongPress,
                              ),
                              if (_showPropertyDropdown)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: PropertyTypeDropdown(
                                    selectedType: _selectedPropertyType,
                                    onSelected: (type) {
                                      setState(() => _selectedPropertyType = type);
                                      widget.onPropertyTypeSelected?.call(type);
                                      Future.delayed(
                                        const Duration(milliseconds: 150),
                                        () {
                                          if (mounted) {
                                            setState(
                                                () => _showPropertyDropdown =
                                                    false);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          )
                        : _TabItem(
                            label: _getTabLabel(index),
                            isSelected: _selectedIndex == index,
                            onTap: () => _onTabTap(index),
                            onLongPress: null,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.white.withValues(alpha: 0.2),
        //     width: 1,
        //   ),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                shadows: [
                  Shadow(
                    color: const Color(0xFF1E1E1E).withValues(alpha: 0.2),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 24 : 0,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

