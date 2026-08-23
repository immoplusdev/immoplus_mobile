enum AdCampaignCategory {
  villeAds('VILLE_ADS'),
  offreSpecial('OFFRE SPECIAL'),
  promotion('PROMOTION'),
  newFeature('NEW_FEATURE'),
  newProgram('NEW_PROGRAM'),
  policyUpdate('POLICY_UPDATE'),
  general('GENERAL'),
  other('OTHER');

  final String value;
  const AdCampaignCategory(this.value);

  static AdCampaignCategory fromString(String? value) {
    if (value == null) return AdCampaignCategory.other;
    final normalized = value.trim().toUpperCase();
    return AdCampaignCategory.values.firstWhere(
      (e) => e.value.trim().toUpperCase() == normalized,
      orElse: () => AdCampaignCategory.other,
    );
  }
}
