import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});
  static String name = 'PAYMENTHISTORYPAGE';

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

Widget getIconStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return const Icon(
      Icons.check_circle_outline,
      color: Colors.green,
    );
  } else if (status == PaymentStatus.pending.name) {
    return const Icon(
      Icons.access_time_filled,
      color: Colors.grey,
    );
  } else if (status == PaymentStatus.action_required.name) {
    return const Icon(
      Icons.timer,
      color: Colors.orange,
    );
  } else if (status == PaymentStatus.payment_required.name) {
    return const Icon(
      Icons.payments_outlined,
      color: Colors.purple,
    );
  } else if (status == PaymentStatus.failed.name) {
    return const Icon(
      Icons.close,
      color: Colors.red,
    );
  } else if (status == PaymentStatus.processing.name) {
    return const Icon(
      Icons.rocket_launch_outlined,
      color: Colors.blue,
    );
  } else if (status == PaymentStatus.paye.name) {
    return const Icon(Icons.check_circle_outline, color: Colors.green);
  }
  return const Icon(Icons.close, color: Colors.red);
}

Color getColorStatus({required String status}) {
  if (status == PaymentStatus.successful.name) {
    return Colors.green.shade100;
  } else if (status == PaymentStatus.pending.name) {
    return Colors.grey.shade100;
  } else if (status == PaymentStatus.action_required.name) {
    return Colors.orange.shade100;
  } else if (status == PaymentStatus.payment_required.name) {
    return Colors.purple.shade100;
  } else if (status == PaymentStatus.failed.name) {
    return Colors.red.shade100;
  } else if (status == PaymentStatus.processing.name) {
    return Colors.blue.shade100;
  } else if (status == PaymentStatus.paye.name) {
    return Colors.green.shade100;
  }
  return Colors.red.shade200;
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

late PagingController<int, PaymentItentData> _pagingController;
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
      _pagingController.appendPage(value.data ?? [], (value.currentPage)! + 1);
    } else {
      _pagingController.appendLastPage(value.data ?? []);
    }
    //change(value, status: RxStatus.success());
  }).onError((error, stackTrace) {
    _pagingController.error = error.toString();
  });
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      loadPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Historique des paiements'),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            backgroundColor: AppColors.scafold,
            pinned: true,
          ),
          CupertinoSliverRefreshControl(
            //      backgroundColor: Colors.white,
            // color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),
          PagedSliverList<int, PaymentItentData>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                firstPageProgressIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        period: const Duration(milliseconds: 500),
                        child: ListTile(
                            tileColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29)),
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(
                                  OrderPaymentController.selectedOperator.logo),
                            ),
                            title: const Text(
                              '•••••••••••••••',
                            ),
                            subtitle: const Text(
                              "••••• F",
                            ),
                            titleTextStyle:
                                Theme.of(context).textTheme.bodyLarge,
                            subtitleTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                            trailing: Chip(
                              avatar: getIconStatus(
                                  status: PaymentStatus.failed.name),
                              backgroundColor: getColorStatus(
                                  status: PaymentStatus.failed.name),
                              label: const Text('En attente'),
                            )),
                      ),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(
                  "Aucun élément trouvé",
                  style: Theme.of(context).textTheme.titleLarge,
                )),
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: AppColors.scafold,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: (item.collection ==
                                    ServicesCollection.reservations.name)
                                ? BookingDetailPage(
                                    id: item.itemId,
                                  )
                                : VisitDetailPage(
                                    id: item.itemId,
                                  ),
                          ),
                        );
                      },
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29)),
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                            OrderPaymentController.getLogoURL(
                                item.paymentMethod)),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Utils.getServiceName(item.collection)),
                          const Gap(3),
                          SelectableText(
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.purple,
                                    ),
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: item.id))
                                  .then((value) {
                                //Vibrate.feedback(FeedbackType.impact);
                                EasyLoading.showToast('Identifiant copié');
                              }).catchError((err) {
                                EasyLoading.showToast(err.toString());
                              });
                            },
                            item.itemId,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        Utils.formatCurrency(item.amount),
                      ),
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                      subtitleTextStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                      trailing: SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AutoSizeText(
                                Utils.formatDate(dateTime: item.updatedAt!)),
                            Flexible(
                              child: Chip(
                                avatar:
                                    getIconStatus(status: item.paymentStatus),
                                backgroundColor:
                                    getColorStatus(status: item.paymentStatus),
                                label: Text(getPaymentStatusName(
                                    status: item.paymentStatus)),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
