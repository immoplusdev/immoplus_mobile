import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_cubit.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_state.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_booking_selection_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_room_detail_page.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_room_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_empty_state.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/features/hotel/widgets/hotel_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/detail_flexible_carousel.dart';
import 'package:immoplus/app/features/residence_detail/components/mosaic_logment_images.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class HotelDetailPage extends StatefulWidget {
  final String hotelId;
  const HotelDetailPage({super.key, required this.hotelId});

  static const String routePath = '/hotels/:hotelId';
  static const String name = 'hotel_detail';

  static String route(String id) => '/hotels/$id';

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    context.read<HotelCubit>().getHotel(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelCubit, HotelState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          hotelDetailLoaded: (hotel) => _buildDetailContent(context, hotel),
          error: (msg) => Scaffold(
            body: Center(
              child: CustomEmptyState(
                icon: Icons.error_outline,
                title: "Une erreur est survenue",
                description: msg,
                buttonText: "Recharger",
                onButtonPressed: () =>
                    context.read<HotelCubit>().getHotel(widget.hotelId),
              ),
            ),
          ),
          orElse: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }

  Widget _buildDetailContent(BuildContext context, HotelDetailModel hotel) {
    final double minPrice = hotel.firstRoomPrice;
    final carouselImages =
        hotel.images.where((img) => img.trim().isNotEmpty).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ── Large Image Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CircleButton(
                icon: CupertinoIcons.chevron_back,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/hotels');
                  }
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _CircleButton(
                  icon: Iconsax.send_2,
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _CircleButton(
                  icon: _isLiked ? Iconsax.heart5 : Iconsax.heart,
                  iconColor: _isLiked ? Colors.red : null,
                  onTap: () {
                    setState(() => _isLiked = !_isLiked);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: DetailFlexibleCarousel(
                images: carouselImages,
                onImageTap: (imageId) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MosaicLogmentImages(
                      tag: imageId,
                      imageUrls: carouselImages,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Pull to refresh ──
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              context.read<HotelCubit>().getHotel(widget.hotelId);
            },
          ),

          // ── Hotel Info Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(appPadding, 20, appPadding, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Hôtel • ${hotel.etoiles} Étoiles",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hotel.nom,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.adresse,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const _SliverDivider(),

          // ── Description Section ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ),
          const SliverGap(8),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child:
                  _ExpandableDescription(description: hotel.descriptionLongue),
            ),
          ),

          const _SliverDivider(),

          // ── Nos Chambres (Horizontal scroll list) ──
          if (hotel.typesChambres.isNotEmpty) ...[
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: appPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Nos chambres disponibles",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222)),
                ),
              ),
            ),
            const SliverGap(12),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 245,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                  itemCount: hotel.typesChambres.length,
                  itemBuilder: (context, index) {
                    final room = hotel.typesChambres[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: HotelRoomCard(
                        hotelId: hotel.hotelId,
                        room: room,
                        onTap: () {
                          context.push(
                            HotelRoomDetailPage.route(
                                hotel.hotelId, room.roomTypeId),
                            extra: hotel,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const _SliverDivider(),
          ],

          // ── Commodités Section ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Commodités",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222)),
              ),
            ),
          ),
          const SliverGap(8),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
                childAspectRatio: 4,
              ),
              delegate: SliverChildListDelegate([
                _buildAmenityRow(Iconsax.wifi, "Wifi gratuit"),
                _buildAmenityRow(Iconsax.music_play, "Télévision"),
                _buildAmenityRow(Iconsax.wind, "Climatisation"),
                _buildAmenityRow(Iconsax.coffee, "Petit déjeuner"),
                _buildAmenityRow(Iconsax.car, "Parking gratuit"),
                _buildAmenityRow(Iconsax.activity, "Salle de sport"),
              ]),
            ),
          ),

          const _SliverDivider(),

          // ── Map Section ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Où se situe l\'établissement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ),
          const SliverGap(12),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(5.3568, -3.9246),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(hotel.hotelId),
                        position: const LatLng(5.3568, -3.9246),
                      ),
                    },
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),
            ),
          ),

          const _SliverDivider(),

          // ── À Savoir Section ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "À savoir",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222)),
              ),
            ),
          ),
          const SliverGap(12),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildKnowRow(Iconsax.document_text, "Règlement",
                    "Arrivée à partir de ${hotel.heureArrivee.isNotEmpty ? hotel.heureArrivee : '14h00'}\nDépart avant ${hotel.heureDepart.isNotEmpty ? hotel.heureDepart : '12h00'}"),
                const Divider(height: 24),
                _buildKnowRow(Iconsax.shield_security, "Sécurité et logement",
                    "Animaux non autorisés\nFêtes non autorisées\nÉviter les nuisances sonores"),
                const Divider(height: 24),
                _buildKnowRow(Iconsax.info_circle, "Annulation",
                    "Annulation gratuite sous conditions"),
              ]),
            ),
          ),

          // Bottom padding
          const SliverGap(120),
        ],
      ),
      bottomNavigationBar: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        padding: EdgeInsets.only(
          left: appPadding,
          right: appPadding,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: 'A partir de ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${NumberFormat('#,###', 'fr_FR').format(minPrice).replaceAll(RegExp(r'\s+'), '.').replaceAll('\u00a0', '.')} FCFA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Builder(
                    builder: (context) {
                      final tomorrow =
                          DateTime.now().add(const Duration(days: 1));
                      final checkOut = tomorrow.add(const Duration(days: 3));
                      final monthFormat = DateFormat('d MMM', 'fr_FR');
                      final dateRangeStr =
                          "${tomorrow.day} – ${monthFormat.format(checkOut)} • 3 nuits";
                      return Text(
                        dateRangeStr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.55),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade300, width: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Annulation gratuite',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: CustomButtom(
                borderRadius: BorderRadius.circular(60),
                onClick: () {
                  context.push(HotelBookingSelectionPage.route(hotel.hotelId));
                },
                child: const Text(
                  "Choisir une\nchambre",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const Gap(8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildKnowRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const Gap(4),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Reusable circle button for AppBar ──────────────────────────────────────
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? const Color(0xFF222222),
        ),
      ),
    );
  }
}

// ─── Reusable expandable description ───────────────────────────────────────
class _ExpandableDescription extends StatefulWidget {
  final String description;
  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.description,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black.withOpacity(0.90),
            height: 1.55,
          ),
        );
        final tp = TextPainter(
          text: textSpan,
          maxLines: 4,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        _hasOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.90),
                height: 1.55,
              ),
            ),
            if (_hasOverflow) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showFullDescription(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lire la suite',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2744de),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 15,
                      color: Color(0xff2744de),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showFullDescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Thin divider sliver ────────────────────────────────────────────────────
class _SliverDivider extends StatelessWidget {
  const _SliverDivider();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: appPadding, vertical: 24),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: Color(0xFFEEEEEE),
        ),
      ),
    );
  }
}
