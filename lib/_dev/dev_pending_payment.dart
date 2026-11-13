import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/reservations/client_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/dates_reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_cubit.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:toastification/toastification.dart';

/// Cubit simulé avec données de test, sans appel réseau ni token.
class _FakePendingPaymentReservationsCubit
    extends PendingPaymentReservationsCubit {
  _FakePendingPaymentReservationsCubit(this._sampleItems)
      : super(ResidenceRepository(Dio()));

  final List<ReservationModel> _sampleItems;

  @override
  void init() {
    pagingController.addPageRequestListener((pageKey) {
      if (pagingController.itemList == null ||
          pagingController.itemList!.isEmpty) {
        pagingController.appendLastPage(_sampleItems);
      }
    });
    if (pagingController.itemList == null) {
      pagingController.appendLastPage(_sampleItems);
    }
  }

  @override
  void refreshList() {
    pagingController.refresh();
  }
}

List<ReservationModel> _samplePendingPaymentReservations() {
  final now = DateTime.now();
  final d1 = now.add(const Duration(days: 2));
  final d2 = now.add(const Duration(days: 5));
  final d3 = now.add(const Duration(days: 8));
  final d4 = now.add(const Duration(days: 12));

  return [
    ReservationModel(
      id: 'res_001',
      codeReservation: 'RES-84920',
      statusReservation: 'en_attente_paiement',
      dateDebut: d1.toIso8601String(),
      dateFin: d2.toIso8601String(),
      datesReservation: [
        DatesReservationModel(date: d1),
        DatesReservationModel(date: d1.add(const Duration(days: 1))),
        DatesReservationModel(date: d1.add(const Duration(days: 2))),
      ],
      montantTotalReservation: 150000,
      montantPaye: 150000,
      residence: const ResidenceModel(
        id: 'res_prop_1',
        nom: 'Studio Cosy Deux Plateaux',
        adresse: 'Deux Plateaux Vallon, Cocody, Abidjan',
        heureEntree: '14:00',
        heureDepart: '12:00',
      ),
      client: const ClientModel(
        id: 'cli_1',
        firstName: 'Marc',
        lastName: 'Kouassi',
      ),
    ),
    ReservationModel(
      id: 'res_002',
      codeReservation: 'RES-99381',
      statusReservation: 'en_attente_paiement',
      dateDebut: d3.toIso8601String(),
      dateFin: d4.toIso8601String(),
      datesReservation: [
        DatesReservationModel(date: d3),
        DatesReservationModel(date: d3.add(const Duration(days: 1))),
        DatesReservationModel(date: d3.add(const Duration(days: 2))),
        DatesReservationModel(date: d3.add(const Duration(days: 3))),
      ],
      montantTotalReservation: 375000,
      montantPaye: 375000,
      residence: const ResidenceModel(
        id: 'res_prop_2',
        nom: 'Duplex Prestige Zone 4',
        adresse: 'Rue du 7 Décembre, Zone 4, Marcory',
        heureEntree: '15:00',
        heureDepart: '11:00',
      ),
      client: const ClientModel(
        id: 'cli_2',
        firstName: 'Marc',
        lastName: 'Kouassi',
      ),
    ),
  ];
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final router = GoRouter(
    initialLocation: '/menu',
    routes: [
      GoRoute(
        path: '/menu',
        builder: (context, state) => const _DevMenu(),
      ),
      GoRoute(
        path: '/pending-payment',
        name: PendingPaymentReservationsPage.name,
        builder: (context, state) => PendingPaymentReservationsPage(
          cubit: _FakePendingPaymentReservationsCubit(
            _samplePendingPaymentReservations(),
          ),
        ),
      ),
      GoRoute(
        path: '/pending-payment-empty',
        builder: (context, state) => PendingPaymentReservationsPage(
          cubit: _FakePendingPaymentReservationsCubit(const []),
        ),
      ),
      GoRoute(
        path: '/payment-operators',
        name: OperatorsSelectorPage.name,
        builder: (context, state) {
          final adapter = state.extra as PaymentPageAdapter?;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mode de paiement (Simulé)'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Navigation vers le paiement réussie !',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Montant : ${adapter?.amount ?? 0} FCFA\nItem ID : ${adapter?.itemId ?? "N/A"}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  );

  runApp(
    MaterialApp.router(
      title: 'Harnais · Réservations à payer (Client)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: AppTypography.lightTextTheme(),
        useMaterial3: false,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.whiteBackground,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.immoBrandSecondary,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      routerConfig: router,
      builder: (context, child) => ToastificationWrapper(
        child: EasyLoading.init()(context, child),
      ),
    ),
  );
}

class _DevMenu extends StatelessWidget {
  const _DevMenu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harnais Dev · ImmoPlus Client'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.blue),
              title: const Text('Réservations à payer (avec données)'),
              subtitle: const Text('2 réservations en attente de paiement'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/pending-payment'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.inbox, color: Colors.grey),
              title: const Text('Réservations à payer (liste vide)'),
              subtitle: const Text('Vue quand tout est à jour'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/pending-payment-empty'),
            ),
          ],
        ),
      ),
    );
  }
}
