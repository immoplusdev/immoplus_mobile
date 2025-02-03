import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/features/for_me/components/empty_indicator.dart';
import 'package:immoplus/app/features/for_me/components/favorite_card.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:isar/isar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  static String name = 'FavoritePage';

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Stream<List<FovoriteModel>> _favoritesStream;
  final favoriesUtils = getIt<FavoriesUtils>();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await favoriesUtils.isarConfig.instance.writeTxn(() async {
                await favoriesUtils.isarConfig.instance.fovoriteModels.clear();
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<FovoriteModel>>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];
          if (favorites.isEmpty) {
            return const EmptyIndicator();
          }
          return ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return Dismissible(
                  key: Key(favorite.itemId.toString()),
                  direction: DismissDirection.endToStart,
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.red, // Couleur rouge pour supprimer
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
                  background: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary, // Couleur secondaire
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction.name == DismissDirection.endToStart.name) {
                      _deleteFavorite(favorite.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FavoriteCard(favotiteModel: favorite),
                  ));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
