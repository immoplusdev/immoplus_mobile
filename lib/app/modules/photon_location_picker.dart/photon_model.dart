import 'package:geojson_vi/geojson_vi.dart';

class PhotonApiResponse {
  Geometry? geometry;
  String? type;
  Properties? properties;
  GeoJSONFeature? geoJson;

  PhotonApiResponse({this.geometry, this.type, this.properties, this.geoJson});

  PhotonApiResponse.fromJson(Map<String, dynamic> json) {
    geoJson = GeoJSONFeature.fromMap(json);
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = type;
    return data;
  }
}

class Properties {
  String? osmType;
  int? osmId;
  String? country;
  String? osmKey;
  String? city;
  String? street;
  String? countryCode;
  String? osmValue;
  String? name;
  String? state;
  String? type;

  Properties(
      {this.osmType,
      this.osmId,
      this.country,
      this.osmKey,
      this.city,
      this.street,
      this.countryCode,
      this.osmValue,
      this.name,
      this.state,
      this.type});

  Properties.fromJson(Map<String, dynamic> json) {
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    country = json['country'];
    osmKey = json['osm_key'];
    city = json['city'];
    street = json['street'];
    countryCode = json['countrycode'];
    osmValue = json['osm_value'];
    name = json['name'];
    state = json['state'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['osm_type'] = osmType;
    data['osm_id'] = osmId;
    data['country'] = country;
    data['osm_key'] = osmKey;
    data['city'] = city;
    data['street'] = street;
    data['countrycode'] = countryCode;
    data['osm_value'] = osmValue;
    data['name'] = name;
    data['state'] = state;
    data['type'] = type;
    return data;
  }
}
