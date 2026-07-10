import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_model.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotels_collection.dart';
import 'package:immoplus/app/data/repositories/hotel_repository.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_search_result_page.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_card.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_card_sponsorise.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_destination_search_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/notification_bell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeListItem {
  final String title;
  final String? villeId;
  final String? communeId;
  final bool isHeader;

  const HomeListItem({
    required this.title,
    this.villeId,
    this.communeId,
    this.isHeader = false,
  });
}

final List<HomeListItem> _homeItems = [
  const HomeListItem(
      title: "Abidjan", villeId: "8b97b9ce-a507-11ef-8b44-0e595bc2ce41"),
];

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  static const String routePath = '/hotels';
  static const String name = 'hotel_search';

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage>
    with SingleTickerProviderStateMixin {
  final _destinationController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;

  late Future<HotelsCollection> _closestHotelsFuture;
  late Future<HotelsCollection> _sponsoredHotelsFuture;
  final Map<String, Future<HotelsCollection>> _cityHotelsFutures = {};
  List<Map<String, dynamic>> _recentSearches = [];
  bool _recentSearchesVisible = true;

  final _sessionManager = getIt<SessionManager>();

  // Animation controller for dismissing recent searches section
  late AnimationController _hideAnimController;
  late Animation<double> _hideAnimation;

  @override
  void initState() {
    super.initState();
    _hideAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _hideAnimation = CurvedAnimation(
      parent: _hideAnimController,
      curve: Curves.easeInOut,
    );
    _loadRecentSearches();
    _initFutures();
    _fetchUserLocationAndRefresh();
  }

  void _initFutures() {
    final repo = getIt<HotelRepository>();
    _closestHotelsFuture =
        repo.getHotels(lat: 5.3568, long: -3.9246, radius: 10).catchError((e) {
      debugPrint('Closest hotels load failure: $e');
      return HotelsCollection(data: []);
    });
    _sponsoredHotelsFuture = repo.getHotels(isSponsored: true).catchError((e) {
      debugPrint('Sponsored hotels load failure: $e');
      return HotelsCollection(data: []);
    });

    final cities = _homeItems
        .where((item) => !item.isHeader && item.villeId != null)
        .toList();
    for (var city in cities) {
      _cityHotelsFutures[city.title] =
          repo.getHotels(villeId: city.villeId).catchError((e) {
        debugPrint('Hotels load failure for city ${city.title}: $e');
        return HotelsCollection(data: []);
      });
    }
  }

  Future<void> _fetchUserLocationAndRefresh() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _closestHotelsFuture = getIt<HotelRepository>()
              .getHotels(
            lat: position.latitude,
            long: position.longitude,
            radius: 10,
          )
              .catchError((e) {
            debugPrint('Closest hotels load failure: $e');
            return HotelsCollection(data: []);
          });
        });
      }
    } catch (e) {
      debugPrint('Location service failed, using fallback coordinates: $e');
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _hideAnimController.dispose();
    super.dispose();
  }

  // ── Open the dedicated destination search page ──
  Future<void> _openDestinationSearch() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => HotelDestinationSearchPage(
          initialQuery: _destinationController.text,
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _destinationController.text = result;
      });
    }
  }

  // ── Recent Searches ──
  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('recent_hotel_searches');
      if (saved != null) {
        final List<dynamic> decoded = jsonDecode(saved);
        setState(() {
          _recentSearches =
              decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveSearchQuery(String destination) async {
    if (_sessionManager.currentUser == null) return;
    if (destination.trim().isEmpty) return;

    final dateFormat = DateFormat('dd/MM/yyyy');
    final datesText = _selectedDateRange == null
        ? 'Toutes dates'
        : '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}';

    final newSearch = {
      'destination': destination,
      'dates': datesText,
      'rooms': _rooms,
      'adults': _adults,
      'children': _children,
    };

    _recentSearches.removeWhere((e) => e['destination'] == destination);
    _recentSearches.insert(0, newSearch);
    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'recent_hotel_searches', jsonEncode(_recentSearches));
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error saving search query: $e');
    }
  }

  // Animated clear of recent searches
  Future<void> _clearRecentSearches() async {
    await _hideAnimController.reverse();
    setState(() {
      _recentSearchesVisible = false;
      _recentSearches = [];
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_hotel_searches');
    } catch (e) {
      debugPrint('Error clearing recent searches: $e');
    }
    // Reset for future searches
    _hideAnimController.value = 1.0;
  }

  // ── Date Picker ──
  Future<void> _selectDates(BuildContext context) async {
    final values = _selectedDateRange == null
        ? <DateTime?>[]
        : [_selectedDateRange!.start, _selectedDateRange!.end];

    final picked = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 350,
          height: 400,
          child: CalendarDatePicker2WithActionButtons(
            config: CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.range,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              selectedDayHighlightColor: AppColors.primary,
              selectedRangeHighlightColor:
                  AppColors.primary.withValues(alpha: 0.1),
              closeDialogOnCancelTapped: false,
              closeDialogOnOkTapped: false,
              okButton: Text(
                "Confirmer",
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              cancelButton: const Text(
                "Annuler",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            value: values,
            onValueChanged: (dates) {
              values.clear();
              values.addAll(dates);
            },
            onOkTapped: () {
              Navigator.pop(context, values);
            },
            onCancelTapped: () {
              Navigator.pop(context, null);
            },
          ),
        ),
      ),
    );

    if (picked != null &&
        picked.length >= 2 &&
        picked[0] != null &&
        picked[1] != null) {
      setState(() {
        _selectedDateRange = DateTimeRange(
          start: picked[0]!,
          end: picked[1]!,
        );
      });
    }
  }

  // ── Guests Modal ──
  void _showGuestsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Voyageurs & Chambres",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  _buildCounterRow("Chambres", _rooms, (val) {
                    if (val > 0) setModalState(() => _rooms = val);
                  }),
                  const Divider(height: 30),
                  _buildCounterRow("Adultes", _adults, (val) {
                    if (val > 0) setModalState(() => _adults = val);
                  }),
                  const Divider(height: 30),
                  _buildCounterRow("Enfants", _children, (val) {
                    if (val >= 0) setModalState(() => _children = val);
                  }),
                  const Gap(30),
                  CustomButtom(
                    text: "Confirmer",
                    onClick: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 28),
              onPressed: () => onChanged(value - 1),
            ),
            const Gap(10),
            Text("$value",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(10),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 28),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        )
      ],
    );
  }

  void _onSearch() {
    _saveSearchQuery(_destinationController.text);
    context.push(
      HotelSearchResultPage.routePath,
      extra: {
        'destination': _destinationController.text,
        'checkInDate': _selectedDateRange?.start,
        'checkOutDate': _selectedDateRange?.end,
        'adults': _adults,
        'children': _children,
        'rooms': _rooms,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM', 'fr_FR');
    final String datesText = _selectedDateRange == null
        ? "Selectionner les dates"
        : "${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SliverAppBar ──
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            title: const Text(
              "Hôtel",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            centerTitle: true,
            actions: const [
              NotificationBell(),
              Gap(16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: AppColors.primary),
            ),
          ),

          // ── Overlapping Search Card ──
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Blue header extension background
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),

                // The floating Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Destination tap-to-search button ──
                        InkWell(
                          onTap: _openDestinationSearch,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(Iconsax.location,
                                    color: Colors.blue, size: 20),
                                const Gap(10),
                                Expanded(
                                  child: Text(
                                    _destinationController.text.isEmpty
                                        ? 'Destination'
                                        : _destinationController.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          _destinationController.text.isEmpty
                                              ? FontWeight.normal
                                              : FontWeight.w600,
                                      color: _destinationController.text.isEmpty
                                          ? Colors.grey.shade400
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_destinationController.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _destinationController.clear()),
                                    child: const Icon(Icons.close,
                                        color: Colors.grey, size: 18),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const Gap(14),

                        // ── Date & occupants row ──
                        Row(
                          children: [
                            // Date range
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDates(context),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.calendar_1,
                                          size: 20, color: Colors.blue),
                                      const Gap(8),
                                      Expanded(
                                        child: Text(
                                          datesText,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Gap(8),

                            // Guests
                            Expanded(
                              child: InkWell(
                                onTap: () => _showGuestsModal(context),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.user,
                                          size: 20, color: Colors.blue),
                                      const Gap(6),
                                      Expanded(
                                        child: Text(
                                          "$_adults Ad. • $_rooms Ch.",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Gap(20),

                        // ── Chercher Button ──
                        CustomButtom(
                          text: "Chercher",
                          onClick: _onSearch,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Recent searches (animated dismissal) ──
          if (_recentSearches.isNotEmpty && _recentSearchesVisible) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _hideAnimation,
                  child: SizeTransition(
                    sizeFactor: _hideAnimation,
                    axisAlignment: -1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recherche récente",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: _clearRecentSearches,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Supprimer",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _hideAnimation,
                child: SizeTransition(
                  sizeFactor: _hideAnimation,
                  axisAlignment: -1,
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        final item = _recentSearches[index];
                        return _buildRecentSearchCard(
                          item['destination'] ?? '',
                          item['dates'] ?? '',
                          item['rooms'] as int? ?? 1,
                          item['adults'] as int? ?? 2,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],

          // ── Closest Hotels Section ──
          FutureBuilder<HotelsCollection>(
            future: _closestHotelsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final hotels = snapshot.data?.data ?? [];
              if (hotels.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return _buildSliverHotelSection("Les plus proches", hotels);
            },
          ),

          // ── Sponsored Hotels Section ──
          FutureBuilder<HotelsCollection>(
            future: _sponsoredHotelsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final hotels = snapshot.data?.data ?? [];
              if (hotels.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return _buildSliverHotelSection("Ads", hotels, isSponsored: true);
            },
          ),

          // ── Dynamic City Hotels ──
          ..._cityHotelsFutures.entries.map((entry) {
            return FutureBuilder<HotelsCollection>(
              future: entry.value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                final hotels = snapshot.data?.data ?? [];
                if (hotels.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return _buildSliverHotelSection(entry.key, hotels);
              },
            );
          }),

          // ── Discover Côte d'Ivoire ──
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Côte d'ivoire",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  Text(
                    "Découvrir la Côte d'ivoire",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Gap(4),
                  Text(
                    "Offrez-vous le confort d'un chez-soi sans les contraintes. Nos chambres sont pensées pour répondre à vos besoins.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
              children: [
                _buildDiscoverCard(
                    "assets/img/onb_1.jpeg", "Plages de Grand-Bassam"),
                _buildDiscoverCard(
                    "assets/img/onb_2.jpeg", "Basilique Yamoussoukro"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchCard(
      String title, String dates, int rooms, int adults) {
    return GestureDetector(
      onTap: () {
        _destinationController.text = title;
        _onSearch();
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.location, size: 16, color: AppColors.primary),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(3),
                  Text(dates,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      overflow: TextOverflow.ellipsis),
                  Text("$rooms Ch., $adults Ad.",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHotelSection(String title, List<HotelModel> hotels,
      {bool isSponsored = false}) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: isSponsored
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      child: const Text(
                        "Ads",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
        SizedBox(
          height: isSponsored ? 310 : 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return isSponsored
                  ? HotelCardSponsorise(hotel: hotel)
                  : HotelCard(hotel: hotel);
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildDiscoverCard(String assetPath, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(14),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
