import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HistoryPageState {
  int indexPage;

  HistoryPageState({required this.indexPage});

  static String? search;

  static PagingController<int, ReservationModel> pagingControllerResidence =
      PagingController(firstPageKey: 1);
  static PagingController<int, DemandeVisiteModel> pagingControllerEstate =
      PagingController(firstPageKey: 1);

  static PagingController getPageListController(int index) => switch (index) {
        0 => pagingControllerResidence,
        1 => pagingControllerEstate,

        //4 => const ResidencesList(),
        _ => pagingControllerResidence,
      };
  static refrechAll() {
    pagingControllerResidence.refresh();
    pagingControllerEstate.refresh();
    pagingControllerResidence.refresh();
  }
}
