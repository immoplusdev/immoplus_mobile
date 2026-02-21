import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/features/for_me/components/empty_indicator.dart';
import 'package:immoplus/app/features/for_me/components/favorite_card.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:isar_community/isar.dart';

// White Luxury — fond blanc, pas de noir
const Color _kBg = Color(0xFFFFFFFF);
const Color _kGold = Color(0xFFC9A84C);
const Color _kTextPrimary = Color(0xFF0A1128);
const Color _kTextSecondary = Color(0xFF6B7280);
const Color _kSeparator = Color(0xFFE5E7EB);

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
    return StreamBuilder<List<FovoriteModel>>(
      stream: _favoritesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: _kBg,
            body: const Center(
              child: CircularProgressIndicator(color: _kGold),
            ),
          );
        }
        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          return const EmptyIndicator();
        }
        return Scaffold(
          backgroundColor: _kBg,
          appBar: AppBar(
            backgroundColor: _kBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text(
              'Favoris',
              style: GoogleFonts.dmSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: _kTextPrimary,
                letterSpacing: -0.5,
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
                  color: Colors.black,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _selectedItems.isEmpty
                      ? null
                      : () => _showDeleteDialog(favorites),
                  color: Colors.red,
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => _isSelectionMode = true),
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
                            color: Colors.red.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            FontAwesomeIcons.trashCan,
                            color: Colors.white,
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
        color: selected ? Colors.red : Colors.transparent,
        border: Border.all(
          color: selected ? Colors.red : _kSeparator,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 18, color: Colors.white)
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
