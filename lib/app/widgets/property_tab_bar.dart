import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Définition d'un onglet pour [PropertyTabBar].
class PropertyTabItem {
  const PropertyTabItem({required this.label, required this.child});

  /// Libellé affiché dans la barre d'onglets.
  final String label;

  /// Contenu affiché sous la barre quand cet onglet est actif.
  final Widget child;
}

/// TabBar stylisé pour les fiches propriété.
///
/// - Actif  : texte [AppColors.primary] + indicateur souligné primaire.
/// - Inactif : texte gris, aucun soulignement.
/// - Extensible : passer autant de [PropertyTabItem] que nécessaire.
///
/// ```dart
/// PropertyTabBar(
///   tabs: [
///     PropertyTabItem(label: 'Overview', child: OverviewWidget()),
///     PropertyTabItem(label: 'Map',      child: MapWidget()),
///     PropertyTabItem(label: 'Avis',     child: ReviewsWidget()),
///   ],
///   tabSpacing: 24,
/// )
/// ```
class PropertyTabBar extends StatefulWidget {
  const PropertyTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.tabSpacing = 24.0,
  }) : assert(tabs.length > 0, 'tabs ne peut pas être vide');

  final List<PropertyTabItem> tabs;

  /// Index de l'onglet sélectionné au démarrage.
  final int initialIndex;

  /// Espacement entre les labels des tabs.
  final double tabSpacing;

  @override
  State<PropertyTabBar> createState() => _PropertyTabBarState();
}

class _PropertyTabBarState extends State<PropertyTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, widget.tabs.length - 1),
    );
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_controller.indexIsChanging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _controller,
          tabs: widget.tabs
              .map((t) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.tabSpacing / 2),
                    child: Tab(text: t.label),
                  ))
              .toList(),
          // Onglet actif
          labelColor: AppColors.primary,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          // Onglets inactifs
          unselectedLabelColor: const Color(0xFFAAAAAA),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          // Indicateur : ligne sous le label actif uniquement
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary, width: 3),
            // insets: const EdgeInsets.symmetric(horizontal: 12),
            borderRadius: BorderRadius.circular(20),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          // Pas de ligne grise sous tout le TabBar
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          padding: EdgeInsets.zero,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 12),
        // Contenu de l'onglet actif
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey(_controller.index),
            child: widget.tabs[_controller.index].child,
          ),
        ),
      ],
    );
  }
}
