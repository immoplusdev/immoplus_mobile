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
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/screens/near_residences_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/empty_state_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/compact_residence_card.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/constants/constantes.dart';

class NearResidencesConstants {
  NearResidencesConstants._();

  /// Rayon en km pour considérer les résidences comme "proches"
  static const double defaultRadius = 10.0;

  /// Nombre maximum d'éléments à afficher dans la liste horizontale
  static const int maxItemsPreview = 10;

  /// Titre de la section
  static const String sectionTitle = 'Moins d’un km';

  /// Message d'erreur de localisation
  static const String locationErrorMessage =
      'Impossible de récupérer votre position pour voir les résidences proches';
}

class ResidencesNearList extends StatefulWidget {
  const ResidencesNearList({
    super.key,
    this.radius = NearResidencesConstants.defaultRadius,
    this.maxItems = NearResidencesConstants.maxItemsPreview,
  });

  final double radius;
  final int maxItems;

  @override
  State<ResidencesNearList> createState() => _ResidencesNearListState();
}

class _ResidencesNearListState extends State<ResidencesNearList> {
  final ResidenceRepository _residenceRepository = getIt<ResidenceRepository>();

  bool _isLoading = false;
  bool _hasError = false;
  bool _locationError = false;
  bool _isDismissed = false;
  String? _errorMessage;
  List<ResidenceModel> _nearResidences = [];
  Position? _userPosition;

  // Dernières valeurs lat/long connues pour détecter un vrai changement de localisation
  double? _lastLat;
  double? _lastLong;

  @override
  void initState() {
    super.initState();
    FilterHandler.notifier.addListener(_onLocationChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permState = context.read<LocationPermissionCubit>().state;
      if (FilterHandler.lat != null || permState.isGranted) {
        _loadNearResidences();
      }
    });
  }

  void _onLocationChanged() {
    if (!mounted) return;
    final locationChanged =
        FilterHandler.lat != _lastLat || FilterHandler.long != _lastLong;
    _lastLat = FilterHandler.lat;
    _lastLong = FilterHandler.long;
    _loadNearResidences(showModalIfEmpty: locationChanged);
  }

  @override
  void dispose() {
    FilterHandler.notifier.removeListener(_onLocationChanged);
    super.dispose();
  }

  Future<void> _loadNearResidences({bool showModalIfEmpty = false}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _locationError = false;
    });

    try {
      double? lat;
      double? long;

      // Priorité : position sélectionnée par l'utilisateur via le bouton
      if (FilterHandler.lat != null && FilterHandler.long != null) {
        lat = FilterHandler.lat;
        long = FilterHandler.long;
      } else {
        // Fallback : position GPS
        _userPosition = await LocationService.getCurrentPosition();
        lat = _userPosition?.latitude;
        long = _userPosition?.longitude;
      }

      // Charger les résidences proches
      final result = await _residenceRepository.getResidences(
        lat: lat,
        long: long,
        radius: widget.radius,
        // search: FilterHandler.search,
        page: 1,
      );

      if (mounted) {
        final residences = (result.data ?? []).take(widget.maxItems).toList();
        setState(() {
          _nearResidences = residences;
          _isLoading = false;
        });
        if (residences.isEmpty && showModalIfEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              EmptyStateCard.showAsModal(
                context,
                imagePath: 'assets/img/modal/image.png',
                title: 'Faibles résidences à proximité',
                subtitle:
                    'Explorez les résidences les mieux notées pour plus de choix',
                autoDismissDuration: const Duration(seconds: 3),
              );
            }
          });
        }
      }
    } on LocationException catch (e) {
      // Gestion propre des exceptions de localisation
      if (mounted) {
        setState(() {
          _locationError = true;
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (error) {
      // Autres erreurs (API, réseau, etc.)
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
    // Masquer toute la section si pas de résidences proches (ou erreur)
    if (!_isLoading &&
        (_nearResidences.isEmpty ||
            _hasError ||
            _locationError ||
            _isDismissed)) {
      return const SizedBox.shrink();
    }

    final adsState = context.watch<AdsCubit>().state;
    final nearAdMatches = adsState.maybeWhen(
      success: (list) => list
          .where((c) => c.placement == AdPlacement.residenceListNear.value)
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
            HomeSectionTitle(title: NearResidencesConstants.sectionTitle),
            IconButton(
              onPressed: _nearResidences.isNotEmpty
                  ? () {
                      final lat = FilterHandler.lat ?? _userPosition?.latitude;
                      final long =
                          FilterHandler.long ?? _userPosition?.longitude;
                      if (lat != null && long != null) {
                        context.push(NearResidencesPage.routePath, extra: {
                          'lat': lat,
                          'long': long,
                          'radius': widget.radius,
                        });
                      }
                    }
                  : null,
              icon: Icon(
                Iconsax.arrow_right_1,
                size: 20,
                color: _nearResidences.isNotEmpty
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
          height: _locationError ? null : compactResidenceCardHeight,
          child: _buildContent(),
        ),
        if (!_isLoading &&
            !_hasError &&
            !_locationError &&
            _nearResidences.isNotEmpty &&
            hasNearAd) ...[
          Gap(nearAdGap),
          const AdWidget(placement: AdPlacement.residenceListNear),
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

    if (_nearResidences.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _nearResidences.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        return CompactResidenceCard(
          residence: _nearResidences[index],
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
              _errorMessage ?? NearResidencesConstants.locationErrorMessage,
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
              Icons.home_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const Gap(12),
            Text(
              'Aucune résidence proche',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
            ),
            const Gap(6),
            Text(
              'Aucune résidence trouvée dans un rayon de ${widget.radius.toInt()} km',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
            onPressed: _loadNearResidences,
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
