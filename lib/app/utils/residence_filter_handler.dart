class FilterHandler {
  static String? search;
  static String? startDate;
  static String? endDate;
  static double? lat;
  static double? long;
  static int minPrice = 10000;
  static int maxPrice = 3000000;
  static String? locationName;

  static cleanParameters() {
    search = null;
    lat = null;
    long = null;
    minPrice = 10000;
    maxPrice = 3000000;
  }
}
