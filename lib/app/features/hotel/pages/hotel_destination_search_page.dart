import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/features/location_module/data/model/autocomplete_response.dart';
import 'package:immoplus/app/features/location_module/data/places_api_repository.dart';
import 'package:immoplus/app/features/suggest/pages/components/suggest_search_bar.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class HotelDestinationSearchPage extends StatefulWidget {
  final String? initialQuery;

  const HotelDestinationSearchPage({super.key, this.initialQuery});

  @override
  State<HotelDestinationSearchPage> createState() =>
      _HotelDestinationSearchPageState();
}

class _HotelDestinationSearchPageState
    extends State<HotelDestinationSearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _placesRepo = PlacesApiRepository();

  List<CustomPrediction> _predictions = [];
  bool _isLoading = false;
  Timer? _debounce;
  String _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

  /// Popular destinations to show when there's no query
  static const _popularDestinations = [
    _PopularDest(
        name: 'Abidjan', subtitle: 'Côte d\'Ivoire', icon: Iconsax.buildings),
    _PopularDest(
        name: 'Yamoussoukro',
        subtitle: 'Côte d\'Ivoire',
        icon: Iconsax.building),
    _PopularDest(
        name: 'Bouaké', subtitle: 'Côte d\'Ivoire', icon: Iconsax.building),
    _PopularDest(
        name: 'San-Pédro', subtitle: 'Côte d\'Ivoire', icon: Iconsax.building),
    _PopularDest(
        name: 'Grand-Bassam',
        subtitle: 'Côte d\'Ivoire',
        icon: Iconsax.building),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _controller.text = widget.initialQuery!;
      _fetchPredictions(widget.initialQuery!);
    }
    // auto-focus keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged() {
    final query = _controller.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchPredictions(query);
    });
  }

  Future<void> _fetchPredictions(String query) async {
    try {
      final result = await _placesRepo.getPlaceAutocomplete(
        input: query.replaceAll(' ', '+'),
        sessionToken: _sessionToken,
      );
      if (mounted) {
        setState(() {
          _predictions = result.predictions ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint('Autocomplete error: $e');
    }
  }

  void _selectPrediction(CustomPrediction p) {
    _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
    Navigator.of(context).pop(p.description ?? '');
  }

  void _selectPopular(String name) {
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final showPopular = _controller.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── SuggestSearchBar (unifié) ──
            SuggestSearchBar(
              controller: _controller,
              focusNode: _focusNode,
              hintText: 'Où souhaitez-vous aller ?',
              showClearButton: _controller.text.isNotEmpty,
              showSearchButton: false,
              onClear: () {
                _controller.clear();
                setState(() => _predictions = []);
              },
              onFieldSubmitted: (v) {
                if (v.trim().isNotEmpty) Navigator.of(context).pop(v.trim());
              },
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            const Divider(height: 1),
            // ── Body ──
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5)))
                  : showPopular
                      ? _buildPopularList()
                      : _predictions.isEmpty
                          ? _buildEmpty()
                          : _buildSuggestionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text(
          "Destinations populaires",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const Gap(12),
        ..._popularDestinations.map((dest) => _buildPopularTile(dest)),
      ],
    );
  }

  Widget _buildPopularTile(_PopularDest dest) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(dest.icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        dest.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        dest.subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
      onTap: () => _selectPopular(dest.name),
    );
  }

  Widget _buildSuggestionList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      itemCount: _predictions.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, indent: 70, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final p = _predictions[index];
        final mainText =
            p.structuredFormatting?.mainText ?? p.description ?? '';
        final secondaryText = p.structuredFormatting?.secondaryText ?? '';
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Iconsax.location, size: 20, color: AppColors.primary),
          ),
          title: Text(
            mainText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: secondaryText.isNotEmpty
              ? Text(
                  secondaryText,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: () => _selectPrediction(p),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.location_slash, size: 56, color: Colors.grey.shade300),
          const Gap(16),
          Text(
            'Aucun résultat',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600),
          ),
          const Gap(6),
          Text(
            'Essayez un autre terme de recherche.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _PopularDest {
  final String name;
  final String subtitle;
  final IconData icon;
  const _PopularDest(
      {required this.name, required this.subtitle, required this.icon});
}
