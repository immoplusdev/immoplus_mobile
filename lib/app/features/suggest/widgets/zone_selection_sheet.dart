import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';

class SelectedZone {
  final String id;
  final String nom;
  final double lat;
  final double lng;

  const SelectedZone({
    required this.id,
    required this.nom,
    required this.lat,
    required this.lng,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedZone &&
          runtimeType == other.runtimeType &&
          nom == other.nom;

  @override
  int get hashCode => nom.hashCode;
}

class ZoneSelectionSheet extends StatefulWidget {
  final List<SelectedZone> initialSelectedZones;
  final ScrollController? scrollController;

  const ZoneSelectionSheet({
    super.key,
    required this.initialSelectedZones,
    this.scrollController,
  });

  static Future<List<SelectedZone>?> show(
      BuildContext context, List<SelectedZone> initial) {
    return showModalBottomSheet<List<SelectedZone>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => ZoneSelectionSheet(
          initialSelectedZones: initial,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  State<ZoneSelectionSheet> createState() => _ZoneSelectionSheetState();
}

class _ZoneSelectionSheetState extends State<ZoneSelectionSheet> {
  final List<SelectedZone> availableZones = const [
    SelectedZone(id: '1', nom: 'Cocody, Abidjan', lat: 5.359951, lng: -4.008256),
    SelectedZone(
        id: '2', nom: 'Palmeraie, Abidjan', lat: 5.361520, lng: -3.966750),
    SelectedZone(id: '5', nom: 'Yopougon, Abidjan', lat: 5.334000, lng: -4.072000),
    SelectedZone(id: '6', nom: 'Grand-Bassam, Abidjan', lat: 5.204500, lng: -3.737100),
    SelectedZone(id: '7', nom: 'Assinie, Comoé', lat: 5.127400, lng: -3.275000),
  ];

  late List<SelectedZone> _tempSelected;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Dio _dio = Dio();
  List<dynamic> _predictions = [];
  bool _isSearching = false;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.initialSelectedZones);
    if (_tempSelected.isEmpty && availableZones.isNotEmpty) {
      _tempSelected.add(availableZones.first);
    }
  }

  String _formatAddress(String description) {
    final parts = description
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return description;

    // Retirer la mention du pays si présente dans les parties
    final filteredParts = parts.where((p) {
      final lower = p.toLowerCase();
      return !lower.contains("côte d'ivoire") &&
          !lower.contains("cote d'ivoire") &&
          !lower.contains("ivory coast");
    }).toList();

    if (filteredParts.isEmpty) {
      return parts.first;
    } else if (filteredParts.length == 1) {
      return filteredParts.first;
    } else if (filteredParts.length == 2) {
      return '${filteredParts[0]}, ${filteredParts[1]}';
    } else {
      // Ex: ["Riviera 3", "Cocody", "Abidjan"] -> "Riviera 3, Abidjan"
      return '${filteredParts.first}, ${filteredParts.last}';
    }
  }

  bool _tryAddZone(SelectedZone zone) {
    if (_tempSelected.contains(zone)) return true;
    if (_tempSelected.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('3 zones maximum sélectionnables.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    _tempSelected.add(zone);
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _predictions.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
      const url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      final response = await _dio.get(url, queryParameters: {
        'input': query,
        'key': apiKey,
        'components': 'country:ci',
        'language': 'fr',
      });

      if (response.statusCode == 200 && mounted) {
        setState(() {
          _predictions = response.data['predictions'] ?? [];
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _predictions.clear();
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _onPredictionTap(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final description = prediction['description'] ?? '';

    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
      const url = 'https://maps.googleapis.com/maps/api/place/details/json';
      final response = await _dio.get(url, queryParameters: {
        'place_id': placeId,
        'key': apiKey,
        'fields': 'geometry',
      });

      if (response.statusCode == 200) {
        final location = response.data['result']['geometry']['location']
            as Map<String, dynamic>;
        final lat = location['lat'] as double?;
        final lng = location['lng'] as double?;

        if (lat != null && lng != null && mounted) {
          final formattedNom = _formatAddress(description);
          final zone = SelectedZone(
            id: placeId,
            nom: formattedNom,
            lat: lat,
            lng: lng,
          );

          setState(() {
            _tryAddZone(zone);
            _searchController.clear();
            _predictions.clear();
          });
          _searchFocusNode.unfocus();
        }
      }
    } catch (e) {
      // Silently ignore
    }
  }

  Future<void> _shareMyPosition() async {
    setState(() => _isGettingLocation = true);

    try {
      final position = await LocationService.getCurrentPosition();

      // Reverse geocode to get location name (harmonized with central LocationService)
      String locationName = 'Ma position';
      try {
        final address = await LocationService.getFormattedAddress(
          latitude: position.latitude,
          longitude: position.longitude,
          maxLength: 40,
        );
        if (address.isNotEmpty && address != 'Partager ma position') {
          locationName = address;
        }
      } catch (_) {}

      if (mounted) {
        final zone = SelectedZone(
          id: 'my_position',
          nom: locationName,
          lat: position.latitude,
          lng: position.longitude,
        );

        setState(() {
          _tryAddZone(zone);
          _isGettingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Impossible d\'obtenir votre position.')),
        );
        setState(() => _isGettingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title with selection count
          Row(
            children: [
              const Expanded(
                child: Text('Où ?',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              if (_tempSelected.length > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${_tempSelected.length - 1}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Search bar
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Rechercher une adresse...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              prefixIcon:
                  Icon(Icons.search, color: Colors.grey.shade500, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear,
                          color: Colors.grey.shade500, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _predictions.clear());
                      },
                    )
                  : null,
              filled: false,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Share position button
          InkWell(
            onTap: _isGettingLocation ? null : _shareMyPosition,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isGettingLocation
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          )
                        : Icon(Icons.my_location,
                            color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Partager votre position',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Google autocomplete results
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            )
          else if (_predictions.isNotEmpty) ...[
            const Divider(height: 1),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _predictions.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.location_on_outlined,
                        color: Colors.grey.shade500, size: 20),
                    title: Text(
                      prediction['description'] ?? '',
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _onPredictionTap(prediction),
                  );
                },
              ),
            ),
            const Divider(height: 1),
          ],

          const SizedBox(height: 16),

          // Quick-select zone chips
          const Text(
            'Zones populaires',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: availableZones.map((z) {
              final isSelected = _tempSelected.contains(z);
              return ChoiceChip(
                label: Text(z.nom),
                selected: isSelected,
                selectedColor: Colors.black,
                backgroundColor: Colors.white,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _tryAddZone(z);
                    } else {
                      _tempSelected.remove(z);
                    }
                  });
                },
              );
            }).toList(),
          ),

          // Selected zones display
          if (_tempSelected.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _tempSelected.map((z) {
                return Chip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  label: Text(
                    z.nom,
                    style: TextStyle(
                        fontSize: 12, color: AppColors.primary),
                  ),
                  deleteIcon: Icon(Icons.close,
                      size: 13, color: AppColors.primary),
                  onDeleted: () {
                    setState(() => _tempSelected.remove(z));
                  },
                  backgroundColor:
                      AppColors.primary.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color:
                            AppColors.primary.withValues(alpha: 0.2)),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 24),
          CustomButtom(
            text: _tempSelected.isEmpty
                ? 'Sélectionnez une zone'
                : 'Garder ${_tempSelected.length == 1 ? 'cette zone' : 'ces ${_tempSelected.length} zones'}',
            onClick: _tempSelected.isEmpty
                ? null
                : () => Navigator.pop(context, _tempSelected),
          ),
        ],
      ),
    );
  }
}
