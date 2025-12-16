import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EstateUserPage extends StatefulWidget {
  final String proprietaireId;
  const EstateUserPage({super.key, required this.proprietaireId});
  static String name = 'ESTATE_USER_PAGE';

  @override
  State<EstateUserPage> createState() => _EstateUserPageState();
}

class _EstateUserPageState extends State<EstateUserPage> {
  final BienImmobilierRepository bienImmobilierRepository =
      getIt<BienImmobilierRepository>();
  late PagingController<int, BienImmobilierModel> pagingController;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Future<void> loadPage(int page) async {
    bienImmobilierRepository
        .getBiensImmobiliersProprietaireId(
      proprietaireId: widget.proprietaireId,
      page: page,
      search: searchQuery.isEmpty ? null : searchQuery,
    )
        .then((value) {
      if (value.hasNext == true) {
        pagingController.appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        pagingController.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      pagingController.error = error.toString();
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    pagingController.refresh();
  }

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Biens de l\'utilisateur'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un bien...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: PagedSliverList<int, BienImmobilierModel>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => LoadProductCard(),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Aucun bien immobilier trouvé",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: EstateCard(
                    bienImmobilierModel: item,
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
