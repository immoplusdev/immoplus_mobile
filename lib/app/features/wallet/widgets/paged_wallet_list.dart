import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/wallet/data/wallet_models.dart';

/// Liste paginée du coffre (mouvements, demandes de retrait) : chargement
/// page par page, état vide, erreur avec « Réessayer » dans la liste.
class PagedWalletList<T> extends StatefulWidget {
  const PagedWalletList({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    required this.emptyMessage,
    this.pageSize = 20,
    this.showDividers = true,
  });

  final Future<PagedResult<T>> Function(int page) fetchPage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final int pageSize;
  final bool showDividers;

  @override
  State<PagedWalletList<T>> createState() => _PagedWalletListState<T>();
}

class _PagedWalletListState<T> extends State<PagedWalletList<T>> {
  final PagingController<int, T> _controller =
      PagingController<int, T>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _controller.addPageRequestListener(_load);
  }

  Future<void> _load(int page) async {
    try {
      final result = await widget.fetchPage(page);
      if (!mounted) return;
      result.hasNext
          ? _controller.appendPage(result.items, page + 1)
          : _controller.appendLastPage(result.items);
    } catch (e) {
      if (mounted) _controller.error = e;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _controller.refresh(),
      child: PagedListView<int, T>.separated(
        pagingController: _controller,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        separatorBuilder: (_, __) => showDividersSeparator(widget.showDividers),
        builderDelegate: PagedChildBuilderDelegate<T>(
          itemBuilder: (context, item, _) => widget.itemBuilder(context, item),
          noItemsFoundIndicatorBuilder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Text(
              widget.emptyMessage,
              textAlign: TextAlign.center,
              style: AppTypography.font(
                fontSize: 14,
                height: 1.5,
                color: AppColors.immoTextSecondary,
              ),
            ),
          ),
          firstPageErrorIndicatorBuilder: (_) => AppErrorState(
            error: AppErrorMapper.from(_controller.error ?? Object()),
            context: ErrorContext.walletLoad,
            onRetry: _controller.refresh,
          ),
          newPageErrorIndicatorBuilder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TextButton(
                onPressed: _controller.retryLastFailedRequest,
                child: const Text('Réessayer'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget showDividersSeparator(bool show) => show
    ? Divider(height: 1, color: AppColors.gray200)
    : const SizedBox.shrink();
