import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/data/repositories/wallet_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/logic/wallet_cubit.dart';
import 'package:immoplus/app/features/wallet/pages/withdrawal_request_page.dart';
import 'package:immoplus/app/features/wallet/widgets/paged_wallet_list.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_balance_card.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';

/// Coffre du client : solde, mouvements et demandes de retrait.
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  static const String name = 'WALLET_PAGE';
  static String routePath() => '/wallet';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletCubit>()..load(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  final _repository = getIt<WalletRepository>();

  /// Change après un retrait pour recharger les listes.
  int _refreshToken = 0;

  Future<void> _openWithdrawal(WalletModel wallet) async {
    final created = await context.pushNamed<bool>(
      WithdrawalRequestPage.name,
      extra: wallet,
    );
    if (created == true && mounted) {
      setState(() => _refreshToken++);
      context.read<WalletCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          title: const Text('Mon coffre'),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          leading: BackButton(color: AppColors.black),
        ),
        body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) => switch (state) {
            WalletLoading() =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            WalletFailure(:final error) => AppErrorState(
                error: error,
                context: ErrorContext.walletLoad,
                onRetry: () => context.read<WalletCubit>().load(),
              ),
            WalletLoaded(:final wallet) => _buildContent(wallet),
          },
        ),
      ),
    );
  }

  Widget _buildContent(WalletModel wallet) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: WalletBalanceCard(
            wallet: wallet,
            onWithdraw: () => _openWithdrawal(wallet),
          ),
        ),
        TabBar(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.immoTextSecondary,
          indicatorColor: AppColors.primary,
          labelStyle:
              AppTypography.font(fontSize: 14, fontWeight: FontWeight.w700),
          tabs: const [Tab(text: 'Mouvements'), Tab(text: 'Retraits')],
        ),
        Expanded(
          child: TabBarView(
            children: [
              PagedWalletList<WalletTransactionModel>(
                key: ValueKey('transactions_$_refreshToken'),
                fetchPage: (page) => _repository.getMyTransactions(page: page),
                emptyMessage:
                    'Aucun mouvement pour le moment. Les montants conservés '
                    'ou crédités sur votre coffre apparaîtront ici.',
                itemBuilder: (context, item) =>
                    _TransactionTile(transaction: item),
              ),
              PagedWalletList<WithdrawalRequestModel>(
                key: ValueKey('withdrawals_$_refreshToken'),
                fetchPage: (page) =>
                    _repository.getMyWithdrawalRequests(page: page),
                emptyMessage: 'Vous n\'avez fait aucune demande de retrait.',
                itemBuilder: (context, item) => _WithdrawalTile(request: item),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final incoming = transaction.type.isIncoming;
    final color = incoming ? AppColors.immoFeedbackSuccess : AppColors.slate900;
    final title = (transaction.note?.trim().isNotEmpty ?? false)
        ? transaction.note!.trim()
        : transaction.type.label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              incoming ? Iconsax.arrow_down_2 : Iconsax.arrow_up_3,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.font(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatMovementDate(transaction.createdAt),
                  style: AppTypography.font(
                      fontSize: 12, color: AppColors.slate500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${incoming ? '+' : '-'}${formatAmount(transaction.amount, currency: transaction.currency)}',
            style: AppTypography.font(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawalTile extends StatelessWidget {
  const _WithdrawalTile({required this.request});

  final WithdrawalRequestModel request;

  Color get _statusColor => switch (request.status) {
        WithdrawalStatus.completed ||
        WithdrawalStatus.approved =>
          AppColors.immoFeedbackSuccess,
        WithdrawalStatus.rejected ||
        WithdrawalStatus.failed =>
          AppColors.immoFeedbackError,
        _ => AppColors.amber800,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatAmount(request.amount, currency: request.currency),
                  style: AppTypography.font(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatMovementDate(request.createdAt),
                  style: AppTypography.font(
                      fontSize: 12, color: AppColors.slate500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              request.status.label,
              style: AppTypography.font(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
