import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: implementation_imports
import 'package:rxdart/src/subjects/publish_subject.dart';
// ignore: implementation_imports
import 'package:rxdart/src/transformers/backpressure/debounce.dart';
import 'package:uuid/uuid.dart';

import '../../routes/app_router.dart';
import '../../services/location_service.dart';
import '../../services/navigation_service.dart';
import '../../widgets/custom_popup.dart';
import 'data/geocoding_api_repository.dart';
import 'data/model/address.dart';
import 'data/model/address_exception.dart';
import 'data/model/autocomplete_response.dart';
import 'data/model/prediction_location_model.dart';
import 'data/model/reverse_geocoding_response.dart';
import 'data/places_api_repository.dart';
import 'location_page.dart';

enum GeocodingApi { devicePlatform, googleMapsPlatform }

class LocationController extends GetxController
    with StateMixin<List<CustomPrediction>> {
  final GeocodingApiRepository geocodingApiRepository =
      GeocodingApiRepository();

  final PlacesApiRepository placesApiRepository = PlacesApiRepository();

  final subject = PublishSubject<String>();

  final TextEditingController searchController = TextEditingController();

  /// Session token required for autocomplete API call
  String sessionToken = const Uuid().v4();

  //final LocationService locationService = Get.find();

  List<CustomPrediction> previousAddresses = [];
  final placeAutocompleteList = <CustomPrediction>[].obs;

  GoogleMapController? mapController;

  ///Map zoom
  final double zoom = 18;

  /// Map camera address
  final cameraAddress = Address().obs;
  Timer? _debounce;
  LatLng? _lastCameraPosition;

  // Durée du debounce
  static const int _debounceTimeMillis = 700;
  @override
  void onInit() {
    super.onInit();

    change(state, status: RxStatus.success());

    subject.stream
        .distinct()
        .debounceTime(const Duration(milliseconds: 200))
        .listen((event) {
      searchController.text = event;
      _search();
    });

    _init();
  }

  _init() {
    // Client client =
    //     Client.fromJson(jsonDecode(GetStorage().read(Constants.user) ?? "{}"));

    previousAddresses.clear();
    // previousAddresses.addAll(client.addresses
    //     .map((address) => CustomPrediction(
    //           id: address.id?.toString(),
    //           placeId: address.placeId,
    //           // Prediction.reference is used as [Address.alias]
    //           reference: address.alias,
    //           description: address.description,
    //           lat: address.latitude?.toString(),
    //           lng: address.longitude?.toString(),
    //         ))
    //     .toList());

    placeAutocompleteList.clear();
    placeAutocompleteList.addAll(previousAddresses);
  }

  getCurrentPosition() async {
    change(state, status: RxStatus.loading());

    try {
      CustomPopup.showLoagingToast();
      final position = await LocationService.getCurrentPosition()
          .onError((error, stackTrace) => throw AddressException());

      final locationAdreess = await _getAddressFromGeocodingApi(
          latitude: position.latitude, longitude: position.longitude);

      EasyLoading.dismiss();
      AppRouter.router.pop(locationAdreess);
    } catch (e) {
      CustomPopup.hideLoadingToast();
      change(state, status: RxStatus.error(e.toString()));
      return;
    }
  }

  _search() async {
    final place = searchController.text.trim().replaceAll(" ", "+");
    if (place.isEmpty) {
      _init();
      return;
    }

    change(state, status: RxStatus.loading());

    placesApiRepository
        .getPlaceAutocomplete(input: place, sessionToken: sessionToken)
        .then((value) {
      placeAutocompleteList.clear();
      placeAutocompleteList.addAll(value.predictions ?? []);
      change(value.predictions, status: RxStatus.success());
    }).onError((error, stackTrace) {
      change(state, status: RxStatus.error(error.toString()));
    });
  }

  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final me = await getLatLngPosition();
    moveToLocation(me);
  }

  moveToLocation(LatLng latLng) async {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom)));
  }

  onCameraIdle() {
    change(state, status: RxStatus.loading());
  }

  onCameraMove(CameraPosition position) async {
    // cameraAddress.value = cameraAddress.value.copyWith(
    //     latitude: position.target.latitude,
    //     longitude: position.target.longitude);
    // Annulez le précédent Timer
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Démarrez un nouveau Timer
    _debounce =
        Timer(const Duration(milliseconds: _debounceTimeMillis), () async {
      // Appellez votre logique ici une fois que la caméra a cessé de bouger
      change(state, status: RxStatus.loading());

      cameraAddress(await _getAddressFromGeocodingApi(
          latitude: position.target.latitude,
          longitude: position.target.longitude));
      change(state, status: RxStatus.success());
    });
  }

  Future<PredictionPickerModel> getDetailsPrediction(String id) async {
    final details = await Dio().get(
      'https://maps.googleapis.com/maps/api/place/details/json',
      queryParameters: {
        "placeid": id,
        "key": dotenv.env["GOOGLE_API_KEY"],
      },
    );
    inspect(details);
    //inspect(details.data['result']);
    PredictionPickerModel result =
        PredictionPickerModel.fromJson(details.data['result']);
    return result;
  }

  onAutocompleteItemClick(CustomPrediction item) async {
    change(state, status: RxStatus.loading());

    item = previousAddresses.firstWhereOrNull((element) =>
            element.placeId != null && element.placeId == item.placeId) ??
        item;
    try {
      CustomPopup.showLoagingToast();
      PredictionPickerModel detail = await getDetailsPrediction(item.placeId!);
      EasyLoading.dismiss();
      final address = Address(
        id: int.tryParse(item.id ?? ""),
        placeId: item.placeId,
        alias: item.reference,
        description: item.description,
        latitude:
            detail.geometry!.location!.lat, // double.tryParse(item.lat ?? ""),
        longitude:
            detail.geometry!.location!.lng, // double.tryParse(item.lng ?? ""),
      );
      NavigationService.navigatorKey.currentContext!.pop(address);
    } catch (e) {
      NavigationService.navigatorKey.currentContext!.pop(null);
    }

    //Get.back(result: address);
  }

  /// Reverse geocoding address
  Future<Address> _getAddressFromGeocodingApi(
      {required double latitude, required double longitude}) async {
    try {
      final response = await geocodingApiRepository.geocodingAddressLookup(
          latitude: latitude, longitude: longitude);

      CustomPrediction? prediction = previousAddresses.firstWhereOrNull(
          (element) =>
              element.placeId != null &&
              element.placeId == response.results.first.placeId);

      if (prediction == null) {
        Map<String, dynamic> locationMap = {};
        for (var addressComponentType in AddressComponentType.values) {
          response.results.first.addressComponents.firstWhereOrNull(
              (addressComponent) => addressComponent.types.any((type) {
                    locationMap[addressComponentType.name] =
                        type == addressComponentType.name
                            ? addressComponent.longName
                            : null;
                    return type == addressComponentType.name;
                  }));
        }
        var locationArray = [];
        locationMap.forEach(
            (key, value) => value != null ? locationArray.add(value) : null);

        prediction = CustomPrediction(
          placeId: response.results.first.placeId,
          description: locationArray.join(", "),
          lat: response.results.first.geometry?.location?.lat?.toString(),
          lng: response.results.first.geometry?.location?.lng?.toString(),
        );
      }
      final address = Address(
        id: int.tryParse(prediction.id ?? ""),
        placeId: prediction.placeId,
        alias: prediction.reference,
        description: prediction.description,
        latitude: double.tryParse(prediction.lat ?? ""),
        longitude: double.tryParse(prediction.lng ?? ""),
      );
      return Future.value(address);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<LatLng> getLatLngPosition() async {
    try {
      final position = await LocationService.getCurrentPosition()
          .onError((error, stackTrace) => throw AddressException());
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return LatLng(5.30966, -4.01266);
    }
  }

  /// Get Address from free Geocoding services provided by the iOS and Android platforms
  Future<Address> _getAddressFromPlacemark(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      List<String> defaultAddressArray = [];
      List<String> keys = [
        "name",
        "street",
        "thoroughfare",
        "subThoroughfare",
        "locality",
        "subLocality",
      ];
      placemarks
          .firstWhereOrNull((element) => element.locality != null)
          ?.toJson()
          .forEach((key, value) => (value as String).isNotEmpty &&
                  keys.any((element) => element == key)
              ? defaultAddressArray.add(value)
              : null);
      List<String> addressArray = [];
      for (var item in defaultAddressArray) {
        addressArray.addIf(!addressArray.contains(item), item);
      }

      final address = Address(
          latitude: latitude,
          longitude: longitude,
          description: addressArray.join(", "));
      return Future.value(address);
    } catch (e) {
      change(state, status: RxStatus.error(AddressException().toString()));
      return Future.error(AddressException().toString());
    }
  }
}
