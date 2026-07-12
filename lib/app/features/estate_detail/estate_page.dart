import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/estate_detail/components/detail_estate_highlights.dart';
import 'package:immoplus/app/features/estate_detail/components/detail_estate_know_section.dart';
import 'package:immoplus/app/features/estate_detail/components/detail_rooms.dart';
import 'package:immoplus/app/features/estate_detail/components/estate_bottom_bar.dart';
import 'package:immoplus/app/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus/app/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/svgs_icons.dart';

import 'components/detail_estate_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';

class EstatePage extends StatefulWidget {
  const EstatePage({
    super.key,
    required this.idProduct,
    this.bienImmobilierModel,
  });

  final String idProduct;
  final BienImmobilierModel? bienImmobilierModel;
  static String name = 'estate_page';

  static String routePath() => '/estate_detail/:idProduct';
  static String route(String idProduct) => '/estate_detail/$idProduct';

  @override
  State<EstatePage> createState() => _EstatePageState();
}

class _EstatePageState extends State<EstatePage> {
  bool _hasLoggedViewItem = false;

  @override
  void initState() {
    context.read<EstateCubit>().getEstate(id: widget.idProduct);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstateCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_BIEN_IMMOBILIER_DATA) {
          final data = state.data;
          if (!_hasLoggedViewItem) {
            _hasLoggedViewItem = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              getIt<AnalyticsService>().logViewEstate(
                itemId: data.id,
                itemName: data.nom,
                itemCategory: data.typeBienImmobilier,
                price: data.prix.toDouble(),
              );
            });
          }
          final hasPieces =
              data.pieces.isNotEmpty && data.pieces.any((p) => p.nombre > 0);

          return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: <Widget>[
                // ── Image Carousel AppBar ──
                DetailEstateAppBar(bienImmobilier: data),

                // ── Pull to refresh ──
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context
                        .read<EstateCubit>()
                        .getEstate(id: widget.idProduct);
                  },
                ),

                // ── Name, Rating, Location, Price ──
                DetailEstateName(bienImmobilier: data),

                const _SliverDivider(),

                // // ── Highlights ──
                // DetailEstateHighlights(bienImmobilier: data),

                // const _SliverDivider(),

                // ── Description ──
                const DetailLogmentTitle2(title: 'À propos de ce bien'),
                const SliverGap(4),
                _ExpandableDescription(description: data.description),

                const _SliverDivider(),

                // ── Rooms ──
                if (hasPieces) ...[
                  const DetailLogmentTitle2(title: 'Pièces et espaces'),
                  const SliverGap(10),
                  DetailEstateRooms(bienImmobilier: data),
                  const _SliverDivider(),
                ],

                // ── Amenities ──
                if (data.amentities.isNotEmpty) ...[
                  const DetailLogmentTitle2(
                      title: 'Ce que propose ce bien'),
                  const SliverGap(8),
                  DetailEstateAmentities(bienImmobilier: data),
                  const SliverGap(12),
                  if (data.amentities.length > 6)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: appPadding),
                        child: _ViewAllLink(
                          label:
                              'Voir les ${data.amentities.length} équipements',
                          onTap: () => _showAllAmenities(context, data),
                        ),
                      ),
                    ),
                  const _SliverDivider(),
                ],

                // ── Video ──
                if (data.video != null && data.video!.isNotEmpty) ...[
                  DetailEstateVideo(bienImmobilier: data),
                  const _SliverDivider(),
                ],

                // ── Map ──
                const DetailLogmentTitle2(title: 'Où se situe le bien'),
                const SliverGap(8),
                DetailEstateMap(bienImmobilier: data),

                const _SliverDivider(),

                // ── "À savoir" ──
                const DetailLogmentTitle2(title: 'À savoir'),
                const SliverGap(12),
                DetailEstateKnowSection(bienImmobilier: data),

                // ── Bottom spacing for bottom bar ──
                const SliverGap(120),
              ],
            ),
            bottomNavigationBar: EstateBottomBar(bienImmobilier: data),
          );
        }

        return InitialDetailLogmentScreen(idProduct: widget.idProduct);
      },
    );
  }

  void _showAllAmenities(BuildContext context, BienImmobilierModel data) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Équipements',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                itemCount: data.amentities.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final item = data.amentities[index];
                  final iconsaxIcon = SVGMap.iconsaxMap[item.icon];
                  final svgPath = SVGMap.map[item.icon];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (iconsaxIcon != null)
                          Icon(iconsaxIcon,
                              size: 24, color: Colors.grey.shade700)
                        else if (svgPath != null)
                          SvgPicture.asset(
                            svgPath,
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade700,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          Icon(Iconsax.element_4,
                              size: 24, color: Colors.grey.shade700),
                        const Gap(16),
                        Expanded(
                          child: Text(
                            item.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Expandable description ───────────────────────────────────────────────────
class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.description});
  final String description;

  @override
  State<_ExpandableDescription> createState() =>
      _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final textSpan = TextSpan(
                  text: widget.description.capitalizeWords(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                    height: 1.55,
                  ),
                );
                final textPainter = TextPainter(
                  text: textSpan,
                  maxLines: 4,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_hasOverflow != textPainter.didExceedMaxLines) {
                    setState(() {
                      _hasOverflow = textPainter.didExceedMaxLines;
                    });
                  }
                });

                return Text(
                  widget.description.capitalizeWords(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.90),
                    height: 1.55,
                  ),
                );
              },
            ),

            // "Lire la suite >"
            if (_hasOverflow) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showFullDescription(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lire la suite',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2744de).withOpacity(0.80),
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
            ],
          ],
        ),
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
                'À propos du bien',
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

// ─── Thin divider sliver ─────────────────────────────────────────────────────
class _SliverDivider extends StatelessWidget {
  const _SliverDivider();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: appPadding, vertical: 24),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}

// ─── "View all >" text link ──────────────────────────────────────────────────
class _ViewAllLink extends StatelessWidget {
  const _ViewAllLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w100,
              color: const Color(0xFF343333).withOpacity(0.80),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 15,
            color: const Color(0xFF343333).withOpacity(0.80),
          ),
        ],
      ),
    );
  }
}
