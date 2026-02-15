import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Position? currentPosition;

  static Future<Position?> getCurrentLocation(
      {required BuildContext context}) async {
    // Check if location services are enabled
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      // Location services are not enabled, show a dialog to request permission
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services to access your current location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }

    // Check if location permission is granted
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Location permission is not granted, show a dialog to request permission
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text(
              'Please grant location permission to access your current location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }

    // Get the current location
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return currentPosition;
  }

  Future<GeoJSONFeature?> getCurrentgeoJson() async {
    // Demande de permission d'accès à la position
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    // Si la permission est refusée, retourne null
    if (locationPermission == LocationPermission.deniedForever) {
      return null;
    }

    // Obtention de la position actuelle
    final position = await Geolocator.getCurrentPosition();
    Map<String, dynamic> locality =
        await _getAddressName(position.latitude, position.longitude);
    // Conversion de la position en GeoJSONFeature
    final feature = GeoJSONFeature(
      GeoJSONPoint([position.longitude, position.latitude]),
      properties: locality,
    );

    return feature;
  }

  static Future<Position> getCurrentPosition() async {
    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        throw CustomLocationServiceDisabledException(
          'Veuillez activer les services de localisation dans les paramètres',
        );
      }

      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        locationPermission = await Geolocator.requestPermission();
      }
      if ([
        LocationPermission.always,
        LocationPermission.whileInUse,
      ].any((element) => element == locationPermission)) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        return position;
      } else {
        throw LocationPermissionDeniedException(
            'Location permissions are denied.');
      }
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationUnknownException(e.toString());
    }
  }

  /// Fonction pour obtenir le nom de la position à partir des coordonnées

  Future<Map<String, dynamic>> _getAddressName(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return {
          "title": "${place.name}",
          "subtitle": "${place.subLocality}",
          "name": "${place.name} ${place.subLocality}",
        };
      } else {
        return {
          "title": "",
          "subtitle": "",
          "name": "",
        };
      }
    } catch (e) {
      return {};
    }
  }

  /// Vérifie si les permissions de localisation sont accordées
  static Future<bool> hasLocationPermission() async {
    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }
}
