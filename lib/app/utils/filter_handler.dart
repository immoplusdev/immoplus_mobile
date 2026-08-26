import 'dart:developer';

import 'package:flutter/material.dart';
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

enum EstateSubCategory {
  all('Tout', null),
  appartement('Appartement', 'appartement'),
  // maison('Maison', 'maison'),
  villa('Villa', 'villa'),
  studio('Studio', 'studio'),
  duplex('Duplex', 'duplex');

  final String label;
  final String? value;
  const EstateSubCategory(this.label, this.value);
}

enum FurnitureSubCategory {
  all('Tous', null),
  salon('Salon', 'salon'),
  chambre('Chambre', 'chambre'),
  literie('Literie', 'literie'),
  cuisineSalleAManger('Cuisine & Salle à manger', 'cuisine-salle-a-manger'),
  salleDeBain('Salle de bain', 'salle-de-bain'),
  bureau('Bureau', 'bureau'),
  rangement('Rangement', 'rangement'),
  decoration('Décoration', 'decoration'),
  eclairage('Éclairage', 'eclairage'),
  mobilierExterieur('Mobilier extérieur', 'mobilier-exterieur'),
  // enfantBebe('Enfant & Bébé', 'enfant-bebe'),
  // electromenager('Électroménager', 'electromenager'),
  // multimedia('Multimédia', 'multimedia'),
  evenementiel('Événementiel', 'evenementiel'),
  commerceProfessionnel('Commerce & Pro', 'commerce-professionnel');

  final String label;
  final String? value;
  const FurnitureSubCategory(this.label, this.value);
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
  static EstateSubCategory estateSubCategory = EstateSubCategory.all;
  static FurnitureSubCategory furnitureSubCategory = FurnitureSubCategory.all;

  static final ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  static ValueNotifier<int> get notifier => _notifier;

  static void notifyChange() {
    _notifier.value += 1;
  }

  static cleanParameters() {
    search = null;
    lat = null;
    long = null;
    locationName = null;
    startDate = null;
    endDate = null;

    minPrice = minPriceLimit;
    maxPrice = maxPriceLimit;

    estateSubCategory = EstateSubCategory.all;
    furnitureSubCategory = FurnitureSubCategory.all;

    notifyChange();
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

    // === FILTRES PAR DÉFAUT SELON LE TYPE ===
    switch (propertyType) {
      case PropertyType.estate:
        allFilters.addAll([
          '{"_field": "bienImmobilierDisponible", "_op": "eq", "_val": true}',
          '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
          '{"_field": "aLouer", "_op": "eq", "_val": true}',
        ]);
        if (estateSubCategory != EstateSubCategory.all &&
            estateSubCategory.value != null) {
          allFilters.add(
              '{"_field": "typeBienImmobilier", "_op": "eq", "_val": "${estateSubCategory.value}"}');
        }
        break;

      case PropertyType.land:
        allFilters.addAll([
          '{"_field": "bienImmobilierDisponible", "_op": "eq", "_val": true}',
          '{"_field": "statusValidation", "_op": "eq", "_val": "valide"}',
          '{"_field": "aLouer", "_op": "eq", "_val": false}'
        ]);
        if (estateSubCategory != EstateSubCategory.all &&
            estateSubCategory.value != null) {
          allFilters.add(
              '{"_field": "typeBienImmobilier", "_op": "eq", "_val": "${estateSubCategory.value}"}');
        }
        break;

      case PropertyType.furniture:
        if (furnitureSubCategory != FurnitureSubCategory.all &&
            furnitureSubCategory.value != null) {
          allFilters.add(
              '{"_field": "category", "_op": "eq", "_val": "${furnitureSubCategory.value}"}');
        }
        break;

      // Autres types...
      default:
        break;
    }

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
        minPrice > minPriceLimit ||
        maxPrice < maxPriceLimit ||
        estateSubCategory != EstateSubCategory.all ||
        furnitureSubCategory != FurnitureSubCategory.all;
  }

  static List<Widget> getActiveFiltersChips({VoidCallback? onRefresh}) {
    final List<Widget> chips = [];

    if (search != null && search!.isNotEmpty) {
      chips.add(
        Chip(
          backgroundColor: Colors.grey.shade300,
          label: Text('Recherche: "$search"'),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            search = null;
            notifyChange();
            onRefresh?.call();
          },
        ),
      );
    }

    // if (locationName != null) {
    //   chips.add(
    //     Chip(
    //       backgroundColor: Colors.grey.shade300,
    //       label: Text('Lieu: $locationName'),
    //       deleteIcon: const Icon(Icons.close, size: 18),
    //       onDeleted: () {
    //         lat = null;
    //         long = null;
    //         locationName = null;
    //         notifyChange();
    //         onRefresh?.call();
    //       },
    //     ),
    //   );
    // }

    if (startDate != null || endDate != null) {
      String dateText;
      if (startDate != null && endDate != null) {
        dateText =
            'Dates: ${startDate!.split('T')[0]} - ${endDate!.split('T')[0]}';
      } else if (startDate != null) {
        dateText = 'À partir du: ${startDate!.split('T')[0]}';
      } else {
        dateText = 'Jusqu\'au: ${endDate!.split('T')[0]}';
      }

      chips.add(
        Chip(
          backgroundColor: Colors.grey.shade300,
          label: Text(dateText),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            startDate = null;
            endDate = null;
            notifyChange();
            onRefresh?.call();
          },
        ),
      );
    }

    if (minPrice > minPriceLimit || maxPrice < maxPriceLimit) {
      chips.add(
        Chip(
          backgroundColor: Colors.grey.shade300,
          label: Text('Prix: $minPrice F - $maxPrice F'),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            minPrice = minPriceLimit;
            maxPrice = maxPriceLimit;
            notifyChange();
            onRefresh?.call();
          },
        ),
      );
    }

    return chips;
  }
}
