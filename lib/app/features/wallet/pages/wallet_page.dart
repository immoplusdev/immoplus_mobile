import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/logic/wallet_cubit.dart';
import 'package:immoplus/app/features/wallet/pages/wallet_transactions_page.dart';
import 'package:immoplus/app/features/wallet/pages/withdrawal_request_page.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_balance_card.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_formatters.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_style.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_tiles.dart';

/// Coffre du client : crédit disponible, dernières opérations et demandes de
/// remboursement.
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

class _WalletView extends StatelessWidget {
  const _WalletView();

  Future<void> _openWithdrawal(BuildContext context, WalletModel wallet) async {
    final created = await context.pushNamed<bool>(
      WithdrawalRequestPage.name,
      extra: wallet,
    );
    if (created == true && context.mounted) {
      context.read<WalletCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('ESPACE CLIENT'),
        titleTextStyle: AppTypography.font(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: WalletColors.textSecondary,
        ),
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
          WalletLoaded() => _buildContent(context, state),
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletLoaded state) {
    final wallet = state.wallet;
    return RefreshIndicator(
      onRefresh: () => context.read<WalletCubit>().load(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          14,
          8,
          14,
          48 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          Text(
            'Coffre client',
            style: AppTypography.font(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: WalletColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Retrouvez vos crédits et suivez chaque opération.',
            style: AppTypography.font(
              fontSize: 13,
              color: WalletColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const _ExplainerCard(
            title: 'Pourquoi le bouton « Réserver » peut devenir « Payer » ?',
            message:
                'Après plusieurs annulations récentes, un acompte peut être '
                'demandé avant de confirmer une nouvelle réservation. Le '
                'montant et les conditions sont affichés avant le paiement.',
          ),
          const SizedBox(height: 16),
          WalletBalanceCard(
            wallet: wallet,
            onWithdraw: () => _openWithdrawal(context, wallet),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Crédité dans le coffre',
                  value: formatAmountDotted(
                    wallet.availableBalance + wallet.pendingBalance,
                    currency: wallet.currency,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Demandes en attente',
                  value: '${state.pendingWithdrawalsCount}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _ExplainerCard(
            message: 'Si un séjour payé ne peut pas aboutir à cause du '
                'propriétaire ou d\'une indisponibilité confirmée, le montant '
                'encaissé est crédité dans votre coffre. Le remboursement vers '
                'votre portefeuille mobile est ensuite traité séparément.',
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Dernières opérations',
                  style: AppTypography.font(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: WalletColors.textPrimary,
                  ),
                ),
              ),
              if (state.recentTransactions.isNotEmpty)
                GestureDetector(
                  onTap: () => context.pushNamed(WalletTransactionsPage.name),
                  child: Text(
                    'Tout voir',
                    style: AppTypography.font(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WalletColors.brand,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.recentTransactions.isEmpty)
            const _EmptyText('Aucune opération pour le moment.')
          else
            for (final transaction in state.recentTransactions)
              WalletTransactionTile(transaction: transaction),
          const SizedBox(height: 22),
          Text(
            'Mes demandes de remboursement',
            style: AppTypography.font(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: WalletColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          if (state.recentWithdrawals.isEmpty)
            const _EmptyText('Aucune demande pour le moment.')
          else
            for (final request in state.recentWithdrawals)
              WithdrawalRequestTile(request: request),
        ],
      ),
    );
  }
}

/// Encadré vert d'explication (titre facultatif + texte).
class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({this.title, required this.message});

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: WalletColors.mintBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: WalletColors.mintIconBackground,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check, size: 13, color: WalletColors.mintIcon),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTypography.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: WalletColors.mintTitle,
                    ),
                  ),
                  const SizedBox(height: 1),
                ],
                Text(
                  message,
                  style: AppTypography.font(
                    fontSize: 12,
                    height: 1.3,
                    color: WalletColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WalletColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.font(
              fontSize: 12,
              color: WalletColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.font(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: WalletColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTypography.font(
          fontSize: 13,
          color: WalletColors.textSecondary,
        ),
      );
}
