import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_success_page.dart';
import 'package:immoplus/app/features/alert/widgets/alert_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/widgets/custom_empty_state.dart';

class AlertListPage extends StatefulWidget {
  final bool embedded;
  const AlertListPage({super.key, this.embedded = false});
  static const String routePath = '/alerts';
  static const String name = 'ALERT_LIST_PAGE';

  @override
  State<AlertListPage> createState() => _AlertListPageState();
}

enum AlertStatusTab {
  all('Toutes', null),
  pending('En attente', 'en_attente'),
  propositions('Propositions', 'propositions'),
  closed('Clôturées', 'cloturees');

  final String label;
  final String? value;
  const AlertStatusTab(this.label, this.value);
}

/// `extra` de la route `AlertStatusListPage` — titre + filtre de statut
/// pour l'une des 4 cartes du hub bento "J'emménage".
class AlertStatusArgs {
  final String title;
  final String? status;
  const AlertStatusArgs(this.title, this.status);
}

/// Page dédiée pour un statut donné, ouverte depuis une carte du hub bento
/// — même principe que `RelaisMyPage`/`RelaisMarketplacePage` côté "Je
/// déménage" : chaque carte du hub mène à sa propre page plutôt qu'à un
/// sous-onglet.
class AlertStatusListPage extends StatefulWidget {
  final String title;
  final String? status;
  const AlertStatusListPage({super.key, required this.title, this.status});
  static const String name = 'ALERT_STATUS_LIST_PAGE';
  static const String routePath = '/alerts/status';

  @override
  State<AlertStatusListPage> createState() => _AlertStatusListPageState();
}

class _AlertStatusListPageState extends State<AlertStatusListPage> {
  final _refreshNotifier = ValueNotifier<int>(0);
  bool _hasAlerts = false;

  @override
  void dispose() {
    _refreshNotifier.dispose();
    super.dispose();
  }

  Future<void> _createNewAlert() async {
    final result = await context.pushNamed(AlertCreateEditPage.name);
    if (result == true && mounted) {
      await context.pushNamed(AlertSuccessPage.name);
    }
    _refreshNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: AppTypography.font(
              fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        centerTitle: true,
      ),
      body: _AlertListContent(
        status: widget.status,
        refreshNotifier: _refreshNotifier,
        onAlertsLoaded: (alerts) {
          if (mounted) setState(() => _hasAlerts = alerts.isNotEmpty);
        },
      ),
      floatingActionButton: _hasAlerts
          ? FloatingActionButton(
              onPressed: _createNewAlert,
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 0,
              child: const Icon(Icons.add, color: AppColors.white, size: 32),
            )
          : null,
    );
  }
}

class _AlertHubItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? status;

  const _AlertHubItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
  });
}

final List<_AlertHubItem> _alertHubItems = [
  _AlertHubItem(
    title: 'Toutes',
    subtitle: 'Toutes mes demandes',
    icon: Iconsax.document_text,
    color: AppColors.primary,
    status: null,
  ),
  _AlertHubItem(
    title: 'En attente',
    subtitle: 'Pas encore de proposition',
    icon: Iconsax.clock,
    color: AppColors.immoFeedbackWarning,
    status: 'en_attente',
  ),
  _AlertHubItem(
    title: 'Propositions',
    subtitle: 'Offres reçues des pros',
    icon: Iconsax.gift,
    color: AppColors.green500,
    status: 'propositions',
  ),
  _AlertHubItem(
    title: 'Clôturées',
    subtitle: 'Demandes terminées',
    icon: Iconsax.archive_tick,
    color: AppColors.gray500,
    status: 'cloturees',
  ),
];

/// Hub bento "J'emménage" (dans Imatch) — même pattern que "Je déménage" :
/// une carte par statut, chacune ouvre sa propre page (`AlertStatusListPage`)
/// au lieu de sous-onglets.
class _AlertHub extends StatelessWidget {
  const _AlertHub();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: _alertHubItems.length,
            itemBuilder: (context, index) =>
                _AlertHubCard(item: _alertHubItems[index]),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.immoFeedbackWarning.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Iconsax.lamp_charge,
                    color: AppColors.immoFeedbackWarning, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Publiez une demande et recevez des propositions des professionnels selon vos critères.",
                    style: AppTypography.font(
                        fontSize: 12,
                        color: AppColors.immoTextLabel,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AlertHubCard extends StatelessWidget {
  final _AlertHubItem item;
  const _AlertHubCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed(
        AlertStatusListPage.name,
        extra: AlertStatusArgs(item.title, item.status),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.immoBorderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const Spacer(),
            Text(
              item.title,
              style:
                  AppTypography.font(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              item.subtitle,
              style: AppTypography.font(
                  fontSize: 12, color: AppColors.immoTextSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertListPageState extends State<AlertListPage>
    with SingleTickerProviderStateMixin {
  final alertRepository = getIt<AlertRepository>();
  late TabController _tabController;
  final ValueNotifier<int> _refreshNotifier = ValueNotifier<int>(0);
  List<AlertModel> _allAlerts = [];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: AlertStatusTab.values.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshNotifier.dispose();
    super.dispose();
  }

  void _refresh() {
    _refreshNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return const _AlertHub();
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: widget.embedded
          ? null
          : AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppColors.black, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.embedded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes demandes',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  const Gap(4),
                  _buildSummaryText(),
                ],
              ),
            ),
            const Gap(24),
          ],
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.transparent,
            dividerColor: AppColors.transparent,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            tabs: AlertStatusTab.values
                .map((tab) => _buildTabItem(tab.label, tab.index))
                .toList(),
          ),
          const Gap(16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: AlertStatusTab.values
                  .map((tab) => _AlertListContent(
                        status: tab.value,
                        refreshNotifier: _refreshNotifier,
                        onAlertsLoaded: tab == AlertStatusTab.all
                            ? (alerts) => setState(() => _allAlerts = alerts)
                            : null,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.embedded
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final result =
                    await context.pushNamed(AlertCreateEditPage.name);
                if (result == true) {
                  _refresh();
                }
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: const Icon(Icons.add, color: AppColors.white, size: 32),
            ),
    );
  }

  Widget _buildSummaryText() {
    final total = _allAlerts.length;
    final withPropositions =
        _allAlerts.fold<int>(0, (sum, a) => sum + (a.matchCount ?? 0));
    final demandesLabel = total == 1 ? 'demande' : 'demandes';
    final propositionsLabel = withPropositions == 1
        ? 'nouvelle proposition'
        : 'nouvelles propositions';
    return Text(
      '$total $demandesLabel · $withPropositions $propositionsLabel',
      style: AppTypography.button.copyWith(
        fontWeight: FontWeight.normal,
        color: AppColors.immoTextSecondary,
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _tabController.index == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.blue100,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.bodyMediumMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.primary,
        ),
      ),
    );
  }
}

class _AlertListContent extends StatefulWidget {
  final String? status;
  final ValueNotifier<int> refreshNotifier;
  final void Function(List<AlertModel> alerts)? onAlertsLoaded;
  const _AlertListContent({
    this.status,
    required this.refreshNotifier,
    this.onAlertsLoaded,
  });

  @override
  State<_AlertListContent> createState() => _AlertListContentState();
}

class _AlertListContentState extends State<_AlertListContent> {
  final alertRepository = getIt<AlertRepository>();
  List<AlertModel> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.refreshNotifier.addListener(_fetchAlerts);
    _fetchAlerts();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_fetchAlerts);
    super.dispose();
  }

  Future<void> _fetchAlerts() async {
    log('_AlertListContent: Fetching alerts for status: ${widget.status}');
    setState(() => _isLoading = true);
    try {
      final response = await alertRepository.getAlerts(status: widget.status);
      _alerts = response.data;
      widget.onAlertsLoaded?.call(_alerts);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool alertIsEmpty = _alerts.isEmpty;
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (alertIsEmpty) {
      return CustomEmptyState(
        icon: Iconsax.reserve,
        title: 'Aucune demande pour le moment',
        description:
            "Vous n'avez pas encore fait de demande Décrivez le bien idéal et laissez les professionnels venir à vous.",
        buttonText: 'Faire une demande',
        buttonIcon: const Icon(Icons.add, color: AppColors.white, size: 20),
        onButtonPressed: () async {
          final result = await context.pushNamed(AlertCreateEditPage.name);
          if (result == true && context.mounted) {
            await context.pushNamed(AlertSuccessPage.name);
          }
          widget.refreshNotifier.value++;
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAlerts,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _alerts.length,
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          return AlertCard(
            alert: _alerts[index],
            onRefresh: _fetchAlerts,
          );
        },
      ),
    );
  }
}
