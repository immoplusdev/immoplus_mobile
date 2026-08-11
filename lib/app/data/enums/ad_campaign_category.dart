enum AdCampaignCategory {
  promotion("PROMOTION"),
  newFeature("NEW_FEATURE"),
  newProgram("NEW_PROGRAM"),
  policyUpdate("POLICY_UPDATE"),
  general("GENERAL");

  final String value;
  const AdCampaignCategory(this.value);

  static AdCampaignCategory? fromString(String? value) {
    if (value == null) return null;
    return AdCampaignCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdCampaignCategory.general,
    );
  }
}
