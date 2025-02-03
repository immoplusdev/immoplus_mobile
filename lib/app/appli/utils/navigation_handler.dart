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
  switchPage({required int id, required BuildContext context}) {
    if (sessionManager.currentUser == null) {
      //Vibrate.feedback(FeedbackType.light);

      context.read<NavigationCubit>().switchPage((id == 0)
          ? PageState.home
          : (id == 1)
              ? PageState.forMe
              // : (id == 2)
              //     ?

              : (id == 3)
                  ? PageState.explore
                  : PageState.acount);
    } else if (sessionManager.currentUser != null) {
      //Vibrate.feedback(FeedbackType.light);

      context.read<NavigationCubit>().switchPage(
            (id == 0)
                ? PageState.home
                : (id == 1)
                    ? PageState.forMe
                    // : (id == 2)
                    //     ?

                    : (id == 3)
                        ? PageState.explore
                        : PageState.acount,
          );
    }

    switch (id) {
      case 0:
        context.go('/homePage');
        break;

      case 1:
        context.goNamed(FavoritePage.name);
        break;
      case 2:
        // context.go('/map');
        print('explore');
        break;
      case 3:
        context.go('/map');
        break;
      default:
        context.goNamed(AccountPage.name);
        break;
      // Gérez plus d'indices si vous avez d'autres onglets
    }
  }
}
