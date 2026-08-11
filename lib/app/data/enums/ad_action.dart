enum AdAction {
  openUrl("OPEN_URL"),
  openProperty("OPEN_PROPERTY"),
  openResidence("OPEN_RESIDENCE"),
  openHotel("OPEN_HOTEL"),
  openLocation("OPEN_LOCATION"),
  openCategory("OPEN_CATEGORY"),
  openProfile("OPEN_PROFILE"),
  openImatch("OPEN_IMATCH"),
  openEvent("OPEN_EVENT"),
  openExternal("OPEN_EXTERNAL"),
  openInternalPage("OPEN_INTERNAL_PAGE"),
  openPayment("OPEN_PAYMENT"),
  none("NONE");

  final String value;
  const AdAction(this.value);

  static AdAction? fromString(String? value) {
    if (value == null) return null;
    return AdAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdAction.none,
    );
  }
}
