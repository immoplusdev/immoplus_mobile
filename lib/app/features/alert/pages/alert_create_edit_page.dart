import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_request.dart';
import 'package:immoplus/app/data/models/remote/alert/property_type.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:immoplus/app/features/location_module/location_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:intl/intl.dart';
import 'package:immoplus/app/widgets/custom_loading_button.dart';
import 'alert_success_page.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';

class AlertCreateEditPage extends StatefulWidget {
  final AlertModel? alert;
  const AlertCreateEditPage({super.key, this.alert});
  static const String name = 'ALERT_CREATE_EDIT_PAGE';

  @override
  State<AlertCreateEditPage> createState() => _AlertCreateEditPageState();
}

class _AlertCreateEditPageState extends State<AlertCreateEditPage> {
  final alertRepository = getIt<AlertRepository>();

  String? _selectedPropertyType;
  String? _selectedTransactionType = 'acheter';
  Address? _selectedAddress;
  int _selectedRooms = 3;
  RangeValues _budgetRange = const RangeValues(30000, 8000000);
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  bool get _isEditMode => widget.alert != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final alert = widget.alert!;
      _selectedPropertyType = alert.criteria.propertyType;
      _selectedTransactionType = alert.criteria.transactionType ?? 'acheter';
      if (alert.criteria.location != null) {
        _selectedAddress = Address(
            description: alert.criteria.location!, latitude: 0, longitude: 0);
      }
      _selectedRooms = alert.criteria.roomsMin ?? 3;

      double minBudget =
          (alert.criteria.priceMin ?? 30000).toDouble().clamp(10000, 50000000);
      double maxBudget = (alert.criteria.priceMax ?? 8000000)
          .toDouble()
          .clamp(10000, 50000000);

      if (minBudget > maxBudget) {
        maxBudget = minBudget;
      }

      _budgetRange = RangeValues(minBudget, maxBudget);
      _descriptionController.text = alert.descriptionClient ?? '';
    }
  }

  Future<void> _selectLocation() async {
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
        _selectedAddress = value;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedPropertyType == null) {
      CustomPopup.showErrorToast(text: 'Veuillez sélectionner un type de bien');
      return;
    }
    if (_selectedAddress == null) {
      CustomPopup.showErrorToast(
          text: 'Veuillez sélectionner une localisation');
      return;
    }

    final request = AlertRequest(
      targetType: TargetTypeEnum.bienImmobilier.value,
      title:
          '${(_selectedPropertyType ?? 'Bien').toUpperCase()} à ${_selectedAddress?.description ?? 'Abidjan'}',
      descriptionClient: _descriptionController.text,
      criteria: AlertCriteriaModel(
        propertyType: _selectedPropertyType,
        transactionType: _selectedTransactionType,
        location: _selectedAddress?.description,
        roomsMin: _selectedRooms,
        roomsMax: _selectedRooms == 5 ? 10 : _selectedRooms,
        priceMin: _budgetRange.start.toInt(),
        priceMax: _budgetRange.end.toInt(),
      ),
    );

    setState(() => _isLoading = true);
    try {
      if (_isEditMode) {
        await alertRepository.updateAlert(widget.alert!.id, request);
        if (mounted) context.pop(true);
      } else {
        await alertRepository.createAlert(request);
        if (mounted) {
          context.pop(true);
        }
      }
    } catch (e) {
      // Handle error via EasyLoading usually handled in repo
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
          _isEditMode ? 'Modifier ma demande' : 'Nouvelle demande',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Type de bien :'),
            const Gap(12),
            _buildPropertyTypeSelector(),
            const Gap(24),
            _sectionLabel('Je souhaite :'),
            const Gap(12),
            _buildTransactionTypeSelector(),
            const Gap(24),
            _sectionLabel('Localisation :'),
            const Gap(12),
            _buildLocationSelector(),
            const Gap(24),
            _sectionLabel('Nombre de pièces du logement :'),
            const Gap(12),
            _buildRoomsSelector(),
            const Gap(24),
            _sectionLabel('Votre budget :'),
            const Gap(12),
            _buildBudgetSelector(),
            const Gap(24),
            _sectionLabel('Précisions supplémentaires :'),
            const Gap(12),
            _buildDescriptionField(),
            const Gap(40),
            _buildSubmitButton(),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectableChoice.map((type) {
          final isSelected =
              _selectedPropertyType == type.backendSlug.toLowerCase();
          return GestureDetector(
            onTap: () => setState(
                () => _selectedPropertyType = type.backendSlug.toLowerCase()),
            child: Container(
              width: 90,
              height: 90,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    type.icon,
                    color: isSelected ? AppColors.white : null,
                  ),
                  const Gap(8),
                  Text(
                    type.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Row(
      children: AlertTransactionType.values.map((type) {
        final isSelected = _selectedTransactionType == type.value;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTransactionType = type.value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  type.label,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationSelector() {
    return GestureDetector(
      onTap: _selectLocation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF3B82F6), size: 20),
            const Gap(12),
            Expanded(
              child: Text(
                _selectedAddress?.description ??
                    'Sélectionner une localisation',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: _selectedAddress != null
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsSelector() {
    final roomOptions = [1, 2, 3, 4, 5];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: roomOptions.map((rooms) {
        final isSelected = _selectedRooms == rooms;
        return GestureDetector(
          onTap: () => setState(() => _selectedRooms = rooms),
          child: Container(
            width: 60,
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                rooms == 5 ? '5+' : rooms.toString(),
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1E40AF),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetSelector() {
    final format =
        NumberFormat.currency(locale: 'fr_FR', symbol: '', decimalDigits: 0);
    return Column(
      children: [
        RangeSlider(
          values: _budgetRange,
          min: 10000,
          max: 50000000,
          divisions: 100,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey.shade200,
          onChanged: (values) => setState(() => _budgetRange = values),
        ),
        Row(
          children: [
            Expanded(
              child: _buildBudgetValue(
                  'Minimum', '${format.format(_budgetRange.start)} fcfa'),
            ),
            const Gap(16),
            const Text('—', style: TextStyle(color: Colors.grey)),
            const Gap(16),
            Expanded(
              child: _buildBudgetValue(
                  'Maximum', '${format.format(_budgetRange.end)} fcfa'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
          Text(value,
              style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Ex : Un grand jardin avec piscine',
        hintStyle:
            GoogleFonts.dmSans(fontSize: 14, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CustomLoadingButtom(
      text:
          _isEditMode ? 'Enregistrer les modifications' : 'Envoyer ma demande',
      isLoading: _isLoading,
      onClick: _submit,
    );
  }
}
