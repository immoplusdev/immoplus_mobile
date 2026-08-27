import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class _Constants {
  static const double menuHeight = 58.0;
  // Aligné sur le padding horizontal de la barre de recherche
  // (home_search_appbar.dart) pour que les deux commencent à la même ligne.
  static const double horizontalPadding = 15.0;
  static const double itemSpacing = 8.0;
  static const double itemHorizontalPadding = 6.0;
  static const double itemVerticalPadding = 8.0;
  static const double borderRadius = 20.0;
  static const double borderWidth = 1.0;
  static const double borderOpacity = 0.3;
  static const double textIconGap = 5.0;
  static const double textFontSize = 11.0;

  // L'icône varie entre ces deux tailles selon l'espace disponible : plus
  // petite sur un écran étroit pour laisser de la place au texte (moins de
  // troncation), pleine taille dès que l'écran est assez large.
  static const double minImageSize = 16.0;
  static const double maxImageSize = 22.0;

  // Largeur de référence utilisée pour l'interpolation de la taille d'icône
  // (voir _computeItemMetrics). Ne sert plus de plancher de largeur : les 4
  // onglets doivent toujours tenir sur une seule ligne, quelle que soit la
  // largeur d'écran.
  static const double minItemWidth = 82.0;
}

class _ItemMetrics {
  const _ItemMetrics({required this.width, required this.iconSize});

  final double width;
  final double iconSize;
}

double _chrome(double iconSize) =>
    iconSize +
    _Constants.textIconGap +
    (_Constants.itemHorizontalPadding * 2) +
    (_Constants.borderWidth * 2) +
    2; // marge de sécurité contre les arrondis

/// Calcule la largeur de bulle et la taille d'icône adaptées à l'espace
/// disponible par onglet : l'icône rétrécit sur petit écran pour donner plus
/// de place au texte, et grandit jusqu'à sa taille normale dès qu'il y a
/// assez de place pour afficher le libellé le plus long sans troncation.
_ItemMetrics _computeItemMetrics(
  BuildContext context,
  List<HomeTab> tabs,
  double availableWidthPerItem,
) {
  final style = Theme.of(context).textTheme.labelMedium!.copyWith(
        fontSize: _Constants.textFontSize,
        fontWeight: FontWeight.w600,
      );
  var maxTextWidth = 0.0;
  for (final tab in tabs) {
    final painter = TextPainter(
      text: TextSpan(text: tab.label, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    if (painter.width > maxTextWidth) {
      maxTextWidth = painter.width;
    }
  }

  final naturalWidthAtMaxIcon = maxTextWidth + _chrome(_Constants.maxImageSize);
  final t = naturalWidthAtMaxIcon <= _Constants.minItemWidth
      ? 1.0
      : ((availableWidthPerItem - _Constants.minItemWidth) /
              (naturalWidthAtMaxIcon - _Constants.minItemWidth))
          .clamp(0.0, 1.0);
  final iconSize = _Constants.minImageSize +
      (_Constants.maxImageSize - _Constants.minImageSize) * t;

  final naturalItemWidth = maxTextWidth + _chrome(iconSize);
  // Plafonné à la largeur naturelle (pour ne pas s'étirer inutilement quand
  // il y a de la place), jamais en dessous de l'espace réellement
  // disponible : les 4 onglets doivent toujours tenir sans scroll.
  final width = availableWidthPerItem.clamp(0.0, naturalItemWidth);

  return _ItemMetrics(width: width, iconSize: iconSize);
}

class HomeChoiceMenu extends StatelessWidget {
  const HomeChoiceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        final tabs = HomeTab.valuestabs;

        return SizedBox(
          height: _Constants.menuHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth -
                  (_Constants.horizontalPadding * 2) -
                  (_Constants.itemSpacing * (tabs.length - 1));
              final rawItemWidth = availableWidth / tabs.length;
              final metrics = _computeItemMetrics(context, tabs, rawItemWidth);

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: _Constants.horizontalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth -
                        (_Constants.horizontalPadding * 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < tabs.length; i++) ...[
                        if (i > 0) const Gap(_Constants.itemSpacing),
                        _HomeTabItem(
                          tab: tabs[i],
                          width: metrics.width,
                          iconSize: metrics.iconSize,
                          isSelected: state.indexPage == tabs[i].value,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HomeTabItem extends StatelessWidget {
  const _HomeTabItem({
    required this.tab,
    required this.width,
    required this.iconSize,
    required this.isSelected,
  });

  final HomeTab tab;
  final double width;
  final double iconSize;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tab == HomeTab.hotel) {
          context.push('/hotels');
        } else {
          context.read<HomePageCubit>().changeIndex(tab.value);
        }
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: _Constants.itemHorizontalPadding,
          vertical: _Constants.itemVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(_Constants.borderRadius),
          border: Border.all(
            color: AppColors.primary.withOpacity(_Constants.borderOpacity),
            width: _Constants.borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: ClipOval(
                child: Image.asset(
                  tab.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                ),
              ),
            ),
            const Gap(_Constants.textIconGap),
            Flexible(
              child: Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: _Constants.textFontSize,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
