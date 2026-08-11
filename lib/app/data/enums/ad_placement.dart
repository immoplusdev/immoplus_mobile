enum AdPlacement {
  homeTop("HOME_TOP"),
  homeAfterSearch("HOME_AFTER_SEARCH"),
  homeAfterSection("HOME_AFTER_SECTION"),
  homeBottom("HOME_BOTTOM"),
  propertyListTop("PROPERTY_LIST_TOP"),
  propertyListAfter("PROPERTY_LIST_AFTER"),
  propertyDetailsHeader("PROPERTY_DETAILS_HEADER"),
  propertyDetailsGallery("PROPERTY_DETAILS_GALLERY"),
  propertyDetailsDescription("PROPERTY_DETAILS_DESCRIPTION"),
  propertyDetailsBottom("PROPERTY_DETAILS_BOTTOM"),
  hotelListTop("HOTEL_LIST_TOP"),
  hotelDetailsHeader("HOTEL_DETAILS_HEADER"),
  residenceList("RESIDENCE_LIST"),
  residenceDetails("RESIDENCE_DETAILS"),
  locationList("LOCATION_LIST"),
  paymentTop("PAYMENT_TOP"),
  paymentBottom("PAYMENT_BOTTOM"),
  mapTop("MAP_TOP"),
  mapBottom("MAP_BOTTOM"),
  calendarTop("CALENDAR_TOP"),
  calendarBottom("CALENDAR_BOTTOM"),
  accountTop("ACCOUNT_TOP"),
  accountBottom("ACCOUNT_BOTTOM"),
  imatchTop("IMATCH_TOP"),
  imatchBottom("IMATCH_BOTTOM");

  final String value;
  const AdPlacement(this.value);

  static AdPlacement? fromString(String? value) {
    if (value == null) return null;
    return AdPlacement.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdPlacement.homeTop,
    );
  }
}
