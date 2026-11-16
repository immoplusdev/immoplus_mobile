import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';

class MyPaymentsPage extends StatefulWidget {
  final int initialTabIndex;
  final String? reservationId;

  const MyPaymentsPage({
    super.key,
    this.initialTabIndex = 0,
    this.reservationId,
  });

  static const String name = 'MY_PAYMENTS_PAGE';
  static String routePath() => '/my-payments';
  static String route({int initialTabIndex = 0, String? reservationId}) {
    final params = <String, String>{
      if (initialTabIndex != 0) 'tab': '$initialTabIndex',
      if (reservationId != null) 'reservationId': reservationId,
    };
    if (params.isEmpty) return routePath();
    return Uri(path: routePath(), queryParameters: params).toString();
  }

  @override
  State<MyPaymentsPage> createState() => _MyPaymentsPageState();
}

class _MyPaymentsPageState extends State<MyPaymentsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: const Text('Mes paiements'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.whiteBackground,
        surfaceTintColor: AppColors.transparent,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.immoBorderDefault,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.immoTextSecondary,
                  labelStyle: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: AppColors.transparent,
                  tabs: const [
                    Tab(text: 'Réservation à payer'),
                    Tab(text: 'Paiements'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PendingPaymentReservationsPage(
                    embedded: true,
                    reservationId: widget.reservationId,
                  ),
                  const PaymentHistoryPage(
                    embedded: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
