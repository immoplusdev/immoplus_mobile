import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_room_detail_model.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_cubit.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_state.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_room_cubit.dart';
import 'package:immoplus/app/features/hotel/cubit/hotel_room_state.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_booking_selection_page.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/custom_empty_state.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/detail_flexible_carousel.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/extensions/string_extension.dart';

class HotelRoomDetailPage extends StatefulWidget {
  final String hotelId;
  final String roomTypeId;
  final HotelDetailModel? hotel;

  const HotelRoomDetailPage({
    super.key,
    required this.hotelId,
    required this.roomTypeId,
    this.hotel,
  });

  static const String routePath = '/hotels/:hotelId/chambres/:roomTypeId';
  static const String name = 'hotel_room_detail';
  static String route(String hotelId, String roomTypeId) =>
      '/hotels/$hotelId/chambres/$roomTypeId';

  @override
  State<HotelRoomDetailPage> createState() => _HotelRoomDetailPageState();
}

class _HotelRoomDetailPageState extends State<HotelRoomDetailPage> {
  final ValueNotifier<bool> _liked = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HotelCubit>(
          create: (context) {
            final cubit = getIt<HotelCubit>();
            if (widget.hotel == null) {
              cubit.getHotel(widget.hotelId);
            }
            return cubit;
          },
        ),
        BlocProvider<HotelRoomCubit>(
          create: (context) => getIt<HotelRoomCubit>()
            ..getRoomDetail(widget.hotelId, widget.roomTypeId),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<HotelCubit, HotelState>(
          builder: (context, hotelState) {
            return BlocBuilder<HotelRoomCubit, HotelRoomState>(
              builder: (context, roomState) {
                // Determine loading/error states
                final isHotelLoading = widget.hotel == null &&
                    hotelState.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                final isRoomLoading = roomState.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                if (isHotelLoading || isRoomLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                HotelDetailModel? hotel = widget.hotel;
                if (hotel == null) {
                  hotelState.maybeWhen(
                    hotelDetailLoaded: (h) => hotel = h,
                    orElse: () {},
                  );
                }

                HotelRoomDetailModel? room;
                roomState.maybeWhen(
                  loaded: (r) => room = r,
                  orElse: () {},
                );

                final hotelError = widget.hotel == null
                    ? hotelState.maybeWhen(
                        error: (msg) => msg,
                        orElse: () => null,
                      )
                    : null;
                final roomError = roomState.maybeWhen(
                  error: (msg) => msg,
                  orElse: () => null,
                );

                if (hotelError != null || roomError != null) {
                  return Center(
                    child: CustomEmptyState(
                      icon: Icons.error_outline,
                      title: "Une erreur est survenue",
                      description: hotelError ?? roomError ?? "",
                      buttonText: "Recharger",
                      onButtonPressed: () {
                        context.read<HotelCubit>().getHotel(widget.hotelId);
                        context.read<HotelRoomCubit>().getRoomDetail(
                              widget.hotelId,
                              widget.roomTypeId,
                            );
                      },
                    ),
                  );
                }

                if (hotel == null || room == null) {
                  return const Center(child: Text("Données introuvables"));
                }

                return _buildContent(context, hotel!, room!);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, HotelDetailModel hotel, HotelRoomDetailModel room) {
    final carouselImages =
        room.images.where((img) => img.trim().isNotEmpty).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ── Image Header ──
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
                    context.go('/hotels/${hotel.hotelId}');
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: _liked,
                  builder: (context, liked, _) => _CircleButton(
                    icon: liked ? Iconsax.heart5 : Iconsax.heart,
                    iconColor: liked ? Colors.red : null,
                    onTap: () => _liked.value = !liked,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: carouselImages.isNotEmpty
                  ? DetailFlexibleCarousel(
                      images: carouselImages,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.hotel, size: 64, color: Colors.grey),
                      ),
                    ),
            ),
          ),

          // ── Title & Intro ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  appPadding, appPadding, appPadding, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.nom,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${NumberFormat('#,###', 'fr_FR').format(room.tarification.prixParNuit).replaceAll(RegExp(r'\s+'), '.').replaceAll('\u00a0', '.')} FCFA / nuit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (idx) => Icon(
                            Icons.star,
                            size: 16,
                            color: idx < hotel.etoiles
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${hotel.etoiles.toDouble()}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "•  12 Commentaires",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const _SliverDivider(),

          // ── Description ──
          if (room.description != null && room.description!.isNotEmpty) ...[
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: appPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
            ),
            const SliverGap(8),
            _ExpandableDescription(description: room.description!),
            const _SliverDivider(),
          ],

          // ── Features (Commodités) ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Caractéristiques",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ),
          const SliverGap(12),
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
                _buildAmenityRow(Iconsax.note, "Lit: ${room.typeLit}"),
                _buildAmenityRow(Iconsax.key, "${room.nombreLits} lit(s)"),
                _buildAmenityRow(
                    Iconsax.user, "${room.occupationMax} pers. max"),
                if (room.vue != null && room.vue!.isNotEmpty)
                  _buildAmenityRow(Iconsax.eye, "Vue: ${room.vue}"),
                _buildAmenityRow(
                    Iconsax.coffee, "Petit déj.: ${room.petitDejeuner.option}"),
                _buildAmenityRow(Iconsax.shield_security,
                    "Annulation: ${room.politiqueAnnulation.code}"),
              ]),
            ),
          ),

          const _SliverDivider(),

          // ── Payment & Conditions ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Paiement et conditions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ),
          const SliverGap(12),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildConditionRow("Acompte requis :", "${hotel.tauxAcompte}%"),
                const Divider(height: 16, thickness: 0.5),
                _buildConditionRow("Taxe de séjour :",
                    "${NumberFormat('#,###', 'fr_FR').format(hotel.taxeSejour).replaceAll(RegExp(r'\s+'), '.').replaceAll('\u00a0', '.')} FCFA / nuit"),
                const Divider(height: 16, thickness: 0.5),
                _buildConditionRow(
                  "Politique d'annulation :",
                  room.politiqueAnnulation.libelle,
                  isBoldValue: false,
                ),
                const Divider(height: 20, thickness: 0.5),
                Row(
                  children: [
                    const Text(
                      "Moyens de paiement :",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildPaymentBadge("Wave"),
                        const SizedBox(width: 4),
                        _buildPaymentBadge("OM"),
                        const SizedBox(width: 4),
                        _buildPaymentBadge("Carte"),
                        const SizedBox(width: 4),
                        _buildPaymentBadge("Cash"),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),

          const _SliverDivider(),

          // ── À savoir ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "À savoir",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ),
          const SliverGap(12),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildKnowRow(Iconsax.document_text, "Règlement",
                    "Arrivée à partir de ${hotel.heureArrivee.isNotEmpty ? hotel.heureArrivee : '14:00'}\nDépart avant ${hotel.heureDepart.isNotEmpty ? hotel.heureDepart : '12:00'}"),
                const Divider(height: 24),
                _buildKnowRow(Iconsax.shield_security, "Sécurité et logement",
                    "Animaux non autorisés\nFêtes non autorisées\nÉviter les nuisances sonores"),
                const Divider(height: 24),
                _buildKnowRow(Iconsax.info_circle, "Consignes de salubrité",
                    "Maintenir les lieux propres\nRespecter les équipements et le mobilier\nLaisser la chambre dans un état acceptable à votre départ"),
              ]),
            ),
          ),

          const _SliverDivider(),

          // ── Situation géographique (Lieux) ──
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Lieux",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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

          // ── Aperçus Gallery ──
          if (carouselImages.length > 1) ...[
            const _SliverDivider(),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: appPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Aperçus",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
            ),
            const SliverGap(12),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final imageUrl = carouselImages[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.grey.shade100,
                        child: Image.network(
                          Utils.getImagePath(id: imageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade300),
                        ),
                      ),
                    );
                  },
                  childCount: carouselImages.length.clamp(0, 4),
                ),
              ),
            ),
          ],

          const SliverGap(140),
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
                              '${NumberFormat('#,###', 'fr_FR').format(room.tarification.prixParNuit).replaceAll(RegExp(r'\s+'), '.').replaceAll('\u00a0', '.')} FCFA',
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
                  context.push(HotelBookingSelectionPage.route(hotel.hotelId,
                      roomId: room.roomTypeId));
                },
                child: const Text(
                  "Réserver",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildConditionRow(String title, String value,
      {bool isBoldValue = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.65),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
              color: isBoldValue ? Colors.black : Colors.red.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKnowRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.55),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentBadge(String name) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

// ─── Circle Button ───────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? Colors.black,
        ),
      ),
    );
  }
}

// ─── Reusable thin divider sliver ───────────────────────────────────────────
class _SliverDivider extends StatelessWidget {
  const _SliverDivider();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: appPadding, vertical: 24),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}

// ─── Expandable Description Widget ──────────────────────────────────────────
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
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textSpan = TextSpan(
            text: widget.description.capitalizeWords(),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: appPadding),
                child: Text(
                  widget.description.capitalizeWords(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.90),
                    height: 1.55,
                  ),
                ),
              ),
              if (_hasOverflow) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: appPadding),
                  child: GestureDetector(
                    onTap: () => _showFullDescription(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Lire la suite',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff2744de),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 15,
                          color: const Color(0xff2744de).withOpacity(0.80),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
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
                widget.description.capitalizeWords(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.90),
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
