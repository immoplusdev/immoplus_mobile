import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_match_model.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
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

  // Future<void> _fetchPropositions() async {
  //   setState(() => _isLoading = true);
  //   // Simulation d'un délai réseau
  //   await Future.delayed(const Duration(milliseconds: 1000));

  //   final mockPropositions = [
  //     BienImmobilierModel(
  //       id: 'b1',
  //       nom: 'Appartement de luxe - Plateau',
  //       typeBienImmobilier: 'appartement',
  //       adresse: 'Plateau, Avenue Chardy',
  //       prix: 850000,
  //       images: [
  //         'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=80&w=1000'
  //       ],
  //       description: 'Magnifique appartement avec vue sur la lagune.',
  //     ),
  //     BienImmobilierModel(
  //       id: 'b2',
  //       nom: 'Studio moderne - Cocody',
  //       typeBienImmobilier: 'appartement',
  //       adresse: 'Cocody, Angré 7ème tranche',
  //       prix: 350000,
  //       images: [
  //         'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=80&w=1000'
  //       ],
  //       description: 'Studio entièrement équipé et sécurisé.',
  //     ),
  //     BienImmobilierModel(
  //       id: 'b3',
  //       nom: 'Appartement F3 - Marcory',
  //       typeBienImmobilier: 'appartement',
  //       adresse: 'Marcory, Zone 4C',
  //       prix: 950000,
  //       images: [
  //         'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&q=80&w=1000'
  //       ],
  //       description: 'Bel appartement spacieux proche des commerces.',
  //     ),
  //   ];

  //   if (mounted) {
  //     setState(() {
  //       _propositions = mockPropositions;
  //       _isLoading = false;
  //     });

  //     // Simulation de l'appel pour marquer comme vu
  //     try {
  //       await alertRepository.markAsViewed(widget.alertId);
  //     } catch (e) {
  //       debugPrint('Error marking as viewed: $e');
  //     }
  //   }
  // }

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
