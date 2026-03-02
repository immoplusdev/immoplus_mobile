import 'dart:developer';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/home_page/components/home_choice_menu.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/features/filter/filter_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/widgets/custom_text_field.dart';
import 'package:immoplus/gen/assets.gen.dart';

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
          _currentAddress = "Position indisponible";
          _isLoadingAddress = false;
        });
      }
      log('Erreur de localisation: ${e.message}');
    } catch (e) {
      // Autres erreurs
      if (mounted) {
        setState(() {
          _currentAddress = "Position indisponible";
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
      enableDrag: false,
      showDragHandle: true,
      backgroundColor: AppColors.whiteBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) =>
          const FractionallySizedBox(heightFactor: 0.9, child: LocationPage()),
    ).then((value) {
      inspect(value);
      if (value is Address) {
        setState(() {
          FilterHandler.locationName = value.description!.length > 20
              ? '${value.description!.substring(0, 20)}…'
              : value.description;
          FilterHandler.lat = value.latitude;
          FilterHandler.long = value.longitude;
        });
        FilterHandler.notifyChange();
        HomePageState.pagingControllerResidence.refresh();
        HomePageState.pagingControllerEstate.refresh();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    EasyDebounce.cancel(_searchDebounceKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterHandler>(
      builder: (context, state) {
        return SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          snap: false,
          floating: true,
          titleSpacing: 0,
          toolbarHeight: 125,
          backgroundColor: AppColors.whiteBackground,
          title: Container(
            color: AppColors.whiteBackground,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.img.locIc,
                      color: AppColors.primary,
                    ),
                    Gap(5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      constraints: BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(39),
                      ),
                      child: _isLoadingAddress
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : Text(
                              _currentAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.whiteBackground,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.88,
                            child: const FilterPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.F2F2F2,
                        ),
                        child: Icon(Icons.tune_rounded, color: AppColors.primary),
                      ),
                    ),
                    const Gap(8),
                    GestureDetector(
                      onTap: () {
                        if (sessionManager.currentUser != null) {
                          context.pushNamed(NotificationsPage.name);
                        } else {
                          context.pushNamed(AuthenticationPage.name);
                        }
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.F2F2F2,
                        ),
                        child: Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                  ],
                ),
                Gap(10),
                SizedBox(
                  height: 50,
                  child: CustomTextField(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Que cherchez-vous ?',
                    prefixIcon: Icon(Icons.search),
                    controller: _searchController,
                    sufixIcon: _showClearButton
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            onPressed: () {
                              EasyDebounce.cancel(_searchDebounceKey);
                              _searchController.clear();
                              FilterHandler.search = null;
                              FilterHandler.notifyChange();
                              HomePageState.getPageListController(
                                widget.currentIndex,
                              ).refresh();
                            },
                          )
                        : null,
                    onFieldSubmitted: (keyword) {
                      if (FilterHandler.search != null) {
                        if (FilterHandler.search!.isNotEmpty) {
                          log(keyword);
                          HomePageState.getPageListController(
                            widget.currentIndex,
                          ).refresh();
                        } else {
                          FilterHandler.search = null;
                          FilterHandler.notifyChange();
                          HomePageState.getPageListController(
                            widget.currentIndex,
                          ).refresh();
                        }
                      }
                    },
                    onChanged: (text) {
                      EasyDebounce.debounce(
                        _searchDebounceKey,
                        const Duration(milliseconds: _searchDeboucemillisecond),
                        () {
                          FilterHandler.search = text;
                          FilterHandler.notifyChange();
                          if (FilterHandler.search != null) {
                            if (FilterHandler.search!.isNotEmpty) {
                              log(text);
                              HomePageState.getPageListController(
                                widget.currentIndex,
                              ).refresh();
                            } else {
                              FilterHandler.search = null;
                              FilterHandler.notifyChange();
                              HomePageState.getPageListController(
                                widget.currentIndex,
                              ).refresh();
                            }
                          }
                        },
                      );
                    },
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusButton),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radiusButton),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: HomeChoiceMenu(),
          ),
        );
      },
    );
  }
}
