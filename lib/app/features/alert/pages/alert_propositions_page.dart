import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_match_model.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/features/alert/widgets/proposition_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class AlertPropositionsPage extends StatefulWidget {
  final String alertId;
  final int unreadMatchCount;
  const AlertPropositionsPage({
    super.key,
    required this.alertId,
    this.unreadMatchCount = 0,
  });
  static const String name = 'ALERT_PROPOSITIONS_PAGE';

  static String routePath() => '/alerts/:id/propositions';

  static String route(String id) => '/alerts/$id/propositions';

  @override
  State<AlertPropositionsPage> createState() => _AlertPropositionsPageState();
}

class _AlertPropositionsPageState extends State<AlertPropositionsPage> {
  final alertRepository = getIt<AlertRepository>();
  List<AlertMatchModel> _propositions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getIt<AnalyticsService>().logAlertMatchesViewed(alertId: widget.alertId);
    _markViewedAndRefreshBadge(); // lancé immédiatement, sans attendre les propositions
    _fetchPropositions();
  }

  /// PATCH /alerts/:id/view dès l'ouverture de la page.
  /// Badge rafraîchi après succès. Silencieux en cas d'erreur réseau.
  void _markViewedAndRefreshBadge() {
    alertRepository.markAsViewed(widget.alertId).then((_) {
      Constantes.imatchBadgeCount.value =
          max(0, Constantes.imatchBadgeCount.value - widget.unreadMatchCount);
    }).ignore();
  }

  Future<void> _fetchPropositions() async {
    setState(() => _isLoading = true);
    try {
      final response =
          await alertRepository.getAlertMatches(id: widget.alertId);
      _propositions = response.matches;
    } catch (e) {
      // Error handled by repo/EasyLoading
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mes propositions',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _propositions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_outlined,
                          size: 80, color: Colors.grey[200]),
                      const Gap(16),
                      Text(
                        'Aucune proposition pour le moment',
                        style: GoogleFonts.dmSans(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _propositions.length,
                  separatorBuilder: (context, index) => const Gap(24),
                  itemBuilder: (context, index) {
                    return PropositionCard(property: _propositions[index]);
                  },
                ),
    );
  }
}
