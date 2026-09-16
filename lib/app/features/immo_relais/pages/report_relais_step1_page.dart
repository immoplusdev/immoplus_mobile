import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/services/image_picker_service.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/features/immo_relais/models/relais_draft.dart';
import 'package:immoplus/app/features/immo_relais/pages/report_relais_step2_page.dart';
import 'package:immoplus/app/features/immo_relais/widgets/relais_intro_header.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Écran 1/2 du flux B (signalement anonyme, voir
/// CLIENT-IMMO-RELAIS-API.md) : "Publiez votre ancien logement" — photos,
/// type de logement, quartier, nombre de chambres.
class ReportRelaisStep1Page extends StatefulWidget {
  const ReportRelaisStep1Page({super.key});
  static const String name = 'REPORT_RELAIS_STEP1_PAGE';
  static const String routePath = '/relais/report';

  @override
  State<ReportRelaisStep1Page> createState() => _ReportRelaisStep1PageState();
}

class _ReportRelaisStep1PageState extends State<ReportRelaisStep1Page> {
  static const int _maxPhotos = 3;

  final _draft = RelaisDraft();

  Future<void> _pickPhotos() async {
    final remaining = _maxPhotos - _draft.photos.length;
    if (remaining <= 0) return;
    final files = await ImagePickerService.pickMultipleImages(context: context);
    if (files.isEmpty) return;
    setState(() => _draft.photos.addAll(files.take(remaining)));
  }

  void _removePhoto(int index) {
    setState(() => _draft.photos.removeAt(index));
  }

  Future<void> _pickLandmark() async {
    final value = await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: false,
      backgroundColor: AppColors.whiteBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LocationPage(),
      ),
    );
    if (value is Address) {
      setState(() {
        _draft.landmarkAddress = value;
        _draft.commune ??= value.description;
      });
    }
  }

  void _continue() {
    if (_draft.propertyType == null) {
      CustomPopup.showErrorToast(text: 'Veuillez sélectionner un type de logement');
      return;
    }
    if (_draft.commune == null || _draft.commune!.isEmpty) {
      CustomPopup.showErrorToast(text: 'Veuillez sélectionner un quartier');
      return;
    }
    context.pushNamed(ReportRelaisStep2Page.name, extra: _draft);
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
          'Publiez votre ancien logement',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RelaisIntroHeader(),
              const Gap(24),
              _sectionLabel('Photo du logement :'),
              const Gap(12),
              _buildPhotoRow(),
              const Gap(24),
              _sectionLabel('Type de logement :'),
              const Gap(12),
              _buildPropertyTypeGrid(),
              const Gap(24),
              _sectionLabel('Dans quel quartier ?'),
              const Gap(12),
              _buildQuartierPicker(),
              const Gap(24),
              _sectionLabel('Nombre de chambres :'),
              const Gap(12),
              _buildRoomsStepper(),
              const Gap(32),
              CustomLoadingButtom(
                text: 'Continuer',
                isLoading: false,
                onClick: _continue,
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPhotoRow() {
    final items = <Widget>[
      for (var index = 0; index < _draft.photos.length; index++)
        _PhotoSlot(
          file: _draft.photos[index],
          onRemove: () => _removePhoto(index),
        ),
      if (_draft.photos.length < _maxPhotos)
        _PhotoSlot(file: null, onTap: _pickPhotos),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Gap(10),
          Expanded(child: items[i]),
        ],
      ],
    );
  }

  Widget _buildPropertyTypeGrid() {
    return Row(
      children: relaisPropertyTypes.map((type) {
        final isSelected = _draft.propertyType?.backendSlug == type.backendSlug;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: type == relaisPropertyTypes.last ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() => _draft.propertyType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLite : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    type.svgIcon != null
                        ? SvgPicture.asset(type.svgIcon!, width: 26, height: 26)
                        : Icon(type.fallbackIcon, size: 26, color: Colors.grey.shade700),
                    const Gap(8),
                    Text(
                      type.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuartierPicker() {
    final selected = _draft.commune;
    return GestureDetector(
      onTap: _pickLandmark,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected != null ? AppColors.primaryLite : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected != null ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(Iconsax.location, size: 18, color: AppColors.primary),
            const Gap(10),
            Expanded(
              child: Text(
                selected ?? 'Choisir un quartier',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected != null ? Colors.black : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepperButton(
            icon: Icons.remove,
            onTap: _draft.rooms > 0
                ? () => setState(() => _draft.rooms--)
                : null,
          ),
          Text(
            _draft.rooms.toString().padLeft(2, '0'),
            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _stepperButton(
            icon: Icons.add,
            onTap: () => setState(() => _draft.rooms++),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryLite,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final File? file;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const _PhotoSlot({required this.file, this.onTap, this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(file!, fit: BoxFit.cover, width: double.infinity, height: 110),
          ),
          if (onRemove != null)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: AppColors.primary.withValues(alpha: 0.4),
        strokeWidth: 1.2,
        dashPattern: const [5, 4],
        child: Container(
          width: double.infinity,
          height: 110,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.gallery_add, size: 22, color: AppColors.primary),
                const Gap(6),
                Text(
                  'Ajouter des photos',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
