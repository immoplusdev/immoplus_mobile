import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();

    return GestureDetector(
      onTap: () {
        if (sessionManager.currentUser != null) {
          context.pushNamed(NotificationsPage.name);
        } else {
          context.pushNamed(AuthenticationPage.name);
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.F2F2F2,
        ),
        child: Center(child: SvgPicture.asset("assets/svgs/icons/bell.svg")),
      ),
    );
  }
}
