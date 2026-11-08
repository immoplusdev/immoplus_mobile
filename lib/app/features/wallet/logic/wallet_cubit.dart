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
  const WalletLoaded(this.wallet);

  final WalletModel wallet;
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
      if (!isClosed) emit(WalletLoaded(wallet));
    } catch (e) {
      if (!isClosed && state is! WalletLoaded) {
        emit(WalletFailure(AppErrorMapper.from(e)));
      }
    }
  }
}
