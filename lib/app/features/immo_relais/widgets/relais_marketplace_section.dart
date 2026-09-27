import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/relais_property_type.dart';
import 'package:immoplus/app/data/models/remote/relais/relais_model.dart';
import 'package:immoplus/app/data/repositories/relais_repository.dart';
import 'package:immoplus/app/features/immo_relais/widgets/marketplace_relais_card.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

/// Sous-onglet "Autour de moi" — découverte des relais des autres
/// (`GET /relais?scope=marketplace`), avec filtre quartier + type de
/// logement, en grille.
class RelaisMarketplaceSection extends StatefulWidget {
  const RelaisMarketplaceSection({super.key});

  @override
  State<RelaisMarketplaceSection> createState() => _RelaisMarketplaceSectionState();
}

class _RelaisMarketplaceSectionState extends State<RelaisMarketplaceSection>
    with AutomaticKeepAliveClientMixin {
  final _relaisRepository = getIt<RelaisRepository>();
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<RelaisModel> _relais = [];
  bool _isLoading = true;
  RelaisPropertyType? _propertyTypeFilter;
  int? _roomsFilter;
  int? _priceMinFilter;
  int? _priceMaxFilter;

  bool get _hasAdvancedFilters => _roomsFilter != null || _priceMinFilter != null || _priceMaxFilter != null;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final response = await _relaisRepository.getRelaisMarketplace(
        location: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        propertyType: _propertyTypeFilter?.backendSlug,
        roomsMin: _roomsFilter,
        priceMin: _priceMinFilter,
        priceMax: _priceMaxFilter,
      );
      if (mounted) setState(() => _relais = response.data);
    } catch (_) {
      // Liste vide en cas d'erreur réseau.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _fetch);
  }

  void _onPropertyTypeTap(RelaisPropertyType type) {
    setState(() => _propertyTypeFilter = _propertyTypeFilter == type ? null : type);
    _fetch();
  }

  Future<void> _openAdvancedFilters() async {
    final result = await showModalBottomSheet<_AdvancedFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AdvancedFiltersSheet(
        initialRooms: _roomsFilter,
        initialPriceMin: _priceMinFilter,
        initialPriceMax: _priceMaxFilter,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _roomsFilter = result.rooms;
      _priceMinFilter = result.priceMin;
      _priceMaxFilter = result.priceMax;
    });
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.dmSans(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Quartier (ex: Cocody)',
                    hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade400),
                    prefixIcon: Icon(Iconsax.search_normal_1, size: 18, color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: _openAdvancedFilters,
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hasAdvancedFilters ? AppColors.primary : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.setting_4,
                    size: 18,
                    color: _hasAdvancedFilters ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(10),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: relaisPropertyTypes.length,
            separatorBuilder: (context, index) => const Gap(8),
            itemBuilder: (context, index) {
              final type = relaisPropertyTypes[index];
              final isSelected = _propertyTypeFilter == type;
              return GestureDetector(
                onTap: () => _onPropertyTypeTap(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                  ),
                  child: Text(
                    type.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Gap(12),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_relais.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Aucun logement disponible pour ces critères pour le moment.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(color: Colors.grey.shade500),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetch,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          // Assez bas pour laisser de la marge même quand "X intéressés"
          // s'affiche en plus du bouton — évite un overflow sur la carte.
          childAspectRatio: 0.6,
        ),
        itemCount: _relais.length,
        itemBuilder: (context, index) => MarketplaceRelaisCard(relais: _relais[index]),
      ),
    );
  }
}

class _AdvancedFilters {
  final int? rooms;
  final int? priceMin;
  final int? priceMax;
  const _AdvancedFilters({this.rooms, this.priceMin, this.priceMax});
}

const List<int> _roomOptions = [1, 2, 3, 4];

/// Filtre pièces + budget — repliés dans une feuille pour ne pas
/// surcharger la barre de recherche (juste un bouton rond en plus).
class _AdvancedFiltersSheet extends StatefulWidget {
  final int? initialRooms;
  final int? initialPriceMin;
  final int? initialPriceMax;

  const _AdvancedFiltersSheet({this.initialRooms, this.initialPriceMin, this.initialPriceMax});

  @override
  State<_AdvancedFiltersSheet> createState() => _AdvancedFiltersSheetState();
}

class _AdvancedFiltersSheetState extends State<_AdvancedFiltersSheet> {
  late int? _rooms = widget.initialRooms;
  late final _minController = TextEditingController(text: widget.initialPriceMin?.toString() ?? '');
  late final _maxController = TextEditingController(text: widget.initialPriceMax?.toString() ?? '');

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.pop(
      context,
      _AdvancedFilters(
        rooms: _rooms,
        priceMin: int.tryParse(_minController.text.trim()),
        priceMax: int.tryParse(_maxController.text.trim()),
      ),
    );
  }

  void _reset() {
    setState(() {
      _rooms = null;
      _minController.clear();
      _maxController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const Gap(16),
          Text('Filtres', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold)),
          const Gap(20),
          Text('Pièces (min.)', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
          const Gap(10),
          Wrap(
            spacing: 8,
            children: [
              for (final rooms in _roomOptions)
                GestureDetector(
                  onTap: () => setState(() => _rooms = _rooms == rooms ? null : rooms),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _rooms == rooms ? AppColors.primary : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      rooms == 4 ? '4+' : '$rooms',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _rooms == rooms ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(20),
          Text('Budget (FCFA)', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
          const Gap(10),
          Row(
            children: [
              Expanded(child: _PriceField(controller: _minController, hint: 'Min')),
              const Gap(12),
              Expanded(child: _PriceField(controller: _maxController, hint: 'Max')),
            ],
          ),
          const Gap(24),
          Row(
            children: [
              Expanded(
                child: CustomButtom(
                  text: 'Réinitialiser',
                  onClick: _reset,
                  color: Colors.grey.shade100,
                  textColor: Colors.grey.shade700,
                  elevation: 0,
                ),
              ),
              const Gap(12),
              Expanded(
                child: CustomButtom(
                  text: 'Appliquer',
                  onClick: _apply,
                  color: AppColors.primary,
                  textColor: Colors.white,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _PriceField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: GoogleFonts.dmSans(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
