import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/extensions/safe_area_extensions.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_appbar.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_bottom_bar.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_infos.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_map.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_name.dart';
import 'package:immoplus/app/features/furniture_detail/components/furniture_detail_video.dart';
import 'package:immoplus/app/features/furniture_detail/cubit/furniture_cubit.dart';
import 'package:immoplus/app/features/furniture_detail/cubit/furniture_state.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_description.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_divider.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title2.dart';
import 'package:immoplus/app/features/residence_detail/components/detail_logment_title_centered.dart';

class FurnitureDetailPage extends StatefulWidget {
  const FurnitureDetailPage({super.key, required this.idProduct});

  final String idProduct;
  static String name = 'furniture_detail_page';

  static String routePath() => '/furniture_detail/:idProduct';

  static String route(String idProduct) => '/furniture_detail/$idProduct';
  @override
  State<FurnitureDetailPage> createState() => _FurnitureDetailPageState();
}

class _FurnitureDetailPageState extends State<FurnitureDetailPage> {
  @override
  void initState() {
    context.read<FurnitureCubit>().getFurniture(id: widget.idProduct);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FurnitureCubit, FurnitureState>(
      builder: (context, state) {
        if (state is FURNITURE_LOADING) {
          return const LoadingPage();
        }

        if (state is FURNITURE_DATA) {
          final furniture = state.data;
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                FurnitureDetailAppBar(furnitureModel: furniture),
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    context
                        .read<FurnitureCubit>()
                        .getFurniture(id: widget.idProduct);
                  },
                ),
                FurnitureDetailName(furnitureModel: furniture),
                FurnitureDetailInfos(furnitureModel: furniture),
                const DetailLogmentTitle2(title: 'Description'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: DetailDescription(
                      markdownText: furniture.description,
                    ),
                  ),
                ),
                FurnitureDetailVideo(furnitureModel: furniture),
                const DetailDivider(),
                const SliverGap(10),
                const DetailLogmentTitleCentered(
                    title: 'Où se trouve ce meuble ?'),
                const SliverGap(20),
                FurnitureDetailMap(furniture: furniture),
                const SliverGap(20),
                const SliverGap(15),
              ],
            ),
            bottomNavigationBar:
                FurnitureDetailBottomBar(furnitureModel: furniture),
          ).safeArea();
        }

        if (state is FURNITURE_ERROR) {
          return Scaffold(
            appBar: AppBar(title: const Text('Détails')),
            body: Center(child: Text(state.error)),
          );
        }

        return const LoadingPage();
      },
    );
  }
}
