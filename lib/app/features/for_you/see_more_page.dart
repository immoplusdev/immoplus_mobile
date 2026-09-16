import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum SeeMoreContentType { residence, bien }

/// Page générique de "Voir plus" pour une section de la home agrégée
/// (`GET /me/home`) : appelle `seeMoreEndpoint` tel quel — l'endpoint REST
/// dédié de la ressource, pas `/me/home` — avec la pagination classique de
/// l'app (`_page`). Marche pour toute section `residence_list`/`bien_list`
/// sans code dédié par section.
class SeeMorePage extends StatefulWidget {
  const SeeMorePage({
    super.key,
    required this.title,
    required this.seeMoreEndpoint,
    required this.contentType,
  });

  final String title;
  final String seeMoreEndpoint;
  final SeeMoreContentType contentType;

  static const String routePath = '/for-you/see-more';
  static const String routeName = 'for-you-see-more';

  @override
  State<SeeMorePage> createState() => _SeeMorePageState();
}

class _SeeMorePageState extends State<SeeMorePage> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  final Dio _dioClient = getIt<Dio>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _loadPage(int pageKey) async {
    try {
      final uri = Uri.parse(widget.seeMoreEndpoint);
      final query = Map<String, dynamic>.from(uri.queryParameters)
        ..['_page'] = '$pageKey';
      final response =
          await _dioClient.get(uri.replace(queryParameters: query).toString());
      final json = response.data as Map<String, dynamic>;

      final List<dynamic> items;
      final bool hasNext;
      final int currentPage;
      if (widget.contentType == SeeMoreContentType.residence) {
        final collection = ResidencesCollection.fromJson(json);
        items = collection.data ?? [];
        hasNext = collection.hasNext ?? false;
        currentPage = collection.currentPage ?? pageKey;
      } else {
        final collection = BienImmobilierCollection.fromJson(json);
        items = collection.data ?? [];
        hasNext = collection.hasNext ?? false;
        currentPage = collection.currentPage ?? pageKey;
      }

      if (hasNext) {
        _pagingController.appendPage(items, currentPage + 1);
      } else {
        _pagingController.appendLastPage(items);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            const SliverGap(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: PagedSliverList<int, dynamic>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  firstPageProgressIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(6, (index) => LoadProductCard()),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        'Rien à afficher ici pour le moment',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  itemBuilder: (context, item, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: UnifiedPropertyCard(item: item),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
