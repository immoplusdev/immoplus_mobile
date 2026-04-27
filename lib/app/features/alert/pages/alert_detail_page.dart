import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:intl/intl.dart';

class AlertDetailPage extends StatefulWidget {
  final AlertModel alert;
  const AlertDetailPage({super.key, required this.alert});

  static const String name = 'ALERT_DETAIL_PAGE';

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  late AlertModel _alert;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _alert = widget.alert;
  }

  Future<void> _refreshAlert() async {
    setState(() => _isLoading = true);
    try {
      final response = await getIt<AlertRepository>().getAlertById(_alert.id);
      setState(() {
        _alert = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyType = _alert.criteria.propertyTypeObj;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(_alert),
            const Gap(24),
            _buildInfoRow(_alert),
            const Gap(24),
            _buildBudgetSection(_alert),
            const Gap(24),
            _buildLocationSection(_alert),
            const Gap(24),
            _buildAdditionalInfoSection(_alert),
            const Gap(24),
            _buildSuiviSection(_alert),
            const Gap(40),
            _buildActionButtons(context),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AlertModel alert) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: alert.criteria.propertyTypeObj != null
              ? SvgPicture.asset(
                  alert.criteria.propertyTypeObj!.icon,
                  width: 32,
                  height: 32,
                  colorFilter:
                      ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                )
              : Icon(Icons.home_outlined, color: AppColors.primary, size: 32),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.title ?? 'Demande sans titre',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              if (alert.createdAt != null)
                Text(
                  'Envoyée le ${DateFormat('d MMM yyyy', 'fr_FR').format(alert.createdAt!)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        ),
        _buildStatusBadge(alert.statusEnum),
      ],
    );
  }

  Widget _buildStatusBadge(AlertStatus status) {
    return Container(
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
    );
  }

  Widget _buildInfoRow(AlertModel alert) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Opération',
            alert.criteria.transactionTypeEnum.label,
          ),
        ),
        const Gap(12),
        Expanded(
          child: _buildInfoCard(
            'Pièces',
            '${alert.criteria.roomsMin ?? 0} pièces',
          ),
        ),
        const Gap(12),
        Expanded(
          child: _buildInfoCard(
            'Type',
            alert.criteria.propertyTypeObj?.label ?? 'N/A',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSection(AlertModel alert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Votre budget :',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
                child: _buildBudgetField('Minimum', alert.criteria.priceMin)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('—', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(
                child: _buildBudgetField('Maximum', alert.criteria.priceMax)),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetField(String label, int? amount) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                GoogleFonts.dmSans(fontSize: 10, color: Colors.grey.shade500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount != null ? formatter.format(amount) : '0',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'fcfa',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(AlertModel alert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation:',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const Gap(12),
              Expanded(
                child: Text(
                  alert.criteria.location ?? 'N/A',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(AlertModel alert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Précisions supplémentaires :',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            alert.descriptionClient ?? 'Aucune précision supplémentaire.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFF4B5563),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuiviSection(AlertModel alert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suivi de la demande :',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(20),
        _buildTimelineItem(
          'Demande envoyée',
          DateFormat('d avr. 2026 - HH\'h\'mm')
              .format(alert.createdAt ?? DateTime.now()),
          isActive: true,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Analyse en cours',
          'Recherche de biens correspondants',
          isActive: true,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'En attente de proposition',
          'En cours · réponse sous 24h',
          isActive: true,
          isHighlighted: true,
        ),
        _buildTimelineItem(
          'Proposition reçue',
          'Vous serez notifié dans l\'app',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String subtitle,
      {bool isActive = false,
      bool isCompleted = false,
      bool isHighlighted = false,
      bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHighlighted
                    ? const Color(0xFFFBBF24)
                    : (isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.2)
                        : Colors.white),
                border: Border.all(
                  color: isHighlighted
                      ? const Color(0xFFFBBF24)
                      : (isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Color(0xFF10B981), size: 14)
                  : (isHighlighted
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? const Color(0xFF10B981)
                    : Colors.grey.shade200,
              ),
          ],
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      isActive ? const Color(0xFF1F2937) : Colors.grey.shade400,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: isHighlighted
                      ? const Color(0xFFD97706)
                      : (isActive
                          ? Colors.grey.shade500
                          : Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              await context.pushNamed(
                AlertCreateEditPage.name,
                extra: _alert,
              );
              _refreshAlert();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Modifier',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showDeleteConfirmation(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Annuler',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    AppDialog.show(
      title: 'Confirmer l\'annulation',
      description: 'Voulez-vous vraiment annuler cette demande ?',
      primaryButtonText: 'Oui, annuler',
      secondButtonText: 'Non, garder',
      onPrimary: () async {
        try {
          final response =
              await getIt<AlertRepository>().deleteAlert(_alert.id);
          if (response.response.statusCode == 200 ||
              response.response.statusCode == 204) {
            ToastUtils.success('L\'annulation s\'est bien passée');
            if (context.mounted) {
              context.pop(); // Back to list
            }
          }
        } catch (e) {
          ToastUtils.error('Erreur lors de l\'annulation');
        }
      },
    );
  }
}
