import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immoplus/app/utils/connectivity_mixin.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});
  static String name = 'PAYMENTHISTORYPAGE';

  static String routePath() => '/payment_history';

  static String route() => '/payment_history';

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

IconData _getStatusIcon(String status) {
  if (status == PaymentStatus.successful.name ||
      status == PaymentStatus.paye.name) {
    return Iconsax.tick_circle;
  } else if (status == PaymentStatus.pending.name) {
    return Iconsax.clock;
  } else if (status == PaymentStatus.action_required.name) {
    return Iconsax.warning_2;
  } else if (status == PaymentStatus.payment_required.name) {
    return Iconsax.wallet_1;
  } else if (status == PaymentStatus.failed.name) {
    return Iconsax.close_circle;
  } else if (status == PaymentStatus.processing.name) {
    return Iconsax.refresh_circle;
  }
  return Iconsax.close_circle;
}

Color _getStatusColor(String status) {
  if (status == PaymentStatus.successful.name ||
      status == PaymentStatus.paye.name) {
    return const Color(0xFF12B76A);
  } else if (status == PaymentStatus.pending.name) {
    return const Color(0xFF667085);
  } else if (status == PaymentStatus.action_required.name) {
    return const Color(0xFFF79009);
  } else if (status == PaymentStatus.payment_required.name) {
    return const Color(0xFF7A5AF8);
  } else if (status == PaymentStatus.failed.name) {
    return const Color(0xFFF04438);
  } else if (status == PaymentStatus.processing.name) {
    return const Color(0xFF2E90FA);
  }
  return const Color(0xFFF04438);
}

Color _getStatusBgColor(String status) {
  if (status == PaymentStatus.successful.name ||
      status == PaymentStatus.paye.name) {
    return const Color(0xFFECFDF3);
  } else if (status == PaymentStatus.pending.name) {
    return const Color(0xFFF2F4F7);
  } else if (status == PaymentStatus.action_required.name) {
    return const Color(0xFFFFFAEB);
  } else if (status == PaymentStatus.payment_required.name) {
    return const Color(0xFFF4F3FF);
  } else if (status == PaymentStatus.failed.name) {
    return const Color(0xFFFEF3F2);
  } else if (status == PaymentStatus.processing.name) {
    return const Color(0xFFEFF8FF);
  }
  return const Color(0xFFFEF3F2);
}

String getPaymentStatusName({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return "Effectué";
  } else if (status == PaymentStatus.pending.name) {
    return "En attente";
  } else if (status == PaymentStatus.action_required.name) {
    return "Action requise";
  } else if (status == PaymentStatus.payment_required.name) {
    return "Paiement requis";
  } else if (status == PaymentStatus.failed.name) {
    return "Échoué";
  } else if (status == PaymentStatus.processing.name) {
    return "En cours";
  } else if (status == PaymentStatus.paye.name) {
    return "Payé";
  }
  return "Échoué";
}

// Keep legacy helpers for backward compatibility
Widget getIconStatus({required String status}) {
  return Icon(_getStatusIcon(status), color: _getStatusColor(status), size: 18);
}

Color getColorStatus({required String status}) {
  return _getStatusBgColor(status);
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage>
    with ConnectivityMixin {
  late PagingController<int, PaymentItentData> _pagingController;

  @override
  void onConnectionRestored() {
    if (_pagingController.itemList == null ||
        _pagingController.itemList!.isEmpty) {
      _pagingController.error = 'temporary_error_to_force_refresh';
      _pagingController.refresh();
    }
  }

  Future<void> loadPage(int page) async {
    PaymentRepository()
        .getPayments(
      page: page,
      perPage: 5,
      orderBy: OrderByField.updatedAt.value,
      orderDir: OrderDir.desc.value,
    )
        .then((value) {
      if (value.hasNext == true) {
        _pagingController.appendPage(
            value.data ?? [], (value.currentPage)! + 1);
      } else {
        _pagingController.appendLastPage(value.data ?? []);
      }
    }).onError((error, stackTrace) {
      showConnectionErrorDialog();
    });
  }

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
    setupConnectivityListener();
  }

  @override
  void dispose() {
    disposeConnectivityListener();
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Historique des paiements'),
            // titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //       fontWeight: FontWeight.w700,
            //     ),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left, size: 24),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(HomePage.name);
                }
              },
            ),
            centerTitle: true,
            backgroundColor: AppColors.whiteBackground,
            surfaceTintColor: Colors.transparent,
            pinned: true,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: PagedSliverList<int, PaymentItentData>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  firstPageProgressIndicatorBuilder: (context) => Column(
                    children: List.generate(
                      6,
                      (index) => _buildShimmerCard(context),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) =>
                      _buildEmptyState(context),
                  itemBuilder: (context, item, index) =>
                      _buildPaymentCard(context, item),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120, height: 14, color: Colors.white),
                    const Gap(6),
                    Container(width: 80, height: 12, color: Colors.white),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 70, height: 14, color: Colors.white),
                  const Gap(6),
                  Container(
                      width: 60,
                      height: 22,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Gap(80),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLite,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Icon(Iconsax.receipt_item, size: 36, color: AppColors.primary),
          ),
          const Gap(24),
          Text(
            "Aucun paiement",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Gap(8),
          Text(
            "Vos transactions apparaîtront ici une fois que vous aurez effectué un paiement.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF667085),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, PaymentItentData item) {
    final statusColor = _getStatusColor(item.paymentStatus);
    final statusBg = _getStatusBgColor(item.paymentStatus);
    final statusIcon = _getStatusIcon(item.paymentStatus);
    final statusName = getPaymentStatusName(status: item.paymentStatus);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (item.collection == ProductType.hotel_reservation.name ||
              item.collection == ProductType.reverse_searches.name) {
            return;
          }
          showModalBottomSheet(
            backgroundColor: AppColors.whiteBackground,
            showDragHandle: true,
            enableDrag: true,
            isScrollControlled: true,
            useRootNavigator: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            context: context,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: (item.collection == ProductType.reservations.name)
                  ? BookingDetailPage(id: item.itemId)
                  : VisitDetailPage(id: item.itemId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF2F4F7)),
          ),
          child: Row(
            children: [
              // Logo opérateur
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFF2F4F7)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.network(
                    OrderPaymentController.getLogoURL(item.paymentMethod),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Iconsax.card,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const Gap(12),
              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.getServiceName(item.collection),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Gap(4),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: item.id))
                            .then((_) {
                          EasyLoading.showToast('Identifiant copié');
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Iconsax.copy,
                              size: 12, color: const Color(0xFF667085)),
                          const Gap(4),
                          Flexible(
                            child: Text(
                              item.itemId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFF667085),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              // Montant + statut
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Utils.formatCurrency(item.amount),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                  ),
                  const Gap(6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const Gap(4),
                        Text(
                          statusName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    Utils.formatDate(dateTime: item.updatedAt!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF98A2B3),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
