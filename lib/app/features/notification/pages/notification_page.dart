import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit_state.dart';
import 'package:immoplus/app/features/notification/pages/notification_tile.dart';
import 'package:immoplus/app/utils/app_colors.dart';

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationCubit, NotificationCubitState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (notifications, isLoadingMore) {
              if (notifications.data.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => context.read<NotificationCubit>().refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('Aucune notification disponible')),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<NotificationCubit>().refresh(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: notifications.data.length +
                      (notifications.hasNext ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= notifications.data.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: isLoadingMore
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ),
                      );
                    }

                    final notification = notifications.data[index];
                    return NotificationTile(
                      notification: notification,
                      onDelete: () => context
                          .read<NotificationCubit>()
                          .deleteNotification(notification.id),
                    );
                  },
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: $message'),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<NotificationCubit>().refresh(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
