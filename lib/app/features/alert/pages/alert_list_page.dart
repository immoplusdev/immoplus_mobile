import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_success_page.dart';
import 'package:immoplus/app/features/alert/widgets/alert_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.black),
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
              child: const Icon(Icons.add, color: Colors.white, size: 32),
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
  const _AlertHubItem(
    title: 'En attente',
    subtitle: 'Pas encore de proposition',
    icon: Iconsax.clock,
    color: Color(0xFFF59E0B),
    status: 'en_attente',
  ),
  const _AlertHubItem(
    title: 'Propositions',
    subtitle: 'Offres reçues des pros',
    icon: Iconsax.gift,
    color: Color(0xFF1CA53F),
    status: 'propositions',
  ),
  const _AlertHubItem(
    title: 'Clôturées',
    subtitle: 'Demandes terminées',
    icon: Iconsax.archive_tick,
    color: Color(0xFF6B7280),
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
            itemBuilder: (context, index) => _AlertHubCard(item: _alertHubItems[index]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.lamp_charge, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Publiez une demande et recevez des propositions des professionnels selon vos critères.",
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
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
              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade600),
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
      backgroundColor: Colors.white,
      appBar: widget.embedded
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 20),
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
                    style: GoogleFonts.dmSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            tabAlignment: TabAlignment.start,
            tabs: AlertStatusTab.values.map((tab) {
              return Tab(
                height: 44,
                child: _buildTabItem(tab.label, tab.index),
              );
            }).toList(),
          ),
          const Gap(16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: AlertStatusTab.values
                  .map((tab) => _AlertListContent(
                        status: tab.value,
                        refreshNotifier: _refreshNotifier,
                        onAlertsLoaded: tab.value == null
                            ? (alerts) => setState(() => _allAlerts = alerts)
                            : null,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _allAlerts.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final result =
                    await context.pushNamed(AlertCreateEditPage.name);
                if (result == true && context.mounted) {
                  await context.pushNamed(AlertSuccessPage.name);
                }
                _refresh();
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white, size: 32),
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
      style: GoogleFonts.dmSans(
        fontSize: 15,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _tabController.index == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.primary,
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
      return const Center(child: CircularProgressIndicator());
    }

    if (alertIsEmpty) {
      return CustomEmptyState(
        icon: Iconsax.reserve,
        title: 'Aucune demande pour le moment',
        description:
            "Vous n'avez pas encore fait de demande Décrivez le bien idéal et laissez les professionnels venir à vous.",
        buttonText: 'Faire une demande',
        buttonIcon: const Icon(Icons.add, color: Colors.white, size: 20),
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
