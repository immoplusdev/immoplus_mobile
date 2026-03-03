import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_state.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationPermissionCubit extends Cubit<LocationPermissionState> {
  LocationPermissionCubit() : super(const LocationPermissionState.initial());

  /// Vérifie l'état actuel de la permission
  Future<void> checkPermission() async {
    emit(const LocationPermissionState.checking());

    try {
      final permission = await LocationService.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        emit(const LocationPermissionState.granted());
      } else if (permission == LocationPermission.deniedForever) {
        emit(const LocationPermissionState.permanentlyDenied());
      } else if (permission == LocationPermission.denied) {
        // Première fois ou refusée temporairement
        emit(const LocationPermissionState.notDetermined());
      }
    } catch (e) {
      emit(const LocationPermissionState.notDetermined());
    }
  }

  /// Demande la permission à l'utilisateur
  Future<void> requestPermission() async {
    try {
      final permission = await LocationService.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        emit(const LocationPermissionState.granted());
      } else if (permission == LocationPermission.deniedForever) {
        emit(const LocationPermissionState.permanentlyDenied());
      } else {
        emit(const LocationPermissionState.denied());
      }
    } catch (e) {
      emit(const LocationPermissionState.denied());
    }
  }
}
