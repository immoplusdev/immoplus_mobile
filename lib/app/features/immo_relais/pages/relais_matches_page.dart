import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_matches_response.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:intl/intl.dart';

/// Demandeurs (alertes) qui correspondent à mon relais — informatif,
/// lecture seule (contrairement aux intéressés, il n'y a rien à "répondre"
/// ici, l'intérêt n'a pas encore été exprimé côté demandeur).
class RelaisMatchesPage extends StatefulWidget {
  final String relaisId;
  const RelaisMatchesPage({super.key, required this.relaisId});
  static const String name = 'RELAIS_MATCHES_PAGE';

  @override
  State<RelaisMatchesPage> createState() => _RelaisMatchesPageState();
}

class _RelaisMatchesPageState extends State<RelaisMatchesPage> {
  final _relaisRepository = getIt<RelaisRepository>();
  List<RelaisMatchModel> _matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final response = await _relaisRepository.getRelaisMatches(widget.relaisId);
      if (mounted) setState(() => _matches = response.data.matches);
    } catch (_) {
      // Liste vide en cas d'erreur réseau.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Demandeurs correspondants',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _matches.isEmpty
                ? Center(
                    child: Text(
                      'Aucune correspondance pour le moment.',
                      style: GoogleFonts.dmSans(color: Colors.grey.shade500),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetch,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _matches.length,
                      separatorBuilder: (context, index) => const Gap(16),
                      itemBuilder: (context, index) => _MatchCard(match: _matches[index]),
                    ),
                  ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final RelaisMatchModel match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact();
    final criteria = match.criteria;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: .2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  match.title ?? match.userName ?? 'Recherche',
                  style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              if (match.matchScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFCF3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${match.matchScore!.round()}%',
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1CA53F)),
                  ),
                ),
            ],
          ),
          if (match.userName != null) ...[
            const Gap(4),
            Text(
              match.userName!,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
          if (criteria?.location != null || criteria?.priceMin != null) ...[
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (criteria?.location != null) _tag(criteria!.location!),
                if (criteria?.priceMin != null || criteria?.priceMax != null)
                  _tag(
                    '${formatter.format(criteria?.priceMin ?? 0)} - ${formatter.format(criteria?.priceMax ?? 0)} fcfa',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade700)),
    );
  }
}
