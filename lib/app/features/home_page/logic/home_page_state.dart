import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
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

  // Token pour invalider les requêtes périmées (race condition fix)
  static int _residenceToken = 0;
  static int get residenceToken => _residenceToken;
  static void refreshResidences() {
    _residenceToken++;
    pagingControllerResidence.refresh();
  }

  /// Refresh sécurisé : incrémente le token pour l'index de la tab résidences
  static void refreshPage(int index) {
    if (index == HomeTab.residence.value) {
      refreshResidences();
    } else {
      getPageListController(index).refresh();
    }
  }

  int indexPage;
  HomePageState({required this.indexPage});

  static Widget getPageListFromIndex(int index) {
    final tab = HomeTab.values.firstWhere(
      (t) => t.value == index,
      orElse: () => HomeTab.residence,
    );
    return switch (tab) {
      HomeTab.residence => const ResidencesList(),
      HomeTab.location => const EstatesList(),
      HomeTab.furniture => const FurnituresList(),
      HomeTab.bien => const LandsList(),
    };
  }

  static PagingController getPageListController(int index) {
    final tab = HomeTab.values.firstWhere(
      (t) => t.value == index,
      orElse: () => HomeTab.residence,
    );
    return switch (tab) {
      HomeTab.residence => pagingControllerResidence,
      HomeTab.location => pagingControllerEstate,
      HomeTab.furniture => pagingControllerFurniture,
      HomeTab.bien => pagingControllerLand,
    };
  }
}
