import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/extensions/safe_area_extensions.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/estate_detail/components/detail_rooms.dart';
import 'package:immoplus/app/features/estate_detail/components/estate_bottom_bar.dart';
import 'package:immoplus/app/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_description.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_divider.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus/app/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/svgs_icons.dart';
import 'package:video_player/video_player.dart';

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

  // 🎯 Pattern pour GoRoute
  static String routePath() => '/estate_detail/:idProduct';

  // 🎯 Route complète avec ID
  static String route(String idProduct) => '/estate_detail/$idProduct';

  @override
  State<EstatePage> createState() => _EstatePageState();
}

class _EstatePageState extends State<EstatePage> {
  String? time = 'A vie';
  VideoPlayerController? videoPlayerController;
  int initialCarouselPage = 0;
  final List<String>? images = [];
  @override
  void initState() {
    context.read<EstateCubit>().getEstate(id: widget.idProduct);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    () async {}();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstateCubit, RequestState>(
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_BIEN_IMMOBILIER_DATA) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                //appbar
                DetailEstateAppBar(bienImmobilier: state.data),
                //loader
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context.read<EstateCubit>().getEstate(id: widget.idProduct);
                  },
                ),
                //productName
                DetailEstateName(bienImmobilier: state.data),
                DetailEstateRooms(bienImmobilier: state.data),
                const DetailLogmentTitle2(title: 'Description'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  sliver: SliverToBoxAdapter(
                    child: DetailDescription(
                      markdownText: state.data.description,
                    ),
                  ),
                ),
                const DetailDivider(),
                if (state.data.amentities.isNotEmpty)
                  const DetailLogmentTitle2(
                      title: 'Ce que propose ce logement'),
                if (state.data.amentities.isNotEmpty)
                  DetailEstateAmentities(bienImmobilier: state.data),
                if (state.data.amentities.isNotEmpty) const SliverGap(10),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: state.data.amentities.isNotEmpty,
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
                                children: state.data.amentities
                                    .map(
                                      (e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
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
                            "Voir tout les ${state.data.amentities.length} commodités"),
                      ),
                    ),
                  ),
                ),
                const DetailDivider(),
                //vidéo section
                DetailEstateVideo(bienImmobilier: state.data),
                //description next

                const DetailDivider(),
                const DetailLogmentTitle2(title: 'Où se situe le logement ?'),
                DetailEstateMap(bienImmobilier: state.data),
                const DetailDivider(),
                const SliverGap(10),
                // const DetailLogmentTitle2(title: 'Règles de la maison'),

                // const SliverToBoxAdapter(child: Gap(15)),
              ],
            ),
            bottomNavigationBar: EstateBottomBar(
              bienImmobilier: state.data,
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
