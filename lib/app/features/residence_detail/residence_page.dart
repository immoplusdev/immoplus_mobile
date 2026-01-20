import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/extensions/safe_area_extensions.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_divider.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title_centered.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_rooms.dart';
import 'package:immoplus/app/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus/app/features/residence_detail/components/logment_bottom_bar.dart';
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/components/rating_component.dart';
import 'package:immoplus/svgs_icons.dart';
import 'package:video_player/video_player.dart';

import 'components/detail_description.dart';
import 'components/detail_logment_amentities.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_map.dart';
import 'components/detail_logment_name.dart';
import 'components/detail_logment_video.dart';
import 'components/detail_rules.dart';

class ResidencePage extends StatefulWidget {
  const ResidencePage({super.key, required this.idProduct});

  final String idProduct;
  static String name = 'logment_page';

  static String routePath() => '/residence_detail/:idProduct';

  static String route(String idProduct) => '/residence_detail/$idProduct';
  @override
  State<ResidencePage> createState() => _ResidencePageState();
}

class _ResidencePageState extends State<ResidencePage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    context.read<ResidenceCubit>().getResidence(id: widget.idProduct);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    () async {}();
    //print('dispose');
    //DataProvider().stopRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResidenceCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_RESIDENCE_DATA) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailLogmentAppBar(logmentModel: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context
                        .read<ResidenceCubit>()
                        .getResidence(id: widget.idProduct);
                  },
                ),
                //productName
                DetailLogmentName(residenceModel: state.data),
                DetailLogmentRooms(logmentModel: state.data),
                //product adress
                //DetailLogmentInfos(reservation: state.data),
                const DetailLogmentTitle2(title: 'Description'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverToBoxAdapter(
                    child: DetailDescription(
                      markdownText: state.data.description,
                    ),
                  ),
                ),
                const SliverGap(10),

                const DetailLogmentTitleCentered(
                    title: 'Ce que propose ce logement'),
                //offer list
                DetailLogmentAmentities(residenceModel: state.data),
                const SliverGap(10),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      // style: OutlinedButton.styleFrom(
                      //     side: BorderSide(color: AppColors.primary)),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.scafold,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => Container(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: state.data.commodites
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: SvgPicture.asset(
                                            SVGMap.map[e.icon] ?? '',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        tileColor: Colors.white,
                                        title: Text(e.text),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )),
                        );
                      },
                      child: Text(
                          "Voir tout les ${state.data.commodites.length} commodités"),
                    ),
                  ),
                ),

                //vidéo section
                DetailLogmentVideo(logmentModel: state.data),
                //description next

                // SeeMoreButton(
                //   text: state.data.description,
                // ),
                const DetailDivider(),
                // const DetailLogmentTitleCentered(title: 'Jours disponibles'),
                // DetailLogmentAvailableDay(
                //   reservation: state.data,
                // ),

                const DetailLogmentTitleCentered(
                    title: 'Où se situe le logement ?'),
                const SliverGap(20),
                DetailLogmentMap(residence: state.data),
                const DetailDivider(),
                const SliverGap(10),
                const DetailLogmentTitle2(title: 'Règles de la maison'),
                DetailLogmentRules(logmentModel: state.data),
                const SliverToBoxAdapter(child: Gap(15)),
                const DetailLogmentTitleCentered(title: 'Avis client'),
                const SliverGap(15),
                const SliverToBoxAdapter(
                  child: Center(child: RatingComponent(rating: 5)),
                ),
                const SliverGap(20),
              ],
            ),
            bottomNavigationBar: LogmentBottomBar(
              residenceModel: state.data,
            ),
          ).safeArea();
        }

        return InitialDetailLogmentScreen(
          idProduct: widget.idProduct,
        );
      },
    );
  }
}
