import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/app/widgets/tickets_cards/residence_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';

class SearchResultPage extends StatefulWidget {
  final String category;
  final String? search;
  final String? villeId;
  final String? communeId;
  final String displayText;

  const SearchResultPage({
    super.key,
    required this.category,
    this.search,
    this.villeId,
    this.communeId,
    required this.displayText,
  });

  static const String routeName = "search_results";
  static const String routePath = "/search-results";

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  // Paging controllers for different models
  final PagingController<int, ResidenceModel> _residencePagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, BienImmobilierModel> _estatePagingController =
      PagingController(firstPageKey: 1);

  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();
  final BienImmobilierRepository _bienImmobilierRepository =
      getIt<BienImmobilierRepository>();

  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.displayText);
    if (widget.category == 'residence') {
      _residencePagingController.addPageRequestListener(_fetchResidences);
    } else {
      _estatePagingController.addPageRequestListener(_fetchEstates);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _residencePagingController.dispose();
    _estatePagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchResidences(int pageKey) async {
    try {
      final Map<String, dynamic> whereParams = {};
      if (widget.villeId != null) {
        whereParams['_villeId'] = widget.villeId;
      }
      if (widget.communeId != null) {
        whereParams['_communeId'] = widget.communeId;
      }

      final response = await _residenceRepository.getResidences(
        page: pageKey,
        perPage: 10,
        search: widget.search,
        where: whereParams.isNotEmpty ? whereParams : null,
      );

      final isLastPage = response.hasNext != true;
      if (isLastPage) {
        _residencePagingController.appendLastPage(response.data ?? []);
      } else {
        final nextPageKey = (response.currentPage ?? pageKey) + 1;
        _residencePagingController.appendPage(response.data ?? [], nextPageKey);
      }
    } catch (error) {
      _residencePagingController.error = error;
    }
  }

  Future<void> _fetchEstates(int pageKey) async {
    try {
      final Map<String, dynamic> whereParams = {};
      if (widget.villeId != null) {
        whereParams['_villeId'] = widget.villeId;
      }
      if (widget.communeId != null) {
        whereParams['_communeId'] = widget.communeId;
      }

      // Add default where filters according to the active tab
      final List<String> allFilters = [
        '{"_field": "bienImmobilierDisponible", "_op": "eq", "_val": true}',
        '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
      ];

      if (widget.category == 'location') {
        allFilters.add('{"_field": "aLouer", "_op": "eq", "_val": true}');
      } else if (widget.category == 'bien') {
        allFilters.add('{"_field": "aLouer", "_op": "eq", "_val": false}');
      }

      whereParams['_where'] = allFilters;

      final response = await _bienImmobilierRepository.getBiensImmobiliers(
        page: pageKey,
        perPage: 10,
        search: widget.search,
        where: whereParams,
      );

      final isLastPage = response.hasNext != true;
      if (isLastPage) {
        _estatePagingController.appendLastPage(response.data ?? []);
      } else {
        final nextPageKey = (response.currentPage ?? pageKey) + 1;
        _estatePagingController.appendPage(response.data ?? [], nextPageKey);
      }
    } catch (error) {
      _estatePagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResidence = widget.category == 'residence';

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
            size: 22,
          ),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () => context.pop(), // Go back to search suggestions page
          child: AbsorbPointer(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 48,
                child: CustomTextField(
                  readOnly: true,
                  bottomPadding: 0,
                  controller: _searchController,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  prefixIcon: const Icon(
                    Iconsax.search_normal_1,
                    color: Colors.black,
                    size: 18,
                  ),
                  sufixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.cancel,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: isResidence
              ? PagedListView<int, ResidenceModel>(
                  pagingController: _residencePagingController,
                  builderDelegate: PagedChildBuilderDelegate<ResidenceModel>(
                    firstPageProgressIndicatorBuilder: (context) => Column(
                      children: List.generate(5, (index) => LoadProductCard()),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'Aucun résultat trouvé pour votre recherche.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ResidenceCard(residence: item),
                    ),
                  ),
                )
              : PagedListView<int, BienImmobilierModel>(
                  pagingController: _estatePagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<BienImmobilierModel>(
                    firstPageProgressIndicatorBuilder: (context) => Column(
                      children: List.generate(5, (index) => LoadProductCard()),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'Aucun résultat trouvé pour votre recherche.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: EstateCard(bienImmobilierModel: item),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
