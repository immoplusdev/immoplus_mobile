import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/repositories/notification_repository.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/notification/pages/notification_detail_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_tile.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class NotificationsPage extends StatefulWidget {
  static const String name = "NOTIFICATIONS_PAGE";
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with ConnectivityMixin {
  final PagingController<int, NotificationModel> _pagingController =
      PagingController(firstPageKey: 1);

  final NotificationRepository _repository = getIt<NotificationRepository>();

  bool _hasUnread = false;

  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null ||
        _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  Future<void> _loadPage(int page) async {
    try {
      final response = await _repository.getNotifications(page: page);

      // Mise à jour du badge "Tout lire"
      final anyUnread = response.data.any((n) => !n.readStatus);
      if (anyUnread && !_hasUnread) {
        setState(() => _hasUnread = true);
      } else if (!anyUnread && page == 1) {
        setState(() => _hasUnread = false);
      }

      if (response.hasNext) {
        _pagingController.appendPage(response.data, response.currentPage + 1);
      } else {
        _pagingController.appendLastPage(response.data);
      }
    } catch (e) {
      log(e.toString(), name: 'NOTIFICATION_PAGING_ERROR');
      showConnectionErrorDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    _pagingController.dispose();
    super.dispose();
  }

  void _refresh() => _pagingController.refresh();

  // Marquer toutes les notifications de la liste comme lues localement
  void _markAllReadLocally() {
    final currentItems = _pagingController.itemList;
    if (currentItems == null) return;
    final updated =
        currentItems.map((n) => n.copyWith(readAt: DateTime.now())).toList();
    setState(() {
      _pagingController.itemList = updated;
      _hasUnread = false;
    });
  }

  // Marquer une notification comme lue localement
  void _markReadLocally(String id) {
    final currentItems = _pagingController.itemList;
    if (currentItems == null) return;
    final updated = currentItems.map((n) {
      if (n.id == id) return n.copyWith(readAt: DateTime.now());
      return n;
    }).toList();
    final stillUnread = updated.any((n) => !n.readStatus);
    setState(() {
      _pagingController.itemList = updated;
      _hasUnread = stillUnread;
    });
  }

  // Supprimer une notification localement
  void _removeLocally(String id) {
    final currentItems = _pagingController.itemList;
    if (currentItems == null) return;
    final updated = currentItems.where((n) => n.id != id).toList();
    final stillUnread = updated.any((n) => !n.readStatus);
    setState(() {
      _pagingController.itemList = updated;
      _hasUnread = stillUnread;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: const Text('Notifications'),
              actions: [
                if (_hasUnread)
                  TextButton(
                    onPressed: () async {
                      await context.read<NotificationCubit>().markAllAsRead();
                      _markAllReadLocally();
                    },
                    child: Text(
                      'Tout lire',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Gap(8),
              ],
            ),
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async => _refresh(),
                  ),
                  PagedSliverList<int, NotificationModel>(
                    pagingController: _pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<NotificationModel>(
                      // Chargement initial — skeleton shimmer-like
                      firstPageProgressIndicatorBuilder: (context) => Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                      ),
                      // Chargement des pages suivantes
                      newPageProgressIndicatorBuilder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          ),
                        ),
                      ),
                      // Aucune notification
                      noItemsFoundIndicatorBuilder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(80),
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
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Erreur
                      firstPageErrorIndicatorBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(80),
                            Icon(Iconsax.warning_2,
                                size: 48, color: Colors.red.shade300),
                            const Gap(16),
                            Text(
                              'Oups! Une erreur est survenue',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              _pagingController.error?.toString() ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(color: Colors.grey),
                            ),
                            const Gap(24),
                            ElevatedButton(
                              onPressed: _refresh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Réessayer',
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Item builder
                      itemBuilder: (context, notification, index) =>
                          NotificationTile(
                        notification: notification,
                        onTap: () async {
                          _markReadLocally(notification.id);
                          context
                              .read<NotificationCubit>()
                              .markAsRead(notification.id);
                          context.pushNamed(
                            NotificationDetailPage.name,
                            extra: notification,
                          );
                        },
                        onDelete: () async {
                          _removeLocally(notification.id);
                          context
                              .read<NotificationCubit>()
                              .deleteNotification(notification.id);
                        },
                      ),
                    ),
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
