import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/data/enums/ad_type.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_bien_card.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/constants/constantes.dart';

class NearEstatesConstants {
  NearEstatesConstants._();

  /// Rayon en km pour considérer les biens comme "proches" (1 km)
  static const double defaultRadius = 1.0;

  /// Nombre maximum d'éléments à afficher dans la liste horizontale
  static const int maxItemsPreview = 10;

  /// Titre de la section
  static const String sectionTitle = 'Moins d’un km';

  /// Message d'erreur de localisation
  static const String locationErrorMessage =
      'Impossible de récupérer votre position pour voir les biens proches';
}

class EstatesNearList extends StatefulWidget {
  const EstatesNearList({
    super.key,
    this.radius = NearEstatesConstants.defaultRadius,
    this.maxItems = NearEstatesConstants.maxItemsPreview,
  });

  final double radius;
  final int maxItems;

  @override
  State<EstatesNearList> createState() => _EstatesNearListState();
}

class _EstatesNearListState extends State<EstatesNearList> {
  final BienImmobilierRepository _bienImmobilierRepository =
      getIt<BienImmobilierRepository>();

  bool _isLoading = false;
  bool _hasError = false;
  bool _locationError = false;
  bool _isDismissed = false;
  String? _errorMessage;
  List<BienImmobilierModel> _nearEstates = [];
  Position? _userPosition;

  double? _lastLat;
  double? _lastLong;
  EstateSubCategory _lastSubCategory = FilterHandler.estateSubCategory;

  @override
  void initState() {
    super.initState();
    FilterHandler.notifier.addListener(_onFilterChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permState = context.read<LocationPermissionCubit>().state;
      if (FilterHandler.lat != null || permState.isGranted) {
        _loadNearEstates();
      }
    });
  }

  void _onFilterChanged() {
    if (!mounted) return;
    final locationChanged =
        FilterHandler.lat != _lastLat || FilterHandler.long != _lastLong;
    final subCategoryChanged =
        FilterHandler.estateSubCategory != _lastSubCategory;

    _lastLat = FilterHandler.lat;
    _lastLong = FilterHandler.long;
    _lastSubCategory = FilterHandler.estateSubCategory;

    if (locationChanged || subCategoryChanged) {
      _loadNearEstates();
    }
  }

  @override
  void dispose() {
    FilterHandler.notifier.removeListener(_onFilterChanged);
    super.dispose();
  }

  Future<void> _loadNearEstates() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _locationError = false;
    });

    try {
      double? lat;
      double? long;

      if (FilterHandler.lat != null && FilterHandler.long != null) {
        lat = FilterHandler.lat;
        long = FilterHandler.long;
      } else {
        _userPosition = await LocationService.getCurrentPosition();
        lat = _userPosition?.latitude;
        long = _userPosition?.longitude;
      }

      if (lat == null || long == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final where = FilterHandler.getAllFilters(PropertyType.estate);

      final result = await _bienImmobilierRepository.getBiensLocalized(
        lat: lat,
        long: long,
        radius: widget.radius,
        perPage: 10,
        page: 1,
        where: where,
      );

      if (mounted) {
        final list = result.data ?? [];
        final estates = list.take(widget.maxItems).toList();
        setState(() {
          _nearEstates = estates;
          _isLoading = false;
        });
      }
    } on LocationException catch (e) {
      if (mounted) {
        setState(() {
          _locationError = true;
          _errorMessage = e.message;
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

  void _dismissLocationError() {
    setState(() {
      _isDismissed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading &&
        (_nearEstates.isEmpty || _hasError || _locationError || _isDismissed)) {
      return const SizedBox.shrink();
    }

    final adsState = context.watch<AdsCubit>().state;
    final nearAdMatches = adsState.maybeWhen(
      success: (list) => list
          .where((c) => c.placement == AdPlacement.propertyListAfter.value)
          .toList(),
      orElse: () => <AdCampaignModel>[],
    );
    final hasNearAd = nearAdMatches.isNotEmpty;
    final nearAdType = nearAdMatches.isNotEmpty
        ? AdType.fromString(nearAdMatches.first.type)
        : null;
    final nearAdGap = switch (nearAdType) {
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
            HomeSectionTitle(title: NearEstatesConstants.sectionTitle),
            IconButton(
              onPressed: _nearEstates.isNotEmpty
                  ? () {
                      final lat = FilterHandler.lat ?? _userPosition?.latitude;
                      final long =
                          FilterHandler.long ?? _userPosition?.longitude;
                      if (lat != null && long != null) {
                        context.push(
                          LocationBiensPage.routePath,
                          extra: {
                            'title': NearEstatesConstants.sectionTitle,
                            'lat': lat,
                            'long': long,
                            'radius': widget.radius,
                            'propertyType': PropertyType.estate,
                            'subCategory': FilterHandler.estateSubCategory,
                          },
                        );
                      }
                    }
                  : null,
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: _nearEstates.isNotEmpty
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
          height: _locationError ? null : 255,
          child: _buildContent(),
        ),
        if (!_isLoading &&
            !_hasError &&
            !_locationError &&
            _nearEstates.isNotEmpty &&
            hasNearAd) ...[
          Gap(nearAdGap),
          const AdWidget(placement: AdPlacement.propertyListAfter),
          Gap(nearAdGap),
        ] else
          const Gap(kHomeSectionSpacing),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_locationError) {
      return _buildLocationErrorState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_nearEstates.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _nearEstates.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        return CompactBienCard(bien: _nearEstates[index]);
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        return SizedBox(
          width: neirResidenceCardWidth,
          child: LoadProductCard(),
        );
      },
    );
  }

  Widget _buildLocationErrorState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off_outlined,
            color: Colors.orange.shade700,
            size: 28,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              _errorMessage ?? NearEstatesConstants.locationErrorMessage,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.orange.shade900,
                  ),
            ),
          ),
          const Gap(8),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.orange.shade700,
              size: 20,
            ),
            onPressed: _dismissLocationError,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
        ],
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
            onPressed: _loadNearEstates,
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
