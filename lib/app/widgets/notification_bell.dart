import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';

class NotificationBell extends StatelessWidget {
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const NotificationBell({
    super.key,
    this.backgroundColor,
    this.size = 48.0,
    this.iconSize = 22.0,
  });

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
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? AppColors.blue40,
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/svgs/icons/bell.svg",
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
