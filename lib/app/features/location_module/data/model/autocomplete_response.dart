class AutocompleteResponse {
  final List<CustomPrediction>? predictions;
  final String? status;

  AutocompleteResponse({
    this.predictions,
    this.status,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      AutocompleteResponse(
        predictions: json['predictions'] == null
            ? null
            : List<CustomPrediction>.from(
                json['predictions'].map((x) => CustomPrediction.fromJson(x))),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'predictions': predictions?.map((x) => x.toJson()).toList(),
        'status': status,
      };
}

class CustomPrediction {
  String? id;
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;
  String? lat;
  String? lng;
  CustomPrediction({
    this.id,
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
    this.lat,
    this.lng,
  });

  factory CustomPrediction.fromJson(Map<String, dynamic> json) =>
      CustomPrediction(
        id: json['id'],
        description: json['description'],
        matchedSubstrings: json['matched_substrings'] == null
            ? null
            : List<MatchedSubstring>.from(json['matched_substrings']
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting: json['structured_formatting'] == null
            ? null
            : StructuredFormatting.fromJson(json['structured_formatting']),
        terms: json['terms'] == null
            ? null
            : List<Term>.from(json['terms'].map((x) => Term.fromJson(x))),
        types: json['types'] == null
            ? null
            : List<String>.from(json['types'].map((x) => x)),
        lat: json['lat'],
        lng: json['lng'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'matched_substrings':
            matchedSubstrings?.map((x) => x.toJson()).toList(),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting?.toJson(),
        'terms': terms?.map((x) => x.toJson()).toList(),
        'types': types,
        'lat': lat,
        'lng': lng,
      };
}

class MatchedSubstring {
  final int? length;
  final int? offset;

  MatchedSubstring({
    this.length,
    this.offset,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json['length'],
        offset: json['offset'],
      );

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstring>? mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'],
        mainTextMatchedSubstrings: json['main_text_matched_substrings'] == null
            ? null
            : List<MatchedSubstring>.from(json['main_text_matched_substrings']
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json['secondary_text'],
      );

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings':
            mainTextMatchedSubstrings?.map((x) => x.toJson()).toList(),
        'secondary_text': secondaryText,
      };
}

class Term {
  final int? offset;
  final String? value;

  Term({
    this.offset,
    this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json['offset'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}
