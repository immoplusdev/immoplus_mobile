import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/features/for_you/logic/for_you_cubit.dart';
import 'package:immoplus/app/features/for_you/logic/for_you_state.dart';
import 'package:immoplus/app/features/for_you/widgets/for_you_section_view.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/tickets_cards/load_product_card.dart';

/// Corps de l'onglet "Pour vous" — flux mixte agrégé via `GET /me/home`
/// (voir HOME FEED AGREGATOR.MD). Sliver autonome, au même titre que
/// `ResidencesList`/`EstatesList` pour les autres onglets.
class ForYouView extends StatefulWidget {
  const ForYouView({super.key});

  @override
  State<ForYouView> createState() => _ForYouViewState();
}

class _ForYouViewState extends State<ForYouView> {
  @override
  void initState() {
    super.initState();
    context.read<ForYouCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForYouCubit, ForYouState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          loading: () => SliverToBoxAdapter(child: _LoadingShimmer()),
          error: (message) => SliverToBoxAdapter(
            child: _ErrorState(onRetry: () => context.read<ForYouCubit>().fetch()),
          ),
          success: (sections, hasMore, nextCursor, isLoadingMore) {
            if (sections.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= sections.length) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: isLoadingMore
                            ? CircularProgressIndicator(color: AppColors.primary)
                            : const SizedBox.shrink(),
                      ),
                    );
                  }
                  if (index == sections.length - 2 && hasMore && !isLoadingMore) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) context.read<ForYouCubit>().loadMore();
                    });
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: kHomeSectionSpacing),
                    child: ForYouSectionView(section: sections[index]),
                  );
                },
                childCount: sections.length + (hasMore ? 1 : 0),
              ),
            );
          },
        );
      },
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: compactResidenceCardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 3,
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) =>
                    SizedBox(width: neirResidenceCardWidth, child: LoadProductCard()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Impossible de charger le contenu',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            TextButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
