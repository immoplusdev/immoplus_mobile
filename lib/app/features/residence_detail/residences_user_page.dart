import 'package:flutter/material.dart';
import 'package:immoplus/app/data/enums/validation_status.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResidencesUserPage extends StatefulWidget {
  final String userId;
  const ResidencesUserPage({super.key, required this.userId});
  static String name = 'RESIDENCES_USER_PAGE';

  @override
  State<ResidencesUserPage> createState() => _ResidencesUserPageState();
}

class _ResidencesUserPageState extends State<ResidencesUserPage> {
  final ResidenceRepository residenceRepository = getIt<ResidenceRepository>();
  late PagingController<int, ResidenceModel> pagingController;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Future<void> loadPage(int page) async {
    residenceRepository
        .getResidencesProprietaire(
      proprietaireId: widget.userId,
      page: page,
      search: searchQuery.isEmpty ? null : searchQuery,
      where: {
        '_where': [
          '{"_field": "validationStatus", "_op": "eq", "_val": "${ValidationStatus.valide.value}"}',
        ],
      },
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
            title: const Text('Résidences de l\'utilisateur'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une résidence...',
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
            sliver: PagedSliverList<int, ResidenceModel>(
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
                      "Aucune résidence trouvée",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1)
                      .copyWith(bottom: 13),
                  child: ResidenceCard(
                    residence: item,
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
