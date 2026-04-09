import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_permission_state.freezed.dart';

@freezed
class LocationPermissionState with _$LocationPermissionState {
  const LocationPermissionState._(); // Constructeur privé pour ajouter des méthodes custom

  const factory LocationPermissionState.initial() = _Initial;
  const factory LocationPermissionState.checking() = _Checking;
  const factory LocationPermissionState.granted() = _Granted;
  const factory LocationPermissionState.denied() = _Denied;
  const factory LocationPermissionState.permanentlyDenied() = _PermanentlyDenied;
  const factory LocationPermissionState.notDetermined() = _NotDetermined;

  // Getters publics pour vérifier l'état
  bool get isGranted => maybeWhen(granted: () => true, orElse: () => false);
  bool get isDenied => maybeWhen(denied: () => true, orElse: () => false);
  bool get isPermanentlyDenied => maybeWhen(permanentlyDenied: () => true, orElse: () => false);
  bool get isNotDetermined => maybeWhen(notDetermined: () => true, orElse: () => false);
}
