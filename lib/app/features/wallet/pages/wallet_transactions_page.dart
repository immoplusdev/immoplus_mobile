import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/repositories/wallet_repository.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';
import 'package:immoplus/app/features/wallet/widgets/paged_wallet_list.dart';
import 'package:immoplus/app/features/wallet/widgets/wallet_tiles.dart';

/// Liste complète des opérations du coffre.
class WalletTransactionsPage extends StatelessWidget {
  const WalletTransactionsPage({super.key});

  static const String name = 'WALLET_TRANSACTIONS_PAGE';
  static String routePath() => '/wallet/transactions';

  @override
  Widget build(BuildContext context) {
    final repository = getIt<WalletRepository>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        title: const Text('Dernières opérations'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        leading: BackButton(color: AppColors.black),
      ),
      body: PagedWalletList<WalletTransactionModel>(
        fetchPage: (page) => repository.getMyTransactions(page: page),
        emptyMessage: 'Aucune opération pour le moment.',
        itemBuilder: (context, item) =>
            WalletTransactionTile(transaction: item),
        showDividers: false,
      ),
    );
  }
}
