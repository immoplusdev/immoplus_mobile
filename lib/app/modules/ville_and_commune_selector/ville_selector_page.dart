import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';
import 'package:immoplus/app/data/repositories/config_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class VilleSelectorPage extends StatefulWidget {
  const VilleSelectorPage({super.key});

  @override
  State<VilleSelectorPage> createState() => _VilleSelectorPageState();
}

class _VilleSelectorPageState extends State<VilleSelectorPage> {
  final PagingController<int, VilleModel> _pagingController =
      PagingController(firstPageKey: 1);
  Future<void> loadPage(int page) async {
    ConfigRepository().getVilles(page: page, perPage: 5).then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(value.data ?? [], (value.currentPage) + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      _pagingController.error = error.toString();
    });
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Sélectionner une ville'),
            backgroundColor: AppColors.scafold,
            centerTitle: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          PagedSliverList<int, VilleModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                    //height: 600,
                    child: Column(
                  children: List.generate(
                    20,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: const CupertinoListTile(
                          backgroundColor: Colors.red,
                          title: Text("•••••••••••••••••••"),
                        ),
                      ),
                    ),
                  ),
                )),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                "Aucun élément trouvé",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: AppColors.primaryLite,
                  title: Text(item.name),
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  onTap: () {
                    context.pop<VilleModel>(item);
                  },
                  trailing: Icon(FontAwesomeIcons.circleArrowRight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
