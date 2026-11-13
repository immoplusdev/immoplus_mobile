import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/data/repositories/wallet_repository.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:injectable/injectable.dart';

sealed class WithdrawalState {
  const WithdrawalState();
}

final class WithdrawalIdle extends WithdrawalState {
  const WithdrawalIdle();
}

final class WithdrawalSubmitting extends WithdrawalState {
  const WithdrawalSubmitting();
}

final class WithdrawalSuccess extends WithdrawalState {
  const WithdrawalSuccess(this.request);

  final WithdrawalRequestModel request;
}

/// L'écran distingue les erreurs de validation (affichées sous les champs)
/// des autres (présentées par le feedback global).
final class WithdrawalFailure extends WithdrawalState {
  const WithdrawalFailure(this.error);

  final AppError error;
}

/// Création d'une demande de retrait. Le coffre n'est pas débité à la
/// demande : le serveur traite le retrait ensuite.
@injectable
class WithdrawalCubit extends Cubit<WithdrawalState> {
  WithdrawalCubit(this._repository) : super(const WithdrawalIdle());

  final WalletRepository _repository;

  Future<void> submit(WithdrawalRequestBody body) async {
    if (state is WithdrawalSubmitting) return;
    emit(const WithdrawalSubmitting());
    try {
      final request = await _repository.createWithdrawalRequest(body);
      if (!isClosed) emit(WithdrawalSuccess(request));
    } catch (e) {
      if (!isClosed) emit(WithdrawalFailure(AppErrorMapper.from(e)));
    }
  }
}
