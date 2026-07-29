enum MarketingNotificationCode {
  // Onboarding
  cliOnb02('CLI-ONB-02'),
  cliOnb03('CLI-ONB-03'),
  cliOnb04('CLI-ONB-04'),
  cliOnb05('CLI-ONB-05'),
  cliOnb06('CLI-ONB-06'),
  cliOnb07('CLI-ONB-07'),

  // Réengagement inactif
  cliReeng07('CLI-REENG-07'),
  cliReeng14('CLI-REENG-14'),
  cliReeng30('CLI-REENG-30'),
  cliReeng60('CLI-REENG-60'),

  // Nurturing comportemental
  cliNurt01('CLI-NURT-01'),
  cliNurt02('CLI-NURT-02'),
  cliNurtPc01('CLI-NURT-PC-01'),
  cliNurtPc03('CLI-NURT-PC-03'),

  // Nurturing alerte
  cliNurtAl01('CLI-NURT-AL-01'),
  cliNurtAl02('CLI-NURT-AL-02'),
  cliNurtAl03('CLI-NURT-AL-03'),
  cliNurtAl04('CLI-NURT-AL-04'),

  // Post-réservation
  cliResa02('CLI-RESA-02'),
  cliResa03('CLI-RESA-03'),
  cliResa04('CLI-RESA-04'),
  cliResa05('CLI-RESA-05'),
  cliResa06('CLI-RESA-06'),

  // Saisonnalité
  cliSeason01('CLI-SEASON-01'),
  cliSeason02('CLI-SEASON-02'),
  cliSeason03('CLI-SEASON-03'),
  cliSeason04('CLI-SEASON-04'),

  // Social proof
  cliSocial01('CLI-SOCIAL-01'),
  cliSocial03('CLI-SOCIAL-03'),
  cliSocial04('CLI-SOCIAL-04');

  final String code;

  const MarketingNotificationCode(this.code);

  static MarketingNotificationCode? fromString(String? code) {
    if (code == null) return null;
    return MarketingNotificationCode.values.where((e) => e.code == code).firstOrNull;
  }
}
