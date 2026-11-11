import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/data/repositories/wallet_repository.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:injectable/injectable.dart';

sealed class WalletState {
  const WalletState();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoaded extends WalletState {
  const WalletLoaded(
    this.wallet, {
    this.recentTransactions = const [],
    this.recentWithdrawals = const [],
  });

  final WalletModel wallet;

  /// Dernières opérations (aperçu de l'écran ; la liste complète est paginée).
  final List<WalletTransactionModel> recentTransactions;
  final List<WithdrawalRequestModel> recentWithdrawals;

  int get pendingWithdrawalsCount => recentWithdrawals
      .where((r) => r.status == WithdrawalStatus.pending)
      .length;
}

final class WalletFailure extends WalletState {
  const WalletFailure(this.error);

  final AppError error;
}

/// Solde du coffre. L'écran affiche l'erreur de chargement avec
/// « Réessayer » (état inline), sans dialogue par-dessus.
@injectable
class WalletCubit extends Cubit<WalletState> {
  WalletCubit(this._repository) : super(const WalletLoading());

  final WalletRepository _repository;

  Future<void> load() async {
    // Un rafraîchissement garde le solde affiché plutôt que de le masquer.
    if (state is! WalletLoaded) emit(const WalletLoading());
    try {
      final wallet = await _repository.getMyWallet();
      // Les aperçus sont facultatifs : leur échec ne masque pas le solde.
      final transactions = await _repository
          .getMyTransactions(page: 1, perPage: 5)
          .then((r) => r.items)
          .catchError((_) => <WalletTransactionModel>[]);
      final withdrawals = await _repository
          .getMyWithdrawalRequests(page: 1, perPage: 5)
          .then((r) => r.items)
          .catchError((_) => <WithdrawalRequestModel>[]);
      if (!isClosed) {
        emit(WalletLoaded(
          wallet,
          recentTransactions: transactions,
          recentWithdrawals: withdrawals,
        ));
      }
    } catch (e) {
      if (!isClosed && state is! WalletLoaded) {
        emit(WalletFailure(AppErrorMapper.from(e)));
      }
    }
  }
}
