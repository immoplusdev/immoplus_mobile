import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceAutocompleteWidget extends StatefulWidget {
  final Function(LatLng) onPlaceSelected;
  final String googleApiKey;
  final Function(bool)? onFocusChange; // Callback pour gérer le focus
  final FocusNode focusNode;
  const PlaceAutocompleteWidget({
    super.key,
    required this.onPlaceSelected,
    required this.googleApiKey,
    required this.focusNode,
    this.onFocusChange, // Callback optionnel
  });

  @override
  _PlaceAutocompleteWidgetState createState() =>
      _PlaceAutocompleteWidgetState();
}

class _PlaceAutocompleteWidgetState extends State<PlaceAutocompleteWidget> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();

  List<dynamic> _predictions = [];
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });

    // Appeler le callback fourni par le parent si disponible
    if (widget.onFocusChange != null) {
      widget.onFocusChange!(widget.focusNode.hasFocus);
    }

    // if (_isFocused = true) {
    //   Future.delayed(const Duration(microseconds: 300), () {
    //     widget.focusNode.requestFocus();
    //   });
    // }
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions.clear();
      });
      return;
    }

    const url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final response = await _dio.get(url, queryParameters: {
      'input': query,
      'key': widget.googleApiKey,
      'components': 'country:ci', // Restriction aux résultats en Côte d’Ivoire
    });

    if (response.statusCode == 200) {
      setState(() {
        _predictions = response.data['predictions'] ?? [];
      });
    } else {
      setState(() {
        _predictions.clear();
      });
    }
  }

  Future<void> _onPredictionTap(dynamic prediction) async {
    final placeId = prediction['place_id'];
    const url = 'https://maps.googleapis.com/maps/api/place/details/json';

    final response = await _dio.get(url, queryParameters: {
      'place_id': placeId,
      'key': widget.googleApiKey,
      'fields': 'geometry',
    });

    if (response.statusCode == 200) {
      final location = response.data['result']['geometry']['location']
          as Map<String, dynamic>;
      final lat = location['lat'] as double?;
      final lng = location['lng'] as double?;

      if (lat != null && lng != null) {
        widget.onPlaceSelected(LatLng(lat, lng));
        _controller.clear();
        setState(() {
          _predictions.clear();
        });
        widget.focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          controller: _controller,
          focusNode: widget.focusNode,
          placeholder: "Rechercher un lieu",
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          prefix: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(CupertinoIcons.search, size: 20),
          ),
          onChanged: _onSearchChanged,
          clearButtonMode: OverlayVisibilityMode.editing,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 2,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
        if (_isFocused && _predictions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 1,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _predictions.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return CupertinoListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      FontAwesomeIcons.locationDot,
                      size: 15,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  onTap: () => _onPredictionTap(prediction),
                  title: Text(
                    prediction['description'] ?? "",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
