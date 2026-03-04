import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/for_me/favorite_page.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigationHandler {
  SessionManager sessionManager;
  NavigationHandler(this.sessionManager);

  void switchPage({required int id, required BuildContext context}) {
    final PageState pageState;
    switch (id) {
      case 0:
        pageState = PageState.home;
      case 1:
        pageState = PageState.forMe;
      case 2:
        pageState = PageState.explore;
      default:
        pageState = PageState.acount;
    }
    context.read<NavigationCubit>().switchPage(pageState);

    switch (id) {
      case 0:
        context.go('/homePage');
      case 1:
        context.goNamed(FavoritePage.name);
      case 2:
        context.go('/map');
      default:
        context.goNamed(AccountPage.name);
    }
  }
}
