import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/immo_relais_status.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/enums/relais_reporter_relation.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/pages/edit_relais_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_interests_page.dart';
import 'package:immoplus/app/features/immo_relais/pages/relais_matches_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/express_interest_sheet.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Args passés en `extra` de la route `RelaisDetailPage.name` (un
/// `RelaisModel` seul ne suffit pas, il faut aussi `isOwner`).
class RelaisDetailArgs {
  final RelaisModel relais;
  final bool isOwner;
  const RelaisDetailArgs(this.relais, [this.isOwner = true]);
}

/// Détail complet d'un relais — `GET /relais/:id` (voir
/// CLIENT-IMMO-RELAIS-API.md § 3). Reçoit l'item de liste en `extra` pour
/// affichage immédiat, puis recharge la version complète (latitude/
/// longitude/occupantId/updatedAt, absents de l'item de liste allégé).
///
/// [isOwner] distingue les 2 façons d'atteindre cet écran :
/// - `true` (défaut, via "Pour moi") : c'est mon relais → Modifier/Annuler,
///   stats Intéressés/Correspondances. On recharge le détail complet.
/// - `false` (via Marketplace/Mes intérêts) : relais d'un autre → juste un
///   bouton "Je suis intéressé", pas de rechargement (`GET /relais/:id`
///   est probablement restreint au propriétaire, et le Marketplace exclut
///   déjà mes propres relais côté serveur — l'item de liste suffit).
class RelaisDetailPage extends StatefulWidget {
  final RelaisModel relais;
  final bool isOwner;
  const RelaisDetailPage({super.key, required this.relais, this.isOwner = true});
  static const String name = 'RELAIS_DETAIL_PAGE';

  @override
  State<RelaisDetailPage> createState() => _RelaisDetailPageState();
}

class _RelaisDetailPageState extends State<RelaisDetailPage> {
  late RelaisModel _relais = widget.relais;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isOwner) {
      _isLoading = true;
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    try {
      final response = await getIt<RelaisRepository>().getRelaisById(_relais.id);
      if (mounted) setState(() => _relais = response.data);
    } catch (_) {
      // On garde l'item de liste déjà affiché si le rechargement échoue.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editRelais() async {
    final updated = await context.pushNamed(EditRelaisPage.name, extra: _relais);
    if (updated == true) _loadDetail();
  }

  void _confirmCancel() {
    AppDialog.show(
      title: 'Annuler cette demande ?',
      description: 'Cette action est définitive, vous ne pourrez pas la republier telle quelle.',
      primaryButtonText: 'Oui, annuler',
      secondButtonText: 'Non, garder',
      onPrimary: () async {
        try {
          await getIt<RelaisRepository>().cancelRelais(_relais.id);
          if (mounted) context.pop(true);
        } catch (_) {
          if (mounted) CustomPopup.showErrorToast(text: "Impossible d'annuler cette demande");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _relais.statusEnum;
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
          'Ma demande',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLite,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Iconsax.home_2, color: AppColors.primary, size: 28),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${relaisPropertyTypeLabel(_relais.propertyType)} · ${_relais.rooms} chambre${_relais.rooms > 1 ? 's' : ''}',
                        style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (_relais.createdAt != null)
                        Text(
                          'Publié le ${DateFormat('d MMM yyyy', 'fr_FR').format(_relais.createdAt!)}',
                          style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: status.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status.textColor,
                    ),
                  ),
                ),
              ],
            ),
            if (_relais.photos.isNotEmpty) ...[
              const Gap(20),
              _buildPhotos(),
            ],
            const Gap(24),
            _sectionLabel('Localisation'),
            const Gap(12),
            _buildLocationCard(),
            if (_relais.availabilityDate != null) ...[
              const Gap(24),
              _sectionLabel('Disponibilité'),
              const Gap(12),
              _buildInfoCard(
                Iconsax.calendar,
                DateFormat('d MMMM yyyy', 'fr_FR').format(_relais.availabilityDate!),
              ),
            ],
            if (_relais.reporterRelation != null) ...[
              const Gap(24),
              _sectionLabel('Lien avec ce logement'),
              const Gap(12),
              _buildInfoCard(
                Iconsax.user,
                _reporterRelationLabel(_relais.reporterRelation) +
                    (_relais.reporterRelationDetails?.isNotEmpty == true
                        ? ' — ${_relais.reporterRelationDetails}'
                        : ''),
              ),
            ],
            if (widget.isOwner) ...[
              const Gap(24),
              _sectionLabel('Intérêt reçu'),
              const Gap(12),
              _buildStatsRow(),
              if (status != ImmoRelaisStatus.cancelled) ...[
                const Gap(32),
                _buildActionButtons(),
              ],
            ] else if (status != ImmoRelaisStatus.cancelled) ...[
              const Gap(32),
              CustomLoadingButtom(
                text: 'Je suis intéressé',
                isLoading: false,
                onClick: () => showExpressRelaisInterestSheet(context, relaisId: _relais.id),
              ),
            ],
            const Gap(24),
          ],
        ),
      ),
    );
  }

  String _reporterRelationLabel(String? value) {
    for (final relation in RelaisReporterRelation.values) {
      if (relation.value == value) return relation.label;
    }
    return value ?? '—';
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  Widget _buildPhotos() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _relais.photos.length,
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: Utils.getImagePath(id: _relais.photos[index]),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Iconsax.location, color: AppColors.primary, size: 20),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _relais.location,
                  style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                if (_relais.landmark != null) ...[
                  const Gap(2),
                  Text(
                    _relais.landmark!,
                    style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const Gap(12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '${_relais.interestedCount}',
            _relais.interestedCount > 1 ? 'Intéressés' : 'Intéressé',
            onTap: () => context.pushNamed(RelaisInterestsPage.name, extra: _relais.id),
          ),
        ),
        const Gap(12),
        Expanded(
          child: _buildStatCard(
            '${_relais.potentialMatches}',
            'Correspondances',
            onTap: () => context.pushNamed(RelaisMatchesPage.name, extra: _relais.id),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _editRelais,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Modifier',
              style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          child: OutlinedButton(
            onPressed: _confirmCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Annuler',
              style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(2),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
