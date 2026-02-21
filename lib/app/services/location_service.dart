import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immoplus/app/core/network/exceptions/location_exceptions.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Position? currentPosition;

  // ─── Permission centralisée ───────────────────────────────────────────────

  static Future<LocationPermission> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedException(
        'Les permissions de localisation sont refusées définitivement.',
      );
    }

    return permission;
  }

  static Future<void> _ensureServiceEnabled() async {
    final bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw CustomLocationServiceDisabledException(
        'Veuillez activer les services de localisation dans les paramètres.',
      );
    }
  }

  // ─── API Publique ─────────────────────────────────────────────────────────

  static Future<bool> hasLocationPermission() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;
      final LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  static Future<Position> getCurrentPosition() async {
    try {
      await _ensureServiceEnabled();
      await _ensurePermission();
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationUnknownException(e.toString());
    }
  }

  static Future<Position?> getCurrentLocation({
    required BuildContext context,
  }) async {
    try {
      await _ensureServiceEnabled();
      await _ensurePermission();
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return currentPosition;
    } on CustomLocationServiceDisabledException {
      if (context.mounted) {
        _showDialog(
          context: context,
          title: 'Service de localisation désactivé',
          content:
              'Veuillez activer les services de localisation dans les paramètres.',
        );
      }
      return null;
    } on LocationPermissionDeniedException {
      if (context.mounted) {
        _showDialog(
          context: context,
          title: 'Permission refusée',
          content:
              'Veuillez autoriser l\'accès à votre position dans les paramètres.',
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<GeoJSONFeature?> getCurrentGeoJson() async {
    try {
      await LocationService._ensurePermission();
      final Position position = await Geolocator.getCurrentPosition();
      final Map<String, dynamic> locality =
          await _getAddressName(position.latitude, position.longitude);
      return GeoJSONFeature(
        GeoJSONPoint([position.longitude, position.latitude]),
        properties: locality,
      );
    } on LocationPermissionDeniedException {
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<String> getFormattedAddress({
    required double latitude,
    required double longitude,
    int maxLength = 25,
  }) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return 'Position actuelle';

      final Placemark place = placemarks.first;
      final String address = place.street?.isNotEmpty == true
          ? place.street!
          : place.subLocality?.isNotEmpty == true
              ? place.subLocality!
              : place.locality?.isNotEmpty == true
                  ? place.locality!
                  : place.administrativeArea?.isNotEmpty == true
                      ? place.administrativeArea!
                      : 'Position actuelle';

      return address.length > maxLength
          ? '${address.substring(0, maxLength)}...'
          : address;
    } catch (_) {
      return 'Position indisponible';
    }
  }

  // ─── Privé ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _getAddressName(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return {"title": "", "subtitle": "", "name": ""};
      final Placemark place = placemarks.first;
      return {
        "title": place.name ?? '',
        "subtitle": place.subLocality ?? '',
        "name": '${place.name ?? ''} ${place.subLocality ?? ''}'.trim(),
      };
    } catch (_) {
      return {"title": "", "subtitle": "", "name": ""};
    }
  }

  static void _showDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: openAppSettings,
            child: const Text('Paramètres'),
          ),
        ],
      ),
    );
  }
}
