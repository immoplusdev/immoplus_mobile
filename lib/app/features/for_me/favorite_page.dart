import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/features/for_me/components/empty_indicator.dart';
import 'package:immoplus/app/features/for_me/components/favorite_card.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:isar_community/isar.dart';

import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_empty_state.dart';

// White Luxury — fond blanc, pas de noir
final Color _kBg = AppColors.white;
final Color _kGold = AppColors.gold600;
final Color _kTextPrimary = AppColors.immoTextPrimary;
final Color _kTextSecondary = AppColors.immoTextSecondary;
final Color _kSeparator = AppColors.immoBorderDefault;

class FavoritePage extends StatefulWidget {
  final bool embedded;
  const FavoritePage({super.key, this.embedded = false});
  static String name = 'FavoritePage';

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Stream<List<FovoriteModel>> _favoritesStream;
  final favoriesUtils = getIt<FavoriesUtils>();
  bool _isSelectionMode = false;
  final Set<int> _selectedItems = <int>{};

  @override
  void initState() {
    super.initState();
    getIt<IsarConfig>().init();
    _favoritesStream = favoriesUtils.isarConfig.instance.fovoriteModels
        .where()
        .watch(fireImmediately: true);
  }

  void _deleteFavorite(int id) async {
    await favoriesUtils.isarConfig.instance.writeTxn(() async {
      await favoriesUtils.isarConfig.instance.fovoriteModels.delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FovoriteModel>>(
      stream: _favoritesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: _kBg,
            body: Center(
              child: CircularProgressIndicator(color: _kGold),
            ),
          );
        }
        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          return CustomEmptyState(
            icon: Iconsax.heart,
            title: "Tu n'as rien trouvé",
            description:
                "Votre liste de favoris est vide Parcourez nos annonces et gardez un œil sur les biens qui vous intéressent.",
            buttonText: 'Explorer les biens',
            onButtonPressed: () {
              context.go('/homePage');
            },
          );
        }
        return Scaffold(
          backgroundColor: _kBg,
          appBar: widget.embedded
              ? null
              : AppBar(
                  backgroundColor: _kBg,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: false,
                  title: Text(
                    'Favoris',
                    style: AppTypography.h1.copyWith(
                      color: _kTextPrimary,
                    ),
                  ),
                  leading: _isSelectionMode
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _isSelectionMode = false;
                              _selectedItems.clear();
                            });
                          },
                          color: _kTextPrimary,
                        )
                      : null,
                  actions: [
                    if (_isSelectionMode) ...[
                      IconButton(
                        icon: const Icon(Icons.select_all),
                        onPressed: () {
                          setState(() {
                            if (_selectedItems.length == favorites.length) {
                              _selectedItems.clear();
                            } else {
                              _selectedItems.addAll(favorites.map((f) => f.id));
                            }
                          });
                        },
                        color: AppColors.black,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: _selectedItems.isEmpty
                            ? null
                            : () => _showDeleteDialog(favorites),
                        color: AppColors.red,
                      ),
                    ] else
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            setState(() => _isSelectionMode = true),
                        color: _kTextSecondary,
                      ),
                  ],
                ),
          body: ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Dismissible(
                  key: Key(favorite.itemId.toString()),
                  direction: _isSelectionMode
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  secondaryBackground: _isSelectionMode
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.red600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.trashCan.data,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                  background: _isSelectionMode
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            color: _kBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                  onDismissed: _isSelectionMode
                      ? null
                      : (direction) {
                          if (direction == DismissDirection.endToStart) {
                            _deleteFavorite(favorite.id);
                          }
                        },
                  child: GestureDetector(
                    onTap: _isSelectionMode
                        ? () {
                            setState(() {
                              if (_selectedItems.contains(favorite.id)) {
                                _selectedItems.remove(favorite.id);
                              } else {
                                _selectedItems.add(favorite.id);
                              }
                              if (_selectedItems.isEmpty) {
                                _isSelectionMode = false;
                              }
                            });
                          }
                        : null,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: _isSelectionMode ? 48 : 0,
                          ),
                          child: FavoriteCard(
                            favotiteModel: favorite,
                            isSelect: _isSelectionMode &&
                                _selectedItems.contains(favorite.id),
                          ),
                        ),
                        if (_isSelectionMode)
                          Positioned(
                            left: 0,
                            child: _buildSelectionCircle(
                              selected: _selectedItems.contains(favorite.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectionCircle({required bool selected}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.red : AppColors.transparent,
        border: Border.all(
          color: selected ? AppColors.red : _kSeparator,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 18, color: AppColors.white)
          : null,
    );
  }

  void _showDeleteDialog(List<FovoriteModel> favorites) {
    AppDialog.confirm(
      context: context,
      content:
          'Voulez-vous vraiment supprimer ${_selectedItems.length} favori(s) ?',
      barrierDismissible: true,
      isDestructiveAction: true,
      rollback: () async {
        context.pop();
        await _deleteSelectedFavorites();
      },
    );
  }

  Future<void> _deleteSelectedFavorites() async {
    await favoriesUtils.isarConfig.instance.writeTxn(() async {
      await favoriesUtils.isarConfig.instance.fovoriteModels
          .deleteAll(_selectedItems.toList());
    });
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
