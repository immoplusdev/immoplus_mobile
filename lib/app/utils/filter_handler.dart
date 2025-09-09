import 'dart:developer';

import 'package:immoplus/app/constants/constantes.dart';

enum PropertyType {
  residence,
  estate,
  furniture,
  land,
}

enum FilterField {
  price,
}

class FilterHandler {
  static String? search;
  static String? startDate;
  static String? endDate;
  static double? lat;
  static double? long;
  static int minPrice = minPriceLimit;
  static int maxPrice = maxPriceLimit;
  static String? locationName;

  static cleanParameters() {
    search = null;
    lat = null;
    long = null;
    locationName = null;
    startDate = null;
    endDate = null;

    minPrice = minPriceLimit;
    maxPrice = maxPriceLimit;
  }

  // Mapping des champs par type de propriété
  static const Map<PropertyType, Map<FilterField, String>> _fieldMapping = {
    PropertyType.residence: {
      FilterField.price: 'prixReservation',
    },
    PropertyType.estate: {
      FilterField.price: 'prix',
    },
    PropertyType.furniture: {
      FilterField.price: 'prix',
    },
    PropertyType.land: {
      FilterField.price: 'prix',
    },
  };

  // Méthode pour obtenir le nom du champ selon le type
  static String getFieldName(PropertyType propertyType, FilterField field) {
    return _fieldMapping[propertyType]?[field] ?? 'prix';
  }

  // Génération des filtres WHERE pour les prix
  static List<String> getPriceFilters(PropertyType propertyType) {
    final priceField = getFieldName(propertyType, FilterField.price);
    final List<String> filters = [];

    if (minPrice > minPriceLimit) {
      filters
          .add('{"_field": "$priceField", "_op": "gte", "_val": "$minPrice"}');
    }

    if (maxPrice < maxPriceLimit) {
      filters
          .add('{"_field": "$priceField", "_op": "lte", "_val": "$maxPrice"}');
    }

    return filters;
  }

  static Map<String, List<String>> getAllFilters(PropertyType propertyType) {
    final List<String> allFilters = [];

    // Ajout des différents types de filtres
    allFilters.addAll(getPriceFilters(propertyType));

    if (allFilters.isEmpty) {
      return {};
    }

    final filters = {
      '_where': allFilters,
    };
    inspect(filters);
    return filters;
  }

  // Méthode pour vérifier si des filtres sont actifs
  static bool get hasActiveFilters {
    return search != null ||
        startDate != null ||
        endDate != null ||
        lat != null ||
        long != null ||
        minPrice > minPriceLimit ||
        maxPrice < maxPriceLimit;
  }

  // Méthode pour obtenir un résumé des filtres actifs
  static String getActiveFiltersDescription() {
    final List<String> descriptions = [];

    if (search != null && search!.isNotEmpty) {
      descriptions.add('Recherche: "$search"');
    }

    if (locationName != null) {
      descriptions.add('Lieu: $locationName');
    }

    if (startDate != null || endDate != null) {
      if (startDate != null && endDate != null) {
        descriptions.add(
            'Dates: ${startDate!.split('T')[0]} - ${endDate!.split('T')[0]}');
      } else if (startDate != null) {
        descriptions.add('À partir du: ${startDate!.split('T')[0]}');
      } else {
        descriptions.add('Jusqu\'au: ${endDate!.split('T')[0]}');
      }
    }

    if (minPrice > minPriceLimit || maxPrice < maxPriceLimit) {
      descriptions.add('Prix: $minPrice€ - $maxPrice€');
    }

    return descriptions.join(' • ');
  }
}
