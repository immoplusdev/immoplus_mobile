import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/features/home_page/screens/estates_list.dart';
import 'package:immoplus/app/features/home_page/screens/furnitures_list.dart';
import 'package:immoplus/app/features/home_page/screens/lands_list.dart';
import 'package:immoplus/app/features/home_page/screens/residences_list.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePageState {
  static PagingController<int, ResidenceModel> pagingControllerResidence =
      PagingController(firstPageKey: 1);
  static PagingController<int, BienImmobilierModel> pagingControllerEstate =
      PagingController(firstPageKey: 1);
  static PagingController<int, BienImmobilierModel> pagingControllerLand =
      PagingController(firstPageKey: 1);
  static PagingController<int, FurnitureModel> pagingControllerFurniture =
      PagingController(firstPageKey: 1);
  int indexPage;
  HomePageState({required this.indexPage});

  static Widget getPageListFromIndex(int index) => switch (index) {
        0 => const ResidencesList(),
        1 => const FurnituresList(),
        2 => const EstatesList(),
        3 => const LandsList(),
        //4 => const ResidencesList(),
        _ => const ResidencesList(),
      };

  static PagingController getPageListController(int index) => switch (index) {
        0 => pagingControllerResidence,
        1 => pagingControllerFurniture,
        2 => pagingControllerEstate,
        3 => pagingControllerLand,
        //4 => const ResidencesList(),
        _ => pagingControllerResidence,
      };
}
