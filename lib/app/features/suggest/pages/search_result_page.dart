import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/suggest/pages/search_container_page.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggest_search_bar.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class SearchResultPage extends StatefulWidget {
  final String category;
  final String? search;
  final String? villeId;
  final String? communeId;
  final String displayText;

  /// Si fourni, remplace la barre de recherche par une bannière image en
  /// haut de page (ex: clic sur une pub) — aucun champ de recherche affiché.
  final String? bannerImageId;

  const SearchResultPage({
    super.key,
    required this.category,
    this.search,
    this.villeId,
    this.communeId,
    required this.displayText,
    this.bannerImageId,
  });

  static const String routeName = "search_results";
  static const String routePath = "/search-results";

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with ConnectivityMixin {
  // Paging controllers for different models
  final PagingController<int, ResidenceModel> _residencePagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, BienImmobilierModel> _estatePagingController =
      PagingController(firstPageKey: 1);

  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();
  final BienImmobilierRepository _bienImmobilierRepository =
      getIt<BienImmobilierRepository>();

  late final TextEditingController _searchController;

  static const List<Map<String, String>> _categories = [
    {'id': 'residence', 'label': 'Résidences'},
    {'id': 'location', 'label': 'Location'},
    {'id': 'bien', 'label': 'Vente'},
  ];

  late String _selectedCategory;

  /// Sous-filtre par type de bien — uniquement pour la catégorie "bien"
  /// (achat), état local à cette page (pas l'ancien `FilterHandler` global
  /// lié à la home, pour ne pas coupler les deux écrans).
  static const List<EstateSubCategory> _estateSubCategories = [
    EstateSubCategory.all,
    EstateSubCategory.villa,
    EstateSubCategory.duplex,
    EstateSubCategory.studio,
    EstateSubCategory.appartement,
    EstateSubCategory.maison,
  ];
  EstateSubCategory _selectedSubCategory = EstateSubCategory.all;

  HomeTab get _homeTab {
    return HomeTab.values.firstWhere(
      (t) => t.category == _selectedCategory,
      orElse: () => HomeTab.residence,
    );
  }

  @override
  void onConnectionRestored() {
    if (_selectedCategory == 'residence') {
      if (_residencePagingController.itemList == null ||
          _residencePagingController.itemList!.isEmpty) {
        _residencePagingController.error = 'temporary_error_to_force_refresh';
        _residencePagingController.refresh();
      }
    } else {
      if (_estatePagingController.itemList == null ||
          _estatePagingController.itemList!.isEmpty) {
        _estatePagingController.error = 'temporary_error_to_force_refresh';
        _estatePagingController.refresh();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setupConnectivityListener();
    _searchController = TextEditingController(text: widget.displayText);

    if (widget.category == 'location' || widget.category == 'bien') {
      _selectedCategory = widget.category;
    } else {
      _selectedCategory = 'residence';
    }

    _residencePagingController.addPageRequestListener(_fetchResidences);
    _estatePagingController.addPageRequestListener(_fetchEstates);
  }

  @override
  void dispose() {
    disposeConnectivityListener();
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
      showConnectionErrorDialog(error);
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

      if (_selectedCategory == 'location') {
        allFilters.add('{"_field": "aLouer", "_op": "eq", "_val": true}');
      } else if (_selectedCategory == 'bien') {
        allFilters.add('{"_field": "aLouer", "_op": "eq", "_val": false}');
        if (_selectedSubCategory != EstateSubCategory.all &&
            _selectedSubCategory.value != null) {
          allFilters.add(
              '{"_field": "typeBienImmobilier", "_op": "eq", "_val": "${_selectedSubCategory.value}"}');
        }
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
      showConnectionErrorDialog(error);
    }
  }

  void _onCategoryTabSelected(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
      _selectedSubCategory = EstateSubCategory.all;
    });
    if (category == 'residence') {
      _residencePagingController.refresh();
    } else {
      _estatePagingController.refresh();
    }
  }

  void _onSubCategoryTap(EstateSubCategory category) {
    if (category == _selectedSubCategory) return;
    setState(() => _selectedSubCategory = category);
    _estatePagingController.refresh();
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat['id'] == _selectedCategory;
          return GestureDetector(
            onTap: () => _onCategoryTabSelected(cat['id']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xffF2F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat['label']!,
                style: AppTypography.font(
                  color: isSelected ? AppColors.white : const Color(0xff333333),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstateSubCategoryTabs() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _estateSubCategories.length,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _estateSubCategories[index];
          final isSelected = item == _selectedSubCategory;
          return GestureDetector(
            onTap: () => _onSubCategoryTap(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue500 : const Color(0xffEDF1F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                item.label,
                style: AppTypography.font(
                  color: isSelected ? AppColors.white : const Color(0xff333333),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isResidence = _selectedCategory == 'residence';
    final showBanner = widget.bannerImageId?.isNotEmpty == true;
    final showEstateSubTabs = _selectedCategory == 'bien';

    final resultsList = isResidence
        ? PagedListView<int, ResidenceModel>(
            key: const ValueKey('residence_list'),
            pagingController: _residencePagingController,
            builderDelegate: PagedChildBuilderDelegate<ResidenceModel>(
              firstPageProgressIndicatorBuilder: (context) => Column(
                children: List.generate(5, (index) => LoadProductCard()),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Text(
                  'Aucun résultat trouvé pour votre recherche.',
                  style: AppTypography.font(
                      color: AppColors.immoTextSecondary, fontSize: 16),
                ),
              ),
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: UnifiedPropertyCard(item: item),
              ),
            ),
          )
        : PagedListView<int, BienImmobilierModel>(
            key: ValueKey('estate_list_$_selectedCategory'),
            pagingController: _estatePagingController,
            builderDelegate: PagedChildBuilderDelegate<BienImmobilierModel>(
              firstPageProgressIndicatorBuilder: (context) => Column(
                children: List.generate(5, (index) => LoadProductCard()),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Text(
                  'Aucun résultat trouvé pour votre recherche.',
                  style: AppTypography.font(
                      color: AppColors.immoTextSecondary, fontSize: 16),
                ),
              ),
              itemBuilder: (context, item, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: UnifiedPropertyCard(item: item),
              ),
            ),
          );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: showBanner
          ? AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: BackButton(onPressed: () => context.pop()),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: SafeArea(
                child: SuggestSearchBar(
                  controller: _searchController,
                  readOnly: true,
                  onTap: () {
                    context.pushNamed(
                      SearchContainerPage.routeName,
                      extra: {
                        'homeTab': _homeTab,
                        'lat': FilterHandler.lat,
                        'lng': FilterHandler.long,
                      },
                    );
                  },
                  showClearButton: true,
                  onClear: () => context.pop(),
                  onBackPressed: () => context.pop(),
                ),
              ),
            ),
      body: SafeArea(
        top: !showBanner,
        child: Column(
          children: [
            if (showBanner)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: Utils.getImagePath(id: widget.bannerImageId!),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (!showBanner) _buildCategoryTabs(),
            if (showEstateSubTabs) ...[
              const SizedBox(height: 4),
              _buildEstateSubCategoryTabs(),
              const SizedBox(height: 4),
            ],
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: resultsList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
