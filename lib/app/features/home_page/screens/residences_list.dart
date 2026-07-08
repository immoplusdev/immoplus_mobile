import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_state.dart';
import 'package:immoplus/app/features/home_page/screens/residences_best_rated_list.dart';
import 'package:immoplus/app/features/home_page/screens/residences_near_list.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/utils/PromoCarrousel/promo_carousel_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_residence_card.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/features/home_page/screens/location_residences_page.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class ResidencesList extends StatefulWidget {
  const ResidencesList({super.key});

  @override
  State<ResidencesList> createState() => _ResidencesListState();
}

class _ResidencesListState extends State<ResidencesList> {
  void _onPageRequest(int pageKey) => loadPage(pageKey);

  Future<void> loadPage(int page) async {
    final myToken = HomePageState.residenceToken;

    // utiliser le token pour invalider les requêtes périmées
    // si le token est différent, la requête est périmée et on ne la charge pas
    // cela permet d`eviter d`avoir des requêtes périmées en arrière-plan
    // qui rendent la liste de résidences invalide et vide
    final whereFilters = FilterHandler.getAllFilters(PropertyType.residence);
    final residenceRepository = getIt<ResidenceRepository>();
    try {
      final value = await residenceRepository.getResidences(
        search: FilterHandler.search,
        lat: FilterHandler.lat,
        long: FilterHandler.long,
        startDate: FilterHandler.startDate,
        endDate: FilterHandler.endDate,
        // radius: (FilterHandler.lat != null) ? 100 : null,
        where: whereFilters,
        page: page,
      );
      if (myToken != HomePageState.residenceToken) return;
      if (value.hasNext == true) {
        HomePageState.pagingControllerResidence
            .appendPage(value.data ?? [], (value.currentPage)! + 1);
      } else {
        HomePageState.pagingControllerResidence
            .appendLastPage(value.data ?? []);
      }
    } catch (error) {
      if (myToken != HomePageState.residenceToken) return;
      HomePageState.pagingControllerResidence.error = error.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    HomePageState.pagingControllerResidence
        .addPageRequestListener(_onPageRequest);
    HomePageState.refreshResidences();
  }

  @override
  void dispose() {
    HomePageState.pagingControllerResidence
        .removePageRequestListener(_onPageRequest);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
          builder: (context, permissionState) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: FilterHandler.notifier,
                      builder: (context, _, __) {
                        if (FilterHandler.search != null &&
                            FilterHandler.search!.isNotEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (permissionState.isGranted)
                              const ResidencesNearList(),
                            const ResidencesBestRatedList(),
                          ],
                        );
                      },
                    ),
                    // const HomeSectionTitle(title: "Ce qu'il vous faut"),
                    // const Gap(13),
                  ],
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _residencesHomeItems[index];
                if (item.isHeader) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 12),
                    child: Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                } else {
                  return ResidencesHorizontalListByLocation(
                    key: ValueKey(
                        'location_residences_${item.villeId ?? item.communeId}'),
                    title: item.title,
                    villeId: item.villeId,
                    communeId: item.communeId,
                  );
                }
              },
              childCount: _residencesHomeItems.length,
            ),
          ),
        ),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12),
        //   sliver: PagedSliverList<int, ResidenceModel>(
        //     pagingController: HomePageState.pagingControllerResidence,
        //     builderDelegate: PagedChildBuilderDelegate(
        //       firstPageProgressIndicatorBuilder: (context) => Padding(
        //         padding: const EdgeInsets.all(10),
        //         child: SizedBox(
        //           child: Column(
        //             children: List.generate(
        //               10,
        //               (index) => LoadProductCard(),
        //             ),
        //           ),
        //         ),
        //       ),
        //       noItemsFoundIndicatorBuilder: (context) => Center(
        //         child: Text(
        //           "Aucun élément trouvé",
        //           style: Theme.of(context).textTheme.titleLarge,
        //         ),
        //       ),
        //       itemBuilder: (context, item, index) => Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 1)
        //             .copyWith(bottom: 13),
        //         child: UnifiedPropertyCard(
        //           item: item,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ResidencesHomeListItem {
  final String title;
  final String? villeId;
  final String? communeId;
  final bool isHeader;

  const ResidencesHomeListItem({
    required this.title,
    this.villeId,
    this.communeId,
    this.isHeader = false,
  });
}

final List<ResidencesHomeListItem> _residencesHomeItems = [
  // --- Section 1 : Villes populaires ---
  const ResidencesHomeListItem(title: "VILLES POPULAIRES", isHeader: true),
  const ResidencesHomeListItem(
      title: "Grand-Bassam", villeId: "8b981ba8-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Yamoussoukro", villeId: "8b97d0b3-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "San-Pédro", villeId: "8b97ea35-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 2 : Communes d'Abidjan ---
  const ResidencesHomeListItem(title: "COMMUNES D'ABIDJAN", isHeader: true),
  const ResidencesHomeListItem(
      title: "Abobo", communeId: "8bb4b211-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Adjamé", communeId: "55a42f68-2867-11f1-a056-661ac3bf2f34"),
  const ResidencesHomeListItem(
      title: "Attécoubé", communeId: "8bb4d4d0-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Cocody", communeId: "8bb446ea-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Koumassi", communeId: "8bb4b588-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Marcory", communeId: "8bb498f3-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Plateau (Le Plateau)",
      communeId: "8bb48973-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Port-Bouët", communeId: "8bb4c15a-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Treichville", communeId: "8bb4a496-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Yopougon", communeId: "8bb47716-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Anyama (Commune)",
      communeId: "567aa860-2867-11f1-a056-661ac3bf2f34"),
  const ResidencesHomeListItem(
      title: "Bingerville", communeId: "8bb68343-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bonoua", communeId: "8bb80dca-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 3 : Villes extérieures ---
  const ResidencesHomeListItem(title: "VILLES EXTÉRIEURES", isHeader: true),
  const ResidencesHomeListItem(
      title: "Abengourou", villeId: "8b980686-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Adzopé", villeId: "8b981bef-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Agboville", villeId: "8b981b46-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bondoukou", villeId: "8b980e6a-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Bouaké", villeId: "8b97dccc-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Daloa", villeId: "8b97e49c-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Divo", villeId: "8b97f856-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Ferkessédougou", villeId: "8b980eb7-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Gagnoa", villeId: "8b97f23e-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Issia", villeId: "8b981c4e-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Korhogo", villeId: "8b97ea95-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Man", villeId: "8b97f0aa-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Odienné", villeId: "8b9814b6-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Séguéla", villeId: "8b981507-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Soubré", villeId: "8b980dd8-a507-11ef-8b44-0e595bc2ce41"),
  const ResidencesHomeListItem(
      title: "Toumodi", villeId: "8b981aa6-a507-11ef-8b44-0e595bc2ce41"),
];

class ResidencesHorizontalListByLocation extends StatefulWidget {
  final String title;
  final String? villeId;
  final String? communeId;

  const ResidencesHorizontalListByLocation({
    super.key,
    required this.title,
    this.villeId,
    this.communeId,
  });

  @override
  State<ResidencesHorizontalListByLocation> createState() =>
      _ResidencesHorizontalListByLocationState();
}

class _ResidencesHorizontalListByLocationState
    extends State<ResidencesHorizontalListByLocation> {
  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  List<ResidenceModel> _residences = [];

  @override
  void initState() {
    super.initState();
    _loadResidences();
  }

  Future<void> _loadResidences() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final Map<String, dynamic> where = {};
      if (widget.villeId != null) {
        where['_villeId'] = widget.villeId;
      }
      if (widget.communeId != null) {
        where['_communeId'] = widget.communeId;
      }

      final result = await _residenceRepository.getResidences(
        page: 1,
        perPage: 10,
        where: where,
      );

      if (mounted) {
        setState(() {
          _residences = result.data ?? [];
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si en cours de chargement et pas encore de données, hauteur 0 pour éviter les sauts de scroll
    if (_isLoading && _residences.isEmpty) {
      return const SizedBox.shrink();
    }

    // Si pas de données après chargement, hauteur 0
    if (!_isLoading && !_hasError && _residences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeSectionTitle(title: widget.title),
            TextButton(
              onPressed: _residences.isNotEmpty
                  ? () {
                      context.push(
                        LocationResidencesPage.routePath,
                        extra: {
                          'title': widget.title,
                          'villeId': widget.villeId,
                          'communeId': widget.communeId,
                        },
                      );
                    }
                  : null,
              child: Text(
                'Voir plus',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 255,
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _residences.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        return CompactResidenceCard(
          residence: _residences[index],
          showRating: false,
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const Gap(12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: neirResidenceCardWidth,
            child: LoadProductCard(),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
          ),
          const Gap(6),
          Text(
            _errorMessage ?? 'Une erreur est survenue',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.red.shade600,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(12),
          TextButton(
            onPressed: _loadResidences,
            child: Text(
              'Réessayer',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class AppPrimaryColors {
  // Couleur principale
  static const Color primary = kPrimaryColor;

  // Variantes plus claires
  static const Color primary50 = Color(0xffEEF1FC); // Très clair (backgrounds)
  static const Color primary100 = Color(0xffC5CFF5); // Clair
  static const Color primary200 = Color(0xff9BADEF); //
  static const Color primary300 = Color(0xff6B85E6); //
  static const Color primary400 = Color(0xff4A64E2); // Légèrement plus clair

  // Variantes plus foncées
  static const Color primary600 = Color(0xff1E35B8); // Plus foncé
  static const Color primary700 = Color(0xff182A92); // Foncé
  static const Color primary800 = Color(0xff121F6C); // Très foncé
  static const Color primary900 = Color(0xff0C1446); // Extra foncé
}
// class _PromoSection extends StatelessWidget {
//   const _PromoSection();

//   static const List<PromoCardData> _promoItems = [
//     PromoCardData(backgroundImage: 'assets/promo/promo_1.JPG'),
//     PromoCardData(backgroundImage: 'assets/promo/promo_2.JPG'),
//     PromoCardData(backgroundImage: 'assets/promo/promo_3.JPG'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return PromoCarousel(
//       items: _promoItems,
//       cardWidth: 300,
//       cardHeight: 325,
//       spacing: 12,
//     );
//   }
// }
