import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/data/enums/booking_mode.dart';
import 'package:immoplus/app/data/models/remote/booking_mode/booking_mode_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/payment_requirement.dart';
import 'package:immoplus/app/data/repositories/booking_mode_repository.dart';
import 'package:immoplus/app/features/booking_mode/booking_mode_cubit.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';

class _FakeBookingModeRepository implements BookingModeRepository {
  _FakeBookingModeRepository(this.result);

  final Object result;

  @override
  Future<BookingModeModel> getBookingMode() async {
    if (result is BookingModeModel) return result as BookingModeModel;
    throw result;
  }
}

void main() {
  group('BookingMode', () {
    test('libellés des boutons', () {
      expect(BookingMode.payNow.ctaLabel, 'Payer');
      expect(BookingMode.request.ctaLabel, 'Réserver');
    });

    test('valeur inconnue ou absente → REQUEST (comportement historique)', () {
      expect(BookingMode.fromValue('PAY_NOW'), BookingMode.payNow);
      expect(BookingMode.fromValue('N_IMPORTE_QUOI'), BookingMode.request);
      expect(BookingMode.fromValue(null), BookingMode.request);
    });

    test('BookingModeModel lit la réponse enveloppée dans data', () {
      final model = BookingModeModel.fromJson({
        'data': {
          'mode': 'PAY_NOW',
          'level': 'CRITIQUE',
          'reasonCode': 'CANCELLATION_THRESHOLD_REACHED',
          'reason': 'Seuil atteint.',
        }
      });
      expect(model.mode, BookingMode.payNow);
      expect(model.reasonCode, 'CANCELLATION_THRESHOLD_REACHED');
    });
  });

  group('BookingModeCubit', () {
    test('démarre en REQUEST puis suit le serveur', () async {
      final cubit = BookingModeCubit.withInitial(
          _FakeBookingModeRepository(
              const BookingModeModel(mode: BookingMode.payNow)),
          BookingMode.request);
      expect(cubit.state, BookingMode.request);
      await cubit.refresh();
      expect(cubit.state, BookingMode.payNow);
      await cubit.close();
    });

    test('échec silencieux : le mode courant est conservé', () async {
      final cubit = BookingModeCubit.withInitial(
          _FakeBookingModeRepository(Exception('404')), BookingMode.payNow);
      await cubit.refresh();
      // Endpoint indisponible : le mode initial (forcé en debug) est gardé.
      expect(cubit.state, BookingMode.payNow);
      await cubit.close();
    });

    test('reset (déconnexion) → REQUEST', () async {
      final cubit = BookingModeCubit.withInitial(
          _FakeBookingModeRepository(
              const BookingModeModel(mode: BookingMode.payNow)),
          BookingMode.request);
      await cubit.refresh();
      cubit.reset();
      expect(cubit.state, BookingMode.request);
      await cubit.close();
    });
  });

  group('PaymentRequirement', () {
    test('paiement complet (exemple Swagger)', () {
      final requirement = PaymentRequirementResponse.fromJson({
        'data': {
          'requirement': 'FULL',
          'mode': 'FULL_ONLINE',
          'currency': 'XOF',
          'totalAmount': 90000,
          'amountDueNow': 90000,
          'remainingAmount': 0,
          'paymentOnArrivalEligible': false,
          'expiresAt': '2026-11-08T12:37:43.872Z',
          'protectionMessage': 'Message serveur',
        }
      }).data;
      expect(requirement.isPaymentDue, isTrue);
      expect(requirement.isDeposit, isFalse);
      expect(requirement.requirement.depositPercent, isNull);
      expect(requirement.amountDueNow, 90000);
      expect(requirement.protectionMessage, 'Message serveur');
    });

    test('acompte de 25 %', () {
      final requirement = PaymentRequirement.fromJson({
        'requirement': 'DEPOSIT_25',
        'mode': 'DEPOSIT',
        'totalAmount': 75000,
        'amountDueNow': 18750,
        'remainingAmount': 56250,
      });
      expect(requirement.isDeposit, isTrue);
      expect(requirement.requirement.depositPercent, 25);
      expect(requirement.remainingAmount, 56250);
    });

    test('aucun paiement demandé : rien à payer maintenant', () {
      final requirement = PaymentRequirement.fromJson({
        'requirement': 'NONE',
        'mode': 'ON_ARRIVAL',
        'totalAmount': 50000,
        'amountDueNow': 0,
        'remainingAmount': 50000,
      });
      expect(requirement.isPaymentDue, isFalse);
    });

    test('valeurs d\'énumération inconnues → paiement complet', () {
      final requirement = PaymentRequirement.fromJson({
        'requirement': 'DEPOSIT_99',
        'mode': 'AUTRE',
        'amountDueNow': 1000,
      });
      expect(requirement.requirement, PaymentRequirementLevel.full);
      expect(requirement.mode, PaymentRequirementMode.fullOnline);
    });
  });

  group('Coffre', () {
    test('WalletModel', () {
      final wallet = WalletModel.fromJson({
        'data': {
          'availableBalance': 12500,
          'pendingBalance': 3000.5,
          'currency': 'XOF',
        }
      });
      expect(wallet.availableBalance, 12500);
      expect(wallet.pendingBalance, 3000.5);
      expect(wallet.canWithdraw, isTrue);
      expect(
        const WalletModel(
                availableBalance: 0, pendingBalance: 10, currency: 'XOF')
            .canWithdraw,
        isFalse,
      );
    });

    test('mouvements paginés et sens du montant', () {
      final page = PagedResult.fromJson({
        'data': [
          {
            'id': '1',
            'amount': 5000,
            'type': 'CREDIT',
            'createdAt': '2026-11-01T10:00:00Z'
          },
          {'id': '2', 'amount': 1000, 'type': 'WITHDRAWAL'},
          {'id': '3', 'amount': 1, 'type': 'NOUVEAU_TYPE'},
        ],
        'hasNext': true,
      }, WalletTransactionModel.fromJson);
      expect(page.hasNext, isTrue);
      expect(page.items, hasLength(3));
      expect(page.items[0].type.isIncoming, isTrue);
      expect(page.items[1].type.isIncoming, isFalse);
      expect(page.items[2].type, WalletTransactionType.unknown);
    });

    test('demandes de retrait : statuts', () {
      expect(WithdrawalStatus.fromValue('PENDING'), WithdrawalStatus.pending);
      expect(
          WithdrawalStatus.fromValue('completed'), WithdrawalStatus.completed);
      expect(WithdrawalStatus.fromValue('???'), WithdrawalStatus.unknown);
    });

    test('corps de la demande de retrait', () {
      const body = WithdrawalRequestBody(
        amount: 10000,
        phoneNumber: '+2250700000000',
        operator: 'wave',
        note: ' Retrait ',
      );
      expect(body.toJson(), {
        'amount': 10000,
        'currency': 'XOF',
        'phoneNumber': '+2250700000000',
        'operator': 'wave',
        'note': 'Retrait',
      });
    });
  });
}
