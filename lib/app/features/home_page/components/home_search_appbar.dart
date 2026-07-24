import 'dart:async';
import 'dart:developer';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';

import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/features/home_page/components/home_choice_menu.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/features/filter/filter_page.dart';
import 'package:immoplus/app/widgets/notification_bell.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/logic/banners/banners_cubit.dart';
import 'package:immoplus/app/logic/banners/banners_state.dart';
import 'package:immoplus/app/features/home_page/components/banner_card.dart';

import 'package:immoplus/gen/assets.gen.dart';
import 'package:immoplus/app/features/home_page/components/home_search_field.dart';

class HomeSearchAppbar extends StatefulWidget {
  const HomeSearchAppbar({
    super.key,
    required this.controller,
    required this.currentIndex,
  });
  final TabController controller;
  final int currentIndex;
  @override
  State<HomeSearchAppbar> createState() => _HomeSearchAppbarState();
}

class _HomeSearchAppbarState extends State<HomeSearchAppbar> {
  final double iconSize = 28;
  String _currentAddress = "Localisation...";
  bool _isLoadingAddress = true;
  bool _isBannerDismissed = false;
  final sessionManager = getIt<SessionManager>();

  /// ✅ Utiliser LocationService
  Future<void> _loadCurrentLocation() async {
    try {
      // Vérifier si on a déjà une position dans FilterHandler
      if (FilterHandler.locationName != null) {
        setState(() {
          _currentAddress = FilterHandler.locationName!;
          _isLoadingAddress = false;
        });
        return;
      }

      // ✅ Utiliser votre LocationService
      final position = await LocationService.getCurrentPosition();

      // ✅ Utiliser la nouvelle méthode pour obtenir l'adresse formatée
      final address = await LocationService.getFormattedAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        maxLength: 25,
      );

      if (mounted) {
        setState(() {
          _currentAddress = address;
          _isLoadingAddress = false;
        });
      }
    } on LocationException catch (e) {
      // ✅ Gérer vos exceptions personnalisées
      if (mounted) {
        setState(() {
          _currentAddress = "Partager ma position";
          _isLoadingAddress = false;
        });
      }
      log('Erreur de localisation: ${e.message}');
    } catch (e) {
      // Autres erreurs
      if (mounted) {
        setState(() {
          _currentAddress = "Partager ma position";
          _isLoadingAddress = false;
        });
      }
      log('Erreur de localisation: $e');
    }
  }

  onSelectPlace() {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.88,
        child: LocationPage(),
      ),
    ).then((value) {
      // S'assurer que tout indicateur de chargement résiduel est effacé
      EasyLoading.dismiss();
      if (value is Address) {
        final name = value.description != null && value.description!.length > 20
            ? '${value.description!.substring(0, 20)}…'
            : value.description;
        setState(() {
          FilterHandler.locationName = name;
          FilterHandler.lat = value.latitude;
          FilterHandler.long = value.longitude;
          _currentAddress = name ?? _currentAddress;
        });
        // Notifier seulement la section "À Deux Pas" — pas la liste principale
        FilterHandler.notifyChange();
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;
  static const String _searchDebounceKey = 'search_home';
  static const int _searchDeboucemillisecond = 400;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
    FilterHandler.notifier.addListener(_onFilterChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final cubit = context.read<LocationPermissionCubit>();
      if (cubit.state.isGranted) {
        await _loadCurrentLocation();
      }
      // Fetch banners
      context.read<BannersCubit>().fetchBanners();
    });
  }

  @override
  void didUpdateWidget(HomeSearchAppbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _searchController.clear();
      EasyDebounce.cancel(_searchDebounceKey);
      FilterHandler.search = null;
      FilterHandler.notifyChange();
      FocusScope.of(context).unfocus();
    }
  }

  // Réagir aux changements externes de FilterHandler (ex: suppression du chip)
  void _onFilterChanged() {
    if (FilterHandler.search == null) {
      if (_searchController.text.isNotEmpty) {
        EasyDebounce.cancel(_searchDebounceKey);
        _searchController.clear();
        HomePageState.refreshPage(widget.currentIndex);
      }
    } else {
      if (_searchController.text != FilterHandler.search) {
        _searchController.text = FilterHandler.search!;
      }
    }
  }

  @override
  void dispose() {
    FilterHandler.notifier.removeListener(_onFilterChanged);
    _searchController.dispose();
    EasyDebounce.cancel(_searchDebounceKey);
    super.dispose();
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteBackground,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: const FilterPage(),
      ),
    );
  }

  Widget _buildLocationText(
      BuildContext context, LocationPermissionState state) {
    return state.when(
      initial: () => Text(
        'Activer ma position',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
      ),
      checking: () => Text(
        'Activer ma position',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
      ),
      granted: () => _isLoadingAddress
          ? SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Text(
              _currentAddress,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
      denied: () => Text(
        'Activez votre localisation',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
      ),
      permanentlyDenied: () => Text(
        'Activez votre localisation',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
      ),
      notDetermined: () => Text(
        'Activer ma position',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  void _handleLocationTap(BuildContext context, LocationPermissionState state) {
    state.when(
      initial: () {},
      checking: () {},
      granted: () => onSelectPlace(),
      denied: () => _showPermissionDeniedModal(context, isPermanent: false),
      permanentlyDenied: () =>
          _showPermissionDeniedModal(context, isPermanent: true),
      notDetermined: () => _requestLocationPermission(context),
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    final cubit = context.read<LocationPermissionCubit>();
    await cubit.requestPermission();
    // BlocListener handles loading the address on state transition to granted
  }

  void _showPermissionDeniedModal(BuildContext context,
      {required bool isPermanent}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            Gap(12),
            Expanded(
              child: Text(
                'Autorisation de localisation',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        content: Text(
          isPermanent
              ? 'Pour accéder aux résidences à proximité, vous devez autoriser l\'accès à votre localisation dans les paramètres de l\'application.'
              : 'Activez votre localisation pour accéder à cette section.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          CustomButtom(
            onClick: () async {
              Navigator.pop(context);
              if (isPermanent) {
                await openAppSettings();
              } else {
                await _requestLocationPermission(context);
              }
            },
            child: Text(
              'Activer maintenant',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Filtres de sous-catégorie désactivés pour tous les onglets : Locations,
  // Biens et Meubles utilisent désormais la disposition par ville (comme
  // Résidences).
  //
  // Ancienne pastille de filtre par sous-catégorie (Tous, Appartement, ...),
  // conservée pour référence / réactivation éventuelle.
  // Widget _buildSubCategoryTabsOld() {
  //   final isFurniture = widget.currentIndex == 2;
  //   final items =
  //       isFurniture ? FurnitureSubCategory.values : EstateSubCategory.values;
  //
  //   final selectedValue = isFurniture
  //       ? FilterHandler.furnitureSubCategory
  //       : FilterHandler.estateSubCategory;
  //
  //   return Container(
  //     height: 30,
  //     width: double.infinity,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       itemCount: items.length,
  //       separatorBuilder: (context, index) => const SizedBox(width: 20),
  //       itemBuilder: (context, index) {
  //         final item = items[index];
  //         final isSelected = selectedValue == item;
  //         final label = isFurniture
  //             ? (item as FurnitureSubCategory).label
  //             : (item as EstateSubCategory).label;
  //
  //         return GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               if (isFurniture) {
  //                 FilterHandler.furnitureSubCategory =
  //                     item as FurnitureSubCategory;
  //               } else {
  //                 FilterHandler.estateSubCategory = item as EstateSubCategory;
  //               }
  //             });
  //             FilterHandler.notifyChange();
  //             HomePageState.refreshPage(widget.currentIndex);
  //           },
  //           child: Container(
  //             alignment: Alignment.center,
  //             padding: const EdgeInsets.only(bottom: 8),
  //             decoration: BoxDecoration(
  //               border: isSelected
  //                   ? Border(
  //                       bottom: BorderSide(
  //                         color: AppColors.primary,
  //                         width: 2,
  //                       ),
  //                     )
  //                   : null,
  //             ),
  //             child: Text(
  //               label,
  //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                     color:
  //                         isSelected ? AppColors.primary : Colors.grey.shade600,
  //                     fontWeight:
  //                         isSelected ? FontWeight.w600 : FontWeight.w500,
  //                   ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationPermissionCubit, LocationPermissionState>(
      listenWhen: (previous, current) =>
          !previous.isGranted && current.isGranted,
      listener: (context, state) async {
        setState(() {
          _isLoadingAddress = true;
        });
        await _loadCurrentLocation();
      },
      child: BlocBuilder<FilterCubit, FilterHandler>(
        builder: (context, filterState) {
          final isFurnitureTab = widget.currentIndex == HomeTab.furniture.value;

          final searchField = HomeSearchField(
            isFurnitureTab: isFurnitureTab,
            currentIndex: widget.currentIndex,
            searchController: _searchController,
            showClearButton: _showClearButton,
            onClear: () {
              _searchController.clear();
              EasyDebounce.cancel(_searchDebounceKey);
              FilterHandler.search = null;
              FilterHandler.notifyChange();
              HomePageState.refreshPage(widget.currentIndex);
            },
            onFilterPressed: _showFilterDialog,
            onFieldSubmitted: (keyword) {
              if (FilterHandler.search != null) {
                if (FilterHandler.search!.isNotEmpty) {
                  log(keyword);
                  getIt<AnalyticsService>().logSearch(
                    searchTerm: keyword,
                    searchLocation: FilterHandler.locationName,
                    searchType: switch (widget.currentIndex) {
                      1 => 'estate',
                      2 => 'furniture',
                      _ => 'residence',
                    },
                  );
                  HomePageState.refreshPage(widget.currentIndex);
                } else {
                  FilterHandler.search = null;
                  FilterHandler.notifyChange();
                  HomePageState.refreshPage(widget.currentIndex);
                }
              }
            },
            onChanged: (text) {
              EasyDebounce.debounce(
                _searchDebounceKey,
                const Duration(milliseconds: _searchDeboucemillisecond),
                () {
                  final search = text.isNotEmpty ? text : null;
                  FilterHandler.search = search;
                  FilterHandler.notifyChange();
                  if (search != null) log(text);
                  HomePageState.refreshPage(widget.currentIndex);
                },
              );
            },
          );

          return BlocBuilder<BannersCubit, BannersState>(
            builder: (context, bannerState) {
              final apiBanners = bannerState.maybeWhen(
                success: (banners) => banners,
                orElse: () => <BannerModel>[],
              );

              final hasVisibleBanners =
                  apiBanners.isNotEmpty && !_isBannerDismissed;

              return SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                snap: false,
                floating: true,
                titleSpacing: 0,
                toolbarHeight: hasVisibleBanners
                    ? _Constants.toolbarHeightWithBanner
                    : _Constants.toolbarHeightWithoutBanner,
                backgroundColor: AppColors.white,
                title: Container(
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            BlocBuilder<LocationPermissionCubit,
                                LocationPermissionState>(
                              builder: (context, permissionState) {
                                return GestureDetector(
                                  onTap: () => _handleLocationTap(
                                      context, permissionState),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.img.locIc,
                                        color: AppColors.primary,
                                      ),
                                      const Gap(5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        constraints:
                                            const BoxConstraints(maxWidth: 200),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(39),
                                        ),
                                        child: _buildLocationText(
                                            context, permissionState),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Spacer(),
                            const NotificationBell(),
                          ],
                        ),
                      ),
                      const Gap(14),
                      BannerCard(
                        onDismiss: () {
                          setState(() {
                            _isBannerDismissed = true;
                          });
                          context.read<BannersCubit>().setDismissed(true);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            15, hasVisibleBanners ? 12 : 0, 15, 0),
                        child: searchField,
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeChoiceMenu(),
                      // Pastille de filtre par sous-catégorie désactivée pour
                      // tous les onglets (disposition par ville partout).
                      // const Gap(15),
                      // _buildSubCategoryTabs(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Constants {
  static const double toolbarHeightWithBanner = 210;
  static const double toolbarHeightWithoutBanner = 138;
}
