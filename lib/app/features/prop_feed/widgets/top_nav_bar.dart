import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Barre de navigation supérieure du feed : onglets + recherche.
class TopNavBar extends StatefulWidget {
  const TopNavBar({
    super.key,
    this.initialIndex = 1,
    this.onTabSelected,
    this.onSearchTap,
  });

  final int initialIndex;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onSearchTap;

  static const List<String> _tabs = ['Near you', 'For you'];

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(TopNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  TopNavBar._tabs.length,
                  (index) => _TabItem(
                    label: TopNavBar._tabs[index],
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      widget.onTabSelected?.call(index);
                    },
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: widget.onSearchTap,
            //   child: const Icon(
            //     Iconsax.search_normal_1,
            //     color: Colors.white,
            //     size: 24,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
