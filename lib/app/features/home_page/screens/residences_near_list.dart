import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/screens/near_residences_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/section_title.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/near_residence_card.dart';

class NearResidencesConstants {
  NearResidencesConstants._();

  /// Rayon en km pour considérer les résidences comme "proches"
  static const double defaultRadius = 10.0;

  /// Nombre maximum d'éléments à afficher dans la liste horizontale
  static const int maxItemsPreview = 10;

  /// Titre de la section
  static const String sectionTitle = 'À Deux Pas de Vous';

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

  bool _isLoading = true;
  bool _hasError = false;
  bool _locationError = false;
  bool _isDismissed = false;
  String? _errorMessage;
  List<ResidenceModel> _nearResidences = [];
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _loadNearResidences();
  }

  Future<void> _loadNearResidences() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _locationError = false;
    });

    try {
      // Récupérer la position de l'utilisateur
      _userPosition = await LocationService.getCurrentPosition();

      // Charger les résidences proches
      final result = await _residenceRepository.getResidences(
        lat: _userPosition?.latitude,
        long: _userPosition?.longitude,
        radius: widget.radius,
        page: 1,
      );

      if (mounted) {
        setState(() {
          _nearResidences = (result.data ?? []).take(widget.maxItems).toList();
          _isLoading = false;
        });
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
    // Ne rien afficher si le message d'erreur a été fermé
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SectionTitle(
                title: NearResidencesConstants.sectionTitle,
              ),
            ),
            TextButton(
              onPressed: _userPosition != null && _nearResidences.isNotEmpty
                  ? () {
                      context.push(NearResidencesPage.routePath, extra: {
                        'lat': _userPosition!.latitude,
                        'long': _userPosition!.longitude,
                        'radius': widget.radius,
                      });
                    }
                  : null,
              child: Text(
                'Voir tout',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _userPosition != null && _nearResidences.isNotEmpty
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: _locationError ? null : 170,
          child: _buildContent(),
        ),
        const Gap(15),
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
        return NearResidenceCard(
          residence: _nearResidences[index],
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
