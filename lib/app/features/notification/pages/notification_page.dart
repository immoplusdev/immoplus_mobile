import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit_state.dart';
import 'package:immoplus/app/features/notification/pages/notification_detail_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_tile.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';

class NotificationsPage extends StatefulWidget {
  static const String name = "NOTIFICATIONS_PAGE";
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<NotificationCubit>().loadNotifications();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifications',
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationCubitState>(
            builder: (context, state) {
              final hasUnread = state.maybeWhen(
                loaded: (notifications, _) =>
                    notifications.data.any((n) => !n.readStatus),
                orElse: () => false,
              );

              if (!hasUnread) return const SizedBox.shrink();

              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
                child: Text(
                  'Tout lire',
                  style: GoogleFonts.dmSans(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const Gap(8),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationCubitState>(
        builder: (context, state) {
          return state.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            loaded: (notifications, isLoadingMore) {
              if (notifications.data.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => context.read<NotificationCubit>().refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Gap(100),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.notification,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const Gap(24),
                            Text(
                              'Aucune notification',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Vous n\'avez pas encore reçu de notifications.',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => context.read<NotificationCubit>().refresh(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: notifications.data.length +
                      (notifications.hasNext ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= notifications.data.length) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: isLoadingMore
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                )
                              : const SizedBox(),
                        ),
                      );
                    }

                    final notification = notifications.data[index];
                    return NotificationTile(
                      notification: notification,
                      onTap: () {
                        context
                            .read<NotificationCubit>()
                            .markAsRead(notification.id);
                        context.pushNamed(
                          NotificationDetailPage.name,
                          extra: notification,
                        );
                      },
                      onDelete: () => context
                          .read<NotificationCubit>()
                          .deleteNotification(notification.id),
                    );
                  },
                ),
              );
            },
            error: (message) => Container(
              padding: EdgeInsets.all(appPadding),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2,
                        size: 48, color: Colors.red.shade300),
                    const Gap(16),
                    Text(
                      'Oups! Une erreur est survenue',
                      style: GoogleFonts.dmSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    Text(message,
                        style: GoogleFonts.dmSans(color: Colors.grey)),
                    const Gap(24),
                    CustomLoadingButtom(
                      onClick: () =>
                          context.read<NotificationCubit>().refresh(),
                      text: 'Réessayer',
                      isLoading: false,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
