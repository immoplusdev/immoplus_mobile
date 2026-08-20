import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/data/enums/ad_type.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/screens/best_rated_residences_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_residence_card.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/constants/constantes.dart';

class BestRatedResidencesConstants {
  BestRatedResidencesConstants._();

  /// Nombre maximum d'éléments à afficher dans la liste horizontale
  static const int maxItemsPreview = 10;

  /// Titre de la section
  static const String sectionTitle = 'Top Résidences';
}

class ResidencesBestRatedList extends StatefulWidget {
  const ResidencesBestRatedList({
    super.key,
    this.maxItems = BestRatedResidencesConstants.maxItemsPreview,
  });

  final int maxItems;

  @override
  State<ResidencesBestRatedList> createState() =>
      _ResidencesBestRatedListState();
}

class _ResidencesBestRatedListState extends State<ResidencesBestRatedList>
    with ConnectivityMixin {
  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  List<ResidenceModel> _bestRatedResidences = [];
  @override
  void onConnectionRestored() {
    if (_hasError) {
      _loadBestRatedResidences();
    }
  }

  @override
  void initState() {
    super.initState();
    FilterHandler.notifier.addListener(_loadBestRatedResidences);
    _loadBestRatedResidences();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    FilterHandler.notifier.removeListener(_loadBestRatedResidences);
    super.dispose();
  }

  Future<void> _loadBestRatedResidences() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Charger les résidences triées par score DESC
      final result = await _residenceRepository.getResidences(
        page: 1,
        // search: FilterHandler.search,
        orderBy: OrderByField.score.value,
        orderDir: OrderDir.desc.value,
      );

      if (mounted) {
        setState(() {
          _bestRatedResidences =
              (result.data ?? []).take(widget.maxItems).toList();
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = error.toString();
        });
        showConnectionErrorDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsState = context.watch<AdsCubit>().state;
    final bestRatedAdMatches = adsState.maybeWhen(
      success: (list) => list
          .where((c) => c.placement == AdPlacement.residenceListBestRated.value)
          .toList(),
      orElse: () => <AdCampaignModel>[],
    );
    final hasBestRatedAd = bestRatedAdMatches.isNotEmpty;
    final bestRatedAdType = bestRatedAdMatches.isNotEmpty
        ? AdType.fromString(bestRatedAdMatches.first.type)
        : null;
    final bestRatedAdGap = switch (bestRatedAdType) {
      AdType.carousel => kHomeSectionPubCarrousel,
      AdType.videoCarousel => kHomeSectionPubCarrouselVideo,
      _ => kHomeSectionSpacingPub,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: SectionTitle(
            //     title: BestRatedResidencesConstants.sectionTitle,
            //     useCalSans: true,
            //   ),
            // ),

            HomeSectionTitle(title: BestRatedResidencesConstants.sectionTitle),
            IconButton(
              onPressed: _bestRatedResidences.isNotEmpty
                  ? () {
                      context.push(BestRatedResidencesPage.routePath);
                    }
                  : null,
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: _bestRatedResidences.isNotEmpty
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          height: compactResidenceCardHeight,
          child: _buildContent(),
        ),
        if (!_isLoading &&
            !_hasError &&
            _bestRatedResidences.isNotEmpty &&
            hasBestRatedAd) ...[
          Gap(bestRatedAdGap),
          const AdWidget(placement: AdPlacement.residenceListBestRated),
          Gap(bestRatedAdGap),
        ] else
          const Gap(kHomeSectionSpacing),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      // Return shimmer as requested when there's an error
      return _buildLoadingState();
    }

    if (_bestRatedResidences.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _bestRatedResidences.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        return CompactResidenceCard(
          residence: _bestRatedResidences[index],
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildEmptyState() {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const Gap(12),
            Text(
              'Aucune résidence disponible',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
