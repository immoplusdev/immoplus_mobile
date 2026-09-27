import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/immo_relais_status.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_step1_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_empty_state.dart';

/// Un onglet pilule — "Toutes" (pas de filtre) + un par statut.
class _StatusTab {
  final String label;
  final ImmoRelaisStatus? status;
  const _StatusTab(this.label, this.status);
}

final List<_StatusTab> _statusTabs = [
  const _StatusTab('Toutes', null),
  for (final status in ImmoRelaisStatus.values) _StatusTab(status.label, status),
];

/// Sous-onglet "Pour moi" — mes relais publiés (`GET /relais`), filtrés par
/// statut via des onglets pilules, affichés en liste verticale.
class RelaisMySection extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  final ValueChanged<bool> onRequestsLoaded;

  const RelaisMySection({
    super.key,
    required this.refreshNotifier,
    required this.onRequestsLoaded,
  });

  @override
  State<RelaisMySection> createState() => _RelaisMySectionState();
}

class _RelaisMySectionState extends State<RelaisMySection>
    with SingleTickerProviderStateMixin {
  final _relaisRepository = getIt<RelaisRepository>();
  late final TabController _tabController;
  List<RelaisModel> _relais = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
    widget.refreshNotifier.addListener(_fetchRelais);
    _fetchRelais();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_fetchRelais);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchRelais() async {
    setState(() => _isLoading = true);
    try {
      final response = await _relaisRepository.getRelais(status: 'all');
      if (mounted) {
        setState(() => _relais = response.data);
        widget.onRequestsLoaded(response.data.isNotEmpty);
      }
    } catch (_) {
      // Liste vide en cas d'erreur : l'état vide reste au moins actionnable
      // (bouton "Faire une demande"), pas de blocage sur une erreur réseau.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createNewRequest() async {
    await context.pushNamed(ReportRelaisStep1Page.name);
    _fetchRelais();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          tabAlignment: TabAlignment.start,
          tabs: _statusTabs
              .map((tab) => Tab(height: 34, child: _buildTabItem(tab.label, tab.status)))
              .toList(),
        ),
        const Gap(12),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildTabItem(String label, ImmoRelaisStatus? status) {
    final isSelected = _statusTabs[_tabController.index].status == status;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.blue.shade100,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final selectedStatus = _statusTabs[_tabController.index].status;
    final filtered = selectedStatus == null
        ? _relais
        : _relais.where((relais) => relais.statusEnum == selectedStatus).toList();

    if (filtered.isEmpty) {
      return CustomEmptyState(
        icon: Iconsax.truck_fast,
        title: 'Je prépare mon déménagement',
        description:
            'Publiez votre recherche. Propriétaires et Imatch travaillent pour vous.',
        buttonText: 'Faire une demande',
        buttonIcon: const Icon(Icons.add, color: Colors.white, size: 20),
        onButtonPressed: _createNewRequest,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchRelais,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) => RelaisCard(relais: filtered[index], onChanged: _fetchRelais),
      ),
    );
  }
}
