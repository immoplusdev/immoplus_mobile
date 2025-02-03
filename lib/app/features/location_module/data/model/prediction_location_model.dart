// ignore_for_file: prefer_collection_literals

class PredictionPickerModel {
  String? icon;
  GeometryPickerLocation? geometry;

  PredictionPickerModel({icon, geometry});

  PredictionPickerModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    geometry = json['geometry'] != null
        ? GeometryPickerLocation.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['icon'] = icon;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

class GeometryPickerLocation {
  LocationPicker? location;

  GeometryPickerLocation({location});

  GeometryPickerLocation.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? LocationPicker.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class LocationPicker {
  double? lat;
  double? lng;

  LocationPicker({lat, lng});

  LocationPicker.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
