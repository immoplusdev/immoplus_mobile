library;

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:immoplus/app/features/home_page/screens/history_page_state.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/residence_filter_handler.dart';
import 'package:shimmer/shimmer.dart';

import 'components/home_search_appbar.dart';

// part 'widgets/about_secton.dart';
// part 'widgets/custom_app_bar.dart';
// part 'widgets/header_section.dart';
// part 'widgets/home_section_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String name = "home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final sessionManager = getIt<SessionManager>();

  @override
  void initState() {
    context.read<NavigationCubit>().switchPage(PageState.home);
    () {
      HistoryPageState.refrechAll();
    }();
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    FilterHandler.search = null;
  }

  // Create a ScrollController to listen for scroll events
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //print('ACCOUNT ${UserModel().emailVerified}');
    //inspect(Constantes.configApp);
    //Constantes.buildNotifier.value = !Constantes.buildNotifier.value;
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        _tabController.animateTo(state.indexPage);
        return Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: DefaultTabController(
            length: 4,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                HomeSearchAppbar(
                  currentIndex: state.indexPage,
                  controller: _tabController,
                ),
                CupertinoSliverRefreshControl(
                  //      backgroundColor: Colors.white,
                  // color: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    HomePageState.getPageListController(state.indexPage)
                        .refresh();
                    // _pagingController.refresh();
                  },
                ),
                const SliverGap(10),
                HomePageState.getPageListFromIndex(state.indexPage),
              ],
            ),
          ),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     if (SessionManager().currentUser != null) {
          //       print(SessionManager().currentUser!.userId);
          //       OneSignal.login(SessionManager().currentUser!.userId ?? '');
          //     }
          //     // InAppNotifications.show(
          //     //     title: 'Welcome to InAppNotifications',
          //     //     leading: Icon(
          //     //       Icons.fact_check,
          //     //       color: Colors.green,
          //     //       size: 50,
          //     //     ),
          //     //     ending: Icon(
          //     //       Icons.arrow_right_alt,
          //     //       color: Colors.red,
          //     //     ),
          //     //     description:
          //     //         'This is a very simple notification with leading and ending widget.',
          //     //     onTap: () {
          //     //       // Do whatever you need!
          //     //     });
          //   },
          // ),

          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   try {
          //     final model = BienImmobilierCollection.fromJson({
          //       "data": [
          //         {
          //           "id": "45ca3511-d8ae-4a4f-a84d-6690407156b8",
          //           "nom": "Maison a louer",
          //           "typeBienImmobilier": "appartement",
          //           "description": "Une description",
          //           "amentities": [
          //             {"icon": "wifi", "text": "Wifi"},
          //             {"icon": "tv", "text": "Télé"}
          //           ],
          //           "tags": [],
          //           "images": [
          //             "6b587ed7-a489-4542-a66b-019816d20ab9",
          //             "2f4096a0-813b-4142-a588-01d434b690ec",
          //             "8373bf49-c4d0-4bc2-83c9-766451f248a5",
          //             "315d4d76-d14d-47e3-a6e2-b30238d62478",
          //             "eb5a67d9-0201-4b59-bc2b-8cab4ba1e153"
          //           ],
          //           "adresse": "Cocody-Blockauss, A 4, Abidjan",
          //           "position": {
          //             "type": "Point",
          //             "coordinates": [-4.001415700000001, 5.322778899999999]
          //           },
          //           "latitude": 5.322778899999999,
          //           "longitude": -4.001415700000001,
          //           "statusValidation": "valide",
          //           "prix": 100,
          //           "metadata": null,
          //           "featured": false,
          //           "aLouer": true,
          //           "typeLocation": "mois",
          //           "bienImmobilierDisponible": true,
          //           "nombreMaxOccupants": 10,
          //           "animauxAutorises": null,
          //           "fetesAutorises": false,
          //           "reglesSupplementaires": null,
          //           "createdAt": "2025-01-31T11:41:42.938Z",
          //           "updatedAt": "2025-07-04T02:02:31.000Z",
          //           "deletedAt": null,
          //           "miniature": "6b587ed7-a489-4542-a66b-019816d20ab9",
          //           "video": "d177f203-5d55-446d-95f8-34b8fafc509e",
          //           "ville": "8b97b9ce-a507-11ef-8b44-0e595bc2ce41",
          //           "commune": "8bb446ea-a507-11ef-8b44-0e595bc2ce41",
          //           "proprietaire": "eff7af18-dfcd-41bb-b21b-0860b97733a1"
          //         },
          //         {
          //           "id": "9261766a-45c6-45d3-96b5-f57b16403e35",
          //           "nom": "alama ",
          //           "typeBienImmobilier": "studio",
          //           "description": "Terrain de djedje10",
          //           "amentities": [
          //             {"icon": "kitchen", "text": "Ventilateur"},
          //             {"icon": "kitchen-set-solid", "text": "Ustensiles"},
          //             {"icon": "fan-solid", "text": "Ventilateur"},
          //             {"icon": "dry_cleaning", "text": "Serviette"}
          //           ],
          //           "tags": [],
          //           "images": ["99252a96-1871-4f53-9b0a-a588bbaa469d"],
          //           "adresse": "8WHF+RR4, Ouest 13, Yopougon, Abidjan",
          //           "position": {
          //             "type": "Point",
          //             "coordinates": [-4.0753765, 5.329634899999999]
          //           },
          //           "latitude": 5.329634899999999,
          //           "longitude": -4.0753765,
          //           "statusValidation": "valide",
          //           "prix": 100,
          //           "metadata": null,
          //           "featured": false,
          //           "aLouer": false,
          //           "typeLocation": "vente",
          //           "bienImmobilierDisponible": true,
          //           "nombreMaxOccupants": 10,
          //           "animauxAutorises": null,
          //           "fetesAutorises": false,
          //           "reglesSupplementaires": null,
          //           "createdAt": "2025-03-20T01:58:50.618Z",
          //           "updatedAt": "2025-07-04T02:02:31.000Z",
          //           "deletedAt": null,
          //           "miniature": "99252a96-1871-4f53-9b0a-a588bbaa469d",
          //           "video": "6801ad0a-027c-44b0-ad66-d76d8a55bd81",
          //           "ville": "8b97b9ce-a507-11ef-8b44-0e595bc2ce41",
          //           "commune": "8bb47716-a507-11ef-8b44-0e595bc2ce41",
          //           "proprietaire": "07264151-d7d9-4045-9ca2-517d148bbed4"
          //         }
          //       ],
          //       "currentPage": 1,
          //       "totalPages": 1,
          //       "pageSize": 10,
          //       "totalCount": 2,
          //       "hasNext": false,
          //       "hasPrevious": false
          //     });
          //     inspect(model);
          //   } catch (e) {
          //     inspect(e);
          //   }
          // }),
        );
      },
    );
  }

  //final bool _displayPanier = true;
}
