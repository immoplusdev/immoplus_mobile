class HomeLocationItem {
  final String title;
  final String? villeId;
  final String? communeId;
  final bool isHeader;

  const HomeLocationItem({
    required this.title,
    this.villeId,
    this.communeId,
    this.isHeader = false,
  });
}

/// Liste des villes/communes utilisée pour générer les sections horizontales
/// "par localité" sur la home (résidences, biens, ...).
const List<HomeLocationItem> kHomeLocationItems = [
  // --- Section 1 : Villes populaires ---
  HomeLocationItem(title: "VILLES POPULAIRES", isHeader: true),
  HomeLocationItem(
      title: "Abidjan", villeId: "8b97b9ce-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Aboisso", villeId: "8b981afc-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Anyama", villeId: "8b9806f9-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Grand-Bassam", villeId: "8b981ba8-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Yamoussoukro", villeId: "8b97d0b3-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "San-Pédro", villeId: "8b97ea35-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 2 : Communes d'Abidjan ---
  HomeLocationItem(
      title: "Abobo", communeId: "8bb4b211-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Adjamé", communeId: "55a42f68-2867-11f1-a056-661ac3bf2f34"),
  HomeLocationItem(
      title: "Attécoubé", communeId: "8bb4d4d0-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Cocody", communeId: "8bb446ea-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Koumassi", communeId: "8bb4b588-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Marcory", communeId: "8bb498f3-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Plateau (Le Plateau)",
      communeId: "8bb48973-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Port-Bouët", communeId: "8bb4c15a-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Treichville", communeId: "8bb4a496-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Yopougon", communeId: "8bb47716-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Anyama (Commune)",
      communeId: "567aa860-2867-11f1-a056-661ac3bf2f34"),
  HomeLocationItem(
      title: "Bingerville", communeId: "8bb68343-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Bonoua", communeId: "8bb80dca-a507-11ef-8b44-0e595bc2ce41"),

  // --- Section 3 : Villes extérieures ---
  HomeLocationItem(
      title: "Abengourou", villeId: "8b980686-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Adzopé", villeId: "8b981bef-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Agboville", villeId: "8b981b46-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Bondoukou", villeId: "8b980e6a-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Bouaké", villeId: "8b97dccc-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Daloa", villeId: "8b97e49c-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Divo", villeId: "8b97f856-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Ferkessédougou", villeId: "8b980eb7-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Gagnoa", villeId: "8b97f23e-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Issia", villeId: "8b981c4e-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Korhogo", villeId: "8b97ea95-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Man", villeId: "8b97f0aa-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Odienné", villeId: "8b9814b6-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Séguéla", villeId: "8b981507-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Soubré", villeId: "8b980dd8-a507-11ef-8b44-0e595bc2ce41"),
  HomeLocationItem(
      title: "Toumodi", villeId: "8b981aa6-a507-11ef-8b44-0e595bc2ce41"),
];
