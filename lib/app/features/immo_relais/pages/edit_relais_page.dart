import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/services/image_picker_service.dart';
import 'package:immoplus/app/data/enums/relais_availability_preset.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/enums/relais_reporter_relation.dart';
import 'package:immoplus/app/data/models/remote/configs/commune_model.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_update_request.dart';
import 'package:immoplus/app/data/repositories/config_repository.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

/// Édition d'un relais existant — `PATCH /relais/:id`. Écran unique
/// (contrairement au wizard de création) puisque le PATCH accepte tous les
/// champs à plat.
class EditRelaisPage extends StatefulWidget {
  final RelaisModel relais;
  const EditRelaisPage({super.key, required this.relais});
  static const String name = 'EDIT_RELAIS_PAGE';

  @override
  State<EditRelaisPage> createState() => _EditRelaisPageState();
}

class _EditRelaisPageState extends State<EditRelaisPage> {
  final _relaisRepository = getIt<RelaisRepository>();
  final _configRepository = ConfigRepository();
  final _landmarkController = TextEditingController();
  final _detailsController = TextEditingController();

  RelaisPropertyType? _propertyType;
  String? _commune;
  late int _rooms;
  /// Chaque slot : `String` (id d'une photo déjà en ligne), `File` (photo
  /// locale nouvellement choisie pour remplacer ce slot), ou `null` (vide).
  late List<dynamic> _photoSlots;
  RelaisAvailabilityPreset? _availabilityPreset;
  RelaisReporterRelation? _reporterRelation;

  List<CommuneModel> _communes = [];
  bool _isLoadingCommunes = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final relais = widget.relais;
    _propertyType = relaisPropertyTypes
        .where((t) => t.backendSlug == relais.propertyType)
        .firstOrNull;
    _commune = relais.location;
    _rooms = relais.rooms;
    _photoSlots = List<dynamic>.generate(3, (i) => i < relais.photos.length ? relais.photos[i] : null);
    _landmarkController.text = relais.landmark ?? '';
    _reporterRelation = RelaisReporterRelation.values
        .where((r) => r.value == relais.reporterRelation)
        .firstOrNull;
    _detailsController.text = relais.reporterRelationDetails ?? '';
    _loadCommunes();
  }

  @override
  void dispose() {
    _landmarkController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunes() async {
    try {
      final response = await _configRepository.getCommunes(page: 1, perPage: 20);
      if (mounted) setState(() => _communes = response.data);
    } catch (_) {
      // Les chips restent vides : le champ repère/quartier texte suffit.
    } finally {
      if (mounted) setState(() => _isLoadingCommunes = false);
    }
  }

  Future<void> _pickPhoto(int index) async {
    final file = await ImagePickerService.pickImage(
      context: context,
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (file != null) setState(() => _photoSlots[index] = file);
  }

  Future<void> _save() async {
    if (_propertyType == null) {
      CustomPopup.showErrorToast(text: 'Veuillez sélectionner un type de logement');
      return;
    }
    if (_commune == null || _commune!.isEmpty) {
      CustomPopup.showErrorToast(text: 'Veuillez sélectionner un quartier');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final photoIds = <String>[];
      for (final slot in _photoSlots) {
        if (slot == null) continue;
        if (slot is String) {
          photoIds.add(slot);
        } else if (slot is File) {
          final id = await uploadFile(file: slot);
          if (id != null) photoIds.add(id);
        }
      }

      await _relaisRepository.updateRelais(
        widget.relais.id,
        RelaisUpdateRequest(
          propertyType: _propertyType!.backendSlug,
          location: _commune,
          landmark: _landmarkController.text.trim().isEmpty ? null : _landmarkController.text.trim(),
          rooms: _rooms,
          photos: photoIds,
          availabilityPreset: _availabilityPreset?.value,
          reporterRelation: _reporterRelation?.value,
          reporterRelationDetails:
              _detailsController.text.trim().isEmpty ? null : _detailsController.text.trim(),
        ),
      );

      if (mounted) context.pop(true);
    } catch (_) {
      if (mounted) {
        CustomPopup.showErrorToast(text: "Impossible d'enregistrer les modifications");
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          'Modifier ma demande',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              _buildCommuneChips(),
              const Gap(24),
              _sectionLabel('Repère ou adresse précise :'),
              const Gap(12),
              _buildTextField(_landmarkController, 'Ex: Non loin de la pharmacie'),
              const Gap(24),
              _sectionLabel('Nombre de chambres :'),
              const Gap(12),
              _buildRoomsStepper(),
              const Gap(24),
              _sectionLabel('Disponible à partir de'),
              const Gap(12),
              _buildAvailabilityOptions(),
              const Gap(24),
              _sectionLabel('Quel est votre lien avec ce logement ?'),
              const Gap(12),
              _buildRelationOptions(),
              if (_reporterRelation == RelaisReporterRelation.other) ...[
                const Gap(12),
                _buildTextField(_detailsController, 'Précisez votre lien avec ce logement'),
              ],
              const Gap(32),
              CustomLoadingButtom(
                text: 'Enregistrer',
                isLoading: _isSaving,
                onClick: _save,
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
      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: GoogleFonts.dmSans(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildPhotoRow() {
    return Row(
      children: List.generate(3, (index) {
        final slot = _photoSlots[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < 2 ? 10 : 0),
            child: InkWell(
              onTap: () => _pickPhoto(index),
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
                  child: slot == null
                      ? Icon(Iconsax.gallery_add, size: 22, color: AppColors.primary)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: slot is File
                              ? Image.file(slot, fit: BoxFit.cover, width: double.infinity, height: 110)
                              : CachedNetworkImage(
                                  imageUrl: Utils.getImagePath(id: slot as String),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 110,
                                ),
                        ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPropertyTypeGrid() {
    return Row(
      children: relaisPropertyTypes.map((type) {
        final isSelected = _propertyType?.backendSlug == type.backendSlug;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: type == relaisPropertyTypes.last ? 0 : 8),
            child: GestureDetector(
              onTap: () => setState(() => _propertyType = type),
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

  Widget _buildCommuneChips() {
    if (_isLoadingCommunes) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _communes.map((commune) {
        final isSelected = _commune == commune.name;
        return GestureDetector(
          onTap: () => setState(() => _commune = commune.name),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
            ),
            child: Text(
              commune.name,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
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
          _stepperButton(icon: Icons.add, onTap: () => setState(() => _rooms++)),
          Text(
            _rooms.toString().padLeft(2, '0'),
            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _stepperButton(
            icon: Icons.remove,
            onTap: _rooms > 0 ? () => setState(() => _rooms--) : null,
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
        decoration: BoxDecoration(color: AppColors.primaryLite, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildAvailabilityOptions() {
    return Column(
      children: RelaisAvailabilityPreset.values.map((preset) {
        final isSelected = _availabilityPreset == preset;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _availabilityPreset = preset),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
              ),
              child: Text(
                preset.label,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRelationOptions() {
    return Column(
      children: RelaisReporterRelation.values.map((relation) {
        final isSelected = _reporterRelation == relation;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _reporterRelation = relation),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(relation.label, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Gap(2),
                  Text(
                    relation.description,
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
