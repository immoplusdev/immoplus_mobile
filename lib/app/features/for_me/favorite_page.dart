import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/features/for_me/components/empty_indicator.dart';
import 'package:immoplus/app/features/for_me/components/favorite_card.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:isar_community/isar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
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
    final theme = Theme.of(context);
    return StreamBuilder<List<FovoriteModel>>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return const EmptyIndicator();
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoris'),
              leading: _isSelectionMode
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSelectionMode = false;
                          _selectedItems.clear();
                        });
                      },
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
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _selectedItems.isEmpty
                        ? null
                        : () => _showDeleteDialog(favorites),
                  ),
                ] else
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = true;
                      });
                    },
                  ),
              ],
            ),
            body: ListView.builder(
              itemCount: favorites.length,
              padding: const EdgeInsets.all(appPadding),
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Dismissible(
                  key: Key(favorite.itemId.toString()),
                  direction: _isSelectionMode
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  secondaryBackground: _isSelectionMode
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                FontAwesomeIcons.trashCan,
                                color: Colors.white,
                              ),
                              Gap(10),
                            ],
                          ),
                        ),
                  background: _isSelectionMode
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                  onDismissed: _isSelectionMode
                      ? null
                      : (direction) {
                          if (direction.name ==
                              DismissDirection.endToStart.name) {
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FavoriteCard(
                            favotiteModel: favorite,
                            isSelect: _isSelectionMode &&
                                _selectedItems.contains(favorite.id),
                          ),
                        ),
                        if (_isSelectionMode)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedItems.contains(favorite.id)
                                    ? theme.colorScheme.primary
                                    : Colors.grey.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _selectedItems.contains(favorite.id)
                                    ? Icons.check
                                    : Icons.radio_button_unchecked,
                                color: _selectedItems.contains(favorite.id)
                                    ? Colors.white
                                    : Colors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
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
        });
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
