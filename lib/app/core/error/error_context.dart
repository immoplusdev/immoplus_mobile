/// Contexte métier d'une erreur : permet de produire des textes orientés
/// action ("Impossible d'envoyer votre réservation") plutôt qu'un message
/// générique.
enum ErrorContext {
  generic(
    title: 'Une erreur est survenue',
    action: 'terminer cette opération',
  ),
  bookingSubmission(
    title: "Réservation non envoyée",
    action: "envoyer votre demande de réservation",
  ),
  bookingLoad(
    title: 'Réservation indisponible',
    action: 'charger votre réservation',
    blocksContent: true,
  ),
  priceEstimation(
    title: 'Estimation indisponible',
    action: 'calculer le prix de votre séjour',
  ),
  paymentInitiation(
    title: 'Paiement non effectué',
    action: 'lancer votre paiement',
  ),
  residenceLoad(
    title: 'Logement indisponible',
    action: 'charger ce logement',
  ),
  listingLoad(
    title: 'Annonce indisponible',
    action: 'charger cette annonce',
  ),
  feedLoad(
    title: 'Chargement impossible',
    action: 'charger ce contenu',
  ),
  bookingCancellation(
    title: 'Annulation impossible',
    action: 'annuler cette réservation',
  ),
  fileUpload(
    title: "Envoi du fichier impossible",
    action: 'envoyer votre fichier',
  ),
  appStartup(
    title: 'Démarrage impossible',
    action: "charger l'application",
  ),
  visitRequest(
    title: 'Demande de visite impossible',
    action: 'traiter votre demande de visite',
  ),
  messaging(
    title: 'Messagerie indisponible',
    action: 'accéder à vos messages',
  ),
  hotelBooking(
    title: "Réservation d'hôtel impossible",
    action: "traiter votre réservation d'hôtel",
  ),
  relais(
    title: 'Demande Immo Relais impossible',
    action: 'traiter votre demande Immo Relais',
  ),
  alert(
    title: 'Alerte impossible',
    action: 'traiter votre alerte',
  ),
  reverseSearch(
    title: 'Recherche inversée impossible',
    action: 'traiter votre recherche',
  ),
  rating(
    title: 'Avis non envoyé',
    action: 'envoyer votre avis',
  ),
  passwordReset(
    title: 'Réinitialisation impossible',
    action: 'réinitialiser votre mot de passe',
  ),
  accountDeletion(
    title: 'Suppression impossible',
    action: 'supprimer votre compte',
  ),
  userPreferences(
    title: 'Préférences non enregistrées',
    action: 'enregistrer vos préférences',
  ),
  proUpgrade(
    title: 'Demande non envoyée',
    action: 'envoyer votre demande de compte professionnel',
  ),
  authentication(
    title: 'Connexion impossible',
    action: 'vous connecter',
  ),
  profileUpdate(
    title: 'Modification non enregistrée',
    action: 'enregistrer vos modifications',
  );

  const ErrorContext({
    required this.title,
    required this.action,
    this.blocksContent = false,
  });

  /// Titre du dialogue.
  final String title;

  /// Action en cours, à la forme infinitive ("impossible de …").
  final String action;

  /// L'erreur bloque le contenu principal de la page : l'écran doit afficher
  /// son propre état d'erreur avec « Réessayer » (un toast ne suffit pas).
  final bool blocksContent;
}
