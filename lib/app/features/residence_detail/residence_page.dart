import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_highlights.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_know_section.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_rooms.dart';
import 'package:immoplus/app/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus/app/features/residence_detail/components/logment_bottom_bar.dart';
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';
import 'package:immoplus/svgs_icons.dart';
import 'components/detail_logment_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';
import 'components/rating_logment_section.dart';

import 'package:immoplus/app/data/enums/ad_placement.dart';
import 'package:immoplus/app/widgets/ads/ad_widget.dart';

class ResidencePage extends StatefulWidget {
  const ResidencePage({
    super.key,
    required this.idProduct,
    this.isImmediateBooking = false,
    this.reverseSearchId,
    this.reverseSearchPrice,
  });

  final String idProduct;
  final bool isImmediateBooking;
  final String? reverseSearchId;
  final double? reverseSearchPrice;
  static String name = 'logment_page';

  static String routePath() => '/residence_detail/:idProduct';

  static String route(String idProduct) => '/residence_detail/$idProduct';

  @override
  State<ResidencePage> createState() => _ResidencePageState();
}

class _ResidencePageState extends State<ResidencePage> with ConnectivityMixin {
  bool _hasLoggedViewItem = false;

  @override
  void onConnectionRestored() {
    final state = context.read<ResidenceCubit>().state;
    if (state is REQUEST_ERROR || state is REQUEST_LOADING) {
      context.read<ResidenceCubit>().getResidence(id: widget.idProduct);
    }
  }

  @override
  void initState() {
    context.read<ResidenceCubit>().getResidence(id: widget.idProduct);
    super.initState();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidenceCubit, RequestState>(
      listener: (context, state) {
        if (state is REQUEST_ERROR) {
          showConnectionErrorDialog();
        }
      },
      builder: (context, state) {
        if (state is REQUEST_LOADING || state is REQUEST_ERROR) {
          return const LoadingPage();
        }

        if (state is REQUEST_RESIDENCE_DATA) {
          final data = state.data;
          if (!_hasLoggedViewItem) {
            _hasLoggedViewItem = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              getIt<AnalyticsService>().logViewResidence(
                itemId: data.id,
                itemName: data.nom,
                itemCategory: data.typeResidence,
                itemLocation: data.adresse,
                // itemLocation: '${data.ville} ${data.commune}'.trim(),
                price: data.prixReservation.toDouble(),
              );
            });
          }

          final hasPieces =
              data.pieces.isNotEmpty && data.pieces.any((p) => p.nombre > 0);
          // final hasPieces = data.pieces.isNotEmpty &&
          //     data.pieces.any((p) => p.nombre > 0);

          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: <Widget>[
                // ── Image Carousel AppBar ──
                DetailLogmentAppBar(logmentModel: data),

                // ── Pull to refresh ──
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context
                        .read<ResidenceCubit>()
                        .getResidence(id: widget.idProduct);
                  },
                ),

                // ── Name, Rating, Location ──
                DetailLogmentName(residenceModel: data),
                if (hasPieces) ...[
                  // const DetailLogmentTitle2(title: 'Lits et chambres'),
                  const SliverGap(10),
                  DetailLogmentRooms(logmentModel: data),
                  const _SliverDivider(),
                ],

                // ── Description with "Lire la suite" ──
                const DetailLogmentTitle2(title: 'Description'),
                const SliverGap(4),
                _ExpandableDescription(description: data.description),

                const SliverToBoxAdapter(
                  child: AdWidget(placement: AdPlacement.residenceDetails),
                ),

                const _SliverDivider(),

                // ── Amenities ──
                const DetailLogmentTitle2(title: 'Commodités'),
                const SliverGap(8),
                DetailLogmentAmentities(residenceModel: data),
                const SliverGap(12),

                // ── "View all" link (simple text, not button) ──
                if (data.commodites.length > 6)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: appPadding),
                      child: _ViewAllLink(
                        label: 'Voir les ${data.commodites.length} équipements',
                        onTap: () => _showAllAmenities(context, data),
                      ),
                    ),
                  ),

                const _SliverDivider(),

                // ── Highlights (Arrivée autonome, etc.) ──
                DetailHighlights(residenceModel: data),

                const _SliverDivider(),

                // ── Avis ──
                RatingLogmentSection(residenceId: data.id),
                const _SliverDivider(),

                // ── Video ──
                if (data.video.isNotEmpty) ...[
                  DetailLogmentVideo(videoId: data.video),
                  const _SliverDivider(),
                ],

                // ── Map ──
                const DetailLogmentTitle2(title: 'Où se situe le logement'),
                const SliverGap(8),
                DetailLogmentMap(residence: data),

                const _SliverDivider(),

                // ── "À savoir" (Rules, Safety, Cancellation) ──
                const DetailLogmentTitle2(title: 'À savoir'),
                const SliverGap(12),
                DetailKnowSection(residenceModel: data),

                // ── Bottom spacing for bottom bar ──
                const SliverGap(120),
              ],
            ),
            bottomNavigationBar: LogmentBottomBar(
              residenceModel: data,
              isImmediateBooking: widget.isImmediateBooking,
              reverseSearchId: widget.reverseSearchId,
              reverseSearchPrice: widget.reverseSearchPrice,
            ),
          );
        }

        return InitialDetailLogmentScreen(
          idProduct: widget.idProduct,
        );
      },
    );
  }

  void _showAllAmenities(BuildContext context, dynamic data) {
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
                itemCount: data.commodites.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                ),
                itemBuilder: (context, index) {
                  final item = data.commodites[index];
                  final iconsaxIcon = SVGMap.iconsaxMap[item.icon];
                  final svgPath = SVGMap.map[item.icon];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        if (iconsaxIcon != null)
                          Icon(
                            iconsaxIcon,
                            size: 24,
                            color: Colors.grey.shade700,
                          )
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

// ─── Expandable description (6 lines + "Lire la suite >") ──────────────────
// ─── Expandable description ───────────────────────────────────────────────────
class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.description});
  final String description;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
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
            // Titre "À propos du logement"

            // Texte tronqué à 4 lignes
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

            // Bouton "Lire la suite >"
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
                'Description',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Texte COMPLET ici — pas de DetailDescription qui retronque
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

// ─── Thin divider sliver ────────────────────────────────────────────────────
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

// ─── "View all >" text link (like in Roomer app) ───────────────────────────
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
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff2744de),
              )),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 15,
            color: const Color(0xff2744de),
          ),
        ],
      ),
    );
  }
}
