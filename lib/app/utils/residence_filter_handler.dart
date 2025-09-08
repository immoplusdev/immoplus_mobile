import 'package:immoplus/app/constants/constantes.dart';

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
}
