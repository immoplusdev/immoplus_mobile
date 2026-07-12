import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotels_collection.dart';
import 'package:immoplus/app/data/repositories/hotel_repository.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:intl/intl.dart';

class HotelSearchResultPage extends StatefulWidget {
  final String destination;
  final double? lat;
  final double? long;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int adults;
  final int children;
  final int lits;
  final String? villeId;

  const HotelSearchResultPage({
    super.key,
    required this.destination,
    this.lat,
    this.long,
    this.checkInDate,
    this.checkOutDate,
    required this.adults,
    required this.children,
    required this.lits,
    this.villeId,
  });

  static const String routePath = '/hotels/search/results';
  static const String name = 'hotel_search_results';

  static String route() => routePath;

  @override
  State<HotelSearchResultPage> createState() => _HotelSearchResultPageState();
}

class _HotelSearchResultPageState extends State<HotelSearchResultPage> {
  late Future<HotelsCollection> _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchFuture = _doSearch();
  }

  Future<HotelsCollection> _doSearch() {
    final repo = getIt<HotelRepository>();
    final dateFormat = DateFormat('yyyy-MM-dd');
    return repo
        .getHotels(
      lat: widget.lat,
      long: widget.long,
      radius: (widget.lat != null && widget.long != null) ? 10 : null,
      checkInDate: widget.checkInDate != null
          ? dateFormat.format(widget.checkInDate!)
          : null,
      checkOutDate: widget.checkOutDate != null
          ? dateFormat.format(widget.checkOutDate!)
          : null,
      adults: widget.adults,
      children: widget.children,
      lits: widget.lits,
      villeId: widget.villeId,
    )
        .catchError((e) {
      debugPrint('Hotel search error: $e');
      return HotelsCollection(data: []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM', 'fr_FR');
    final datesText = (widget.checkInDate != null &&
            widget.checkOutDate != null)
        ? '${dateFormat.format(widget.checkInDate!)} → ${dateFormat.format(widget.checkOutDate!)}'
        : 'Toutes dates';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 20),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: AppColors.primary,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.isEmpty
                          ? 'Tous les hôtels'
                          : widget.destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        const Icon(Iconsax.calendar_1,
                            size: 14, color: Colors.white70),
                        const Gap(4),
                        Text(
                          datesText,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        const Gap(12),
                        const Icon(Iconsax.user,
                            size: 14, color: Colors.white70),
                        const Gap(4),
                        Text(
                          '${widget.adults} Ad. • ${widget.lits} Lit(s)',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder<HotelsCollection>(
            future: _searchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final hotels = snapshot.data?.data ?? [];
              if (hotels.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.building,
                            size: 64, color: Colors.grey.shade300),
                        const Gap(16),
                        Text(
                          'Aucun hôtel trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Essayez de modifier votre recherche.',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final hotel = hotels[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: HotelCard(hotel: hotel),
                      );
                    },
                    childCount: hotels.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
