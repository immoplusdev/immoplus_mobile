**PropFeed**

*▶︎ Vivre — TikTok rencontre l'Immobilier*

CURSOR IMPLEMENTATION PROMPT — Document de Référence

**À PROPOS DE CE DOCUMENT**

Ce document contient l'ensemble des prompts structurés pour implémenter PropFeed dans Cursor. Chaque étape est découpée en instructions précises, prêtes à copier-coller dans l'IA de Cursor. L'architecture est basée sur l'audit technique existant du projet Flutter / GetX.

Approche : coller chaque PROMPT dans Cursor → laisser l'IA générer → valider → passer à l'étape suivante.

---

# **Convention de chemins — Projet ImmoPlus**

Dans le projet **ImmoPlus**, ne pas créer `lib/domain/`, `lib/application/`, `lib/presentation/` à la racine de `lib/`. Tout PropFeed doit être regroupé sous **une seule feature** :

**Racine du module :** `lib/app/features/prop_feed/`

Règle à appliquer pour tous les chemins indiqués dans les prompts ci‑dessous :

| Dans ce document (prompts) | Dans le code ImmoPlus |
| :---- | :---- |
| `lib/domain/...` | `lib/app/features/prop_feed/domain/...` |
| `lib/application/...` | `lib/app/features/prop_feed/application/...` |
| `lib/presentation/...` | `lib/app/features/prop_feed/presentation/...` |
| `lib/views/...` | `lib/app/features/prop_feed/presentation/widgets/...` |

**Imports Dart :** préfixe `package:immoplus/app/features/prop_feed/...` (ex. `import 'package:immoplus/app/features/prop_feed/domain/entities/prop_listing.dart';`).

Dans chaque prompt ci‑dessous, quand un chemin du type **FICHIER : lib/...** est indiqué, le traduire en **lib/app/features/prop_feed/...** (ex. `lib/application/controllers/feed_controller.dart` → `lib/app/features/prop_feed/application/controllers/feed_controller.dart`).

Référence complète (arborescence, mapping détaillé, coexistence avec l’existant) : [PropFeed_Structure_Fichiers_Recommande.md](./PropFeed_Structure_Fichiers_Recommande.md).

---

# **ÉTAPE 1 — Fondations & Architecture**

## **Prompt 1.1 — Structure du Projet & Entités de Domaine**

| 🎯 Objectif Créer la structure de fichiers propre pour PropFeed et définir les entités de base (PropListing, AppUser, AppComment). L'architecture suit le pattern Clean Architecture avec séparation domain / application / presentation. **Dans ImmoPlus** : créer sous `lib/app/features/prop_feed/` (voir convention de chemins ci‑dessus). |
| :---- |

### **Prompt à coller dans Cursor :**

| Tu es un expert Flutter / Dart. Je construis PropFeed, une application de feed immobilier vidéo type TikTok. MISSION : Crée la structure de fichiers et les entités de domaine. **Convention ImmoPlus** : créer toute la structure sous lib/app/features/prop_feed/ (pas à la racine lib/). \#\# STRUCTURE À CRÉER lib/app/features/prop_feed/   domain/     entities/       prop\_listing.dart      \# Bien immobilier (remplace Video)       app\_user.dart          \# Utilisateur / Agent       app\_comment.dart       \# Commentaire     repositories/            \# Interfaces abstraites       feed\_repository.dart       social\_repository.dart       media\_storage\_service.dart       media\_processor\_service.dart   application/controllers/  \# GetX controllers   presentation/screens/     \# Écrans   presentation/widgets/     \# Widgets réutilisables \#\# ENTITÉ PropListing (prop\_listing.dart) Champs requis :   \- id: String   \- videoUrl: String   \- thumbnailUrl: String   \- price: double   \- currency: String (défaut 'EUR')   \- listingType: enum PropType { location, vente, saisonnier, meuble, luxe, coloc, neuf }   \- address: String   \- area: double (m²)   \- rooms: int   \- availableFrom: DateTime   \- agentId: String   \- agentHandle: String (ex: @AgenceLeMarais)   \- agentAvatarUrl: String   \- likes: List\<String\> (userId list)   \- savedBy: List\<String\> (coups de cœur)   \- commentCount: int   \- shareCount: int   \- isLive: bool (visite live en cours)   \- createdAt: DateTime CONTRAINTES :   \- Méthodes toMap() / fromMap() obligatoires   \- Utiliser const constructors si possible   \- Ajouter copyWith() pour les mutations immutables   \- Types stricts, pas de dynamic Génère les 3 entités \+ les 4 interfaces repository. |
| :---- |

# **ÉTAPE 2 — Controllers GetX**

## **Prompt 2.1 — FeedController (Feed Vidéo Principal)**

| 🎯 Objectif Créer le FeedController qui gère la liste réactive des biens, le filtre par catégorie, et les actions like / sauver / contacter. |
| :---- |

### **Prompt à coller dans Cursor :**

| Tu es un expert Flutter / GetX. Crée le FeedController pour PropFeed. \#\# FICHIER : lib/application/controllers/feed\_controller.dart FONCTIONNALITÉS REQUISES : 1\. ÉTAT RÉACTIF    \- RxList\<PropListing\> listings \= \<PropListing\>\[\].obs    \- Rx\<PropType?\> activeFilter \= Rx\<PropType?\>(null)    \- RxBool isLoading \= true.obs    \- RxString error \= ''.obs 2\. GETTER FILTRÉ    \- List\<PropListing\> get filteredListings \=\>      activeFilter.value \== null ? listings      : listings.where((l) \=\> l.listingType \== activeFilter.value).toList() 3\. MÉTHODES    \- onInit() : s'abonner au stream FeedRepository.watchFeed()    \- void setFilter(PropType? type)  // null \= tout    \- Future\<void\> toggleLike(String listingId)    \- Future\<void\> toggleSave(String listingId)    \- void openContactSheet(String listingId)  // Get.bottomSheet(...) 4\. GESTION ERREURS    \- try/catch avec Get.snackbar pour chaque action    \- onClose() : cancel subscription stream CONTRAINTES :    \- Injecter FeedRepository via Get.find\<FeedRepository\>()    \- Jamais de logique Firebase/backend dans ce controller    \- Optimistic update : modifier la liste locale AVANT la requête serveur |
| :---- |

## **Prompt 2.2 — UploadController (Publication de Biens)**

| 🎯 Objectif Créer le flux complet de publication d'un bien : pick vidéo → compression → thumbnail → upload → save. |
| :---- |

### **Prompt à coller dans Cursor :**

| Crée UploadController pour PropFeed. \#\# FICHIER : lib/application/controllers/upload\_controller.dart FLUX EN 5 ÉTAPES : ÉTAPE 1 — PICK VIDEO   \- Future\<void\> pickVideo({required bool useCamera})   \- Utilise MediaPickerService.pickVideoPath()   \- Stocker dans RxnString rawVideoPath ÉTAPE 2 — PRÉVISUALISATION (ConfirmScreen)   \- Exposer File get videoFile \=\> File(rawVideoPath.value\!)   \- Champs editables : Rx\<String\> price, Rx\<PropType\> listingType,     Rx\<String\> address, Rx\<int\> rooms, Rx\<double\> area ÉTAPE 3 — COMPRESSION   \- MediaProcessorService.compressMedium(rawVideoPath)   \- Afficher RxDouble compressionProgress (0.0 → 1.0) ÉTAPE 4 — THUMBNAIL   \- MediaProcessorService.generateThumbnail(rawVideoPath) ÉTAPE 5 — PUBLISH   \- Upload vidéo \+ thumbnail via MediaStorageService   \- Créer PropListing avec les métadonnées saisies   \- Appeler FeedRepository.createListing(listing)   \- Get.snackbar('✅ Publié \!', ...) en succès   \- Naviguer vers le feed CONTRAINTES :   \- RxBool isPublishing pour bloquer le bouton double-tap   \- Générer l'ID avec uuid (pas docs.length)   \- Libérer les ressources dans onClose() |
| :---- |

## **Prompt 2.3 — ProfileController & SearchController**

### **Prompt à coller dans Cursor :**

| Crée ProfileController et PropertySearchController pour PropFeed. \#\# ProfileController \#\# FICHIER : lib/application/controllers/profile\_controller.dart STATE :   \- Rx\<AppUser?\> user   \- RxList\<PropListing\> userListings (grille vidéo)   \- RxBool isFollowing   \- RxInt followersCount, followingCount, totalLikes MÉTHODES :   \- onInit() : charger profil \+ s'abonner aux stats via stream   \- toggleFollow() : optimistic update sur followersCount   \- BUG À ÉVITER : isFollowing doit être togglé dans TOUS les branches if/else \#\# PropertySearchController \#\# FICHIER : lib/application/controllers/search\_controller.dart STATE :   \- RxList\<PropListing\> results   \- RxString query   \- Rx\<PropType?\> filterType   \- RxDouble? maxPrice MÉTHODES :   \- void search(String query) : déclenche recherche   \- void applyFilters({PropType? type, double? maxPrice})   \- void clearFilters()   \- Debounce 500ms sur la saisie textuelle |
| :---- |

# **ÉTAPE 3 — Écrans & Navigation**

## **Prompt 3.1 — HomeScreen (Bottom Bar Redessinée)**

| 🎯 Objectif Transformer la bottom bar actuelle de 5 onglets en 2 onglets. Bouton central '▶︎ Vivre' flottant avec dégradé or/cuivre. Filtre retiré du centre et déplacé dans le header du feed. |
| :---- |

### **Prompt à coller dans Cursor :**

| Refactorise home\_screen.dart pour PropFeed. \#\# FICHIER : lib/presentation/screens/home/home\_screen.dart CHANGEMENTS REQUIS : 1\. BOTTOM BAR — 2 onglets uniquement    \[ ▶︎⌂ Vivre \]     \[ 👤 Profil \] 2\. BOUTON VIVRE (onglet 0\)    \- Légèrement surélevé : elevation ou transform Y(-8px)    \- Fond : LinearGradient(colors: \[Color(0xFFB8860B), Color(0xFFDAA520)\])    \- Icône custom : Stack(maison \+ triangle play)    \- Label : 'Vivre' avec Font size 12, bold    \- Animation pulse au tap : ScaleTransition 1.0 → 1.15 → 1.0 (200ms) 3\. PAGES MAPPING    pages \= \[PropFeedScreen(), ProfileScreen()\] 4\. SUPPRIMER    \- Onglet filtre central    \- Onglets Search, AddVideo, Messages (déplacés ailleurs) CONTRAINTES :    \- BottomNavigationBarType.fixed    \- selectedItemColor: Color(0xFFB8860B) (or/cuivre)    \- backgroundColor: Colors.black    \- Garder setState() pour l'index local |
| :---- |

## **Prompt 3.2 — PropFeedScreen (Écran Principal)**

| 🎯 Objectif Créer l'écran de feed vertical immersif avec header transparent, pills catégorie, overlay fiche bien (bas-gauche), et barre d'actions (droite). |
| :---- |

### **Prompt à coller dans Cursor :**

| Crée PropFeedScreen, l'écran principal de PropFeed. \#\# FICHIER : lib/presentation/screens/feed/prop\_feed\_screen.dart STRUCTURE GLOBALE :   Scaffold(     backgroundColor: Colors.black,     body: Stack(       children: \[         // 1\. PageView vidéo (plein écran)         // 2\. Header transparent (top)         // 3\. Pills catégorie (sous le header)         // 4\. Overlay fiche bien (bas-gauche)         // 5\. Barre d'actions (droite)         // 6\. Progress dots (bord droit, centre vertical)       \]     )   ) \#\# 1\. PAGEVIEW VIDÉO   Obx(() \=\> PageView.builder(     scrollDirection: Axis.vertical,     itemCount: controller.filteredListings.length,     onPageChanged: (i) \=\> controller.currentIndex.value \= i,     itemBuilder: (ctx, i) \=\> PropVideoPlayer(       listing: controller.filteredListings\[i\]     ),   )) \#\# 2\. HEADER TRANSPARENT   Position: top: 0, left: 0, right: 0   Container(     decoration: BoxDecoration(gradient: LinearGradient(       begin: Alignment.topCenter, end: Alignment.bottomCenter,       colors: \[Colors.black.withOpacity(0.7), Colors.transparent\]     )),     child: SafeArea(child: Row(       children: \[         // Gauche: pill filtre actif  ex: '📍 Paris · Location'         // Centre: logo vide (immersion)         // Droite: IconButton filtre ⚙️ \+ IconButton recherche 🔍       \]     ))   ) \#\# 3\. PILLS CATÉGORIE (swipe horizontal)   Position: top: 100 (sous le header)   ListView.builder horizontal, items: \['Tout','Location','Vente',     'Saisonnier','Coloc','Meublé','Neuf','Luxe'\]   Style actif: blanc plein (filled)   Style inactif: glassmorphism (BackdropFilter blur:8,     color: Colors.white.withOpacity(0.15)) \#\# 4\. OVERLAY FICHE BIEN (bas-gauche)   Position: bottom: 80, left: 16   Voir Prompt 3.3 \#\# 5\. BARRE D'ACTIONS (droite)   Position: bottom: 80, right: 16   Voir Prompt 3.4 \#\# 6\. PROGRESS DOTS   3-4 points verticaux, position: right: 4, center Y   Point actif \= blanc, inactif \= blanc 30% |
| :---- |

## **Prompt 3.3 — Widget Overlay Fiche Bien**

### **Prompt à coller dans Cursor :**

| Crée le widget ListingOverlay pour la fiche bien en bas-gauche du feed. \#\# FICHIER : lib/presentation/widgets/listing\_overlay.dart PROPS : PropListing listing STRUCTURE VISUELLE : Ligne 1 — Agent :   CircleAvatar(url: listing.agentAvatarUrl, radius: 18\)   Text('@${listing.agentHandle}', style: white bold 14\)   OutlinedButton('+ Suivre', borderColor: white, textColor: white, height: 28\) Ligne 2 — Catégorie bien :   Badge coloré par type :     location → bleu  \#2196F3     vente    → orange \#FF9800     saisonnier → violet \#9C27B0     meuble   → vert  \#4CAF50     luxe     → or   \#B8860B     coloc    → cyan  \#00BCD4   Text('Appartement Haussmannien · 3P · ${listing.area}m²') Ligne 3 — Localisation :   Icon(Icons.location\_on, size: 14, color: white70)   Text(listing.address, style: white70 13\) LIGNE 4 — PRIX (ANIMATION OBLIGATOIRE) :   AnimatedPriceWidget(     targetPrice: listing.price,     duration: Duration(milliseconds: 1200),     // Compte de 0 → targetPrice avec Tween\<double\>     // Format: '2 100 €/mois CC' pour location     //         '850 000 €' pour vente   )   Text('Disponible ${listing.availableFrom}') CTA PILL :   ElevatedButton('VOIR L\\'ANNONCE',     style: white bg, black text, borderRadius 20,     onPressed: () \=\> showModalBottomSheet(context, ListingDetailSheet(listing))   ) CONTRAINTES :   \- Fond : Container avec gradient noir 0→50%   \- Animation prix : TweenAnimationBuilder\<double\> déclenché onPageChange   \- Largeur max : MediaQuery.sizeOf(context).width \* 0.72 |
| :---- |

## **Prompt 3.4 — Widget Barre d'Actions (Droite)**

### **Prompt à coller dans Cursor :**

| Crée ActionsColumn, la barre d'actions verticale droite du feed PropFeed. \#\# FICHIER : lib/presentation/widgets/actions\_column.dart PROPS : PropListing listing, FeedController controller STRUCTURE — Column de haut en bas : 1\. ❤️ LIKE    \- GestureDetector onTap: controller.toggleLike(listing.id)    \- Icon cœur : rouge si liked, blanc si non    \- Counter sous l'icône : listing.likes.length    \- Animation : bounceScale 0.8 → 1.2 → 1.0 au tap (150ms) 2\. 🔖 SAUVER    \- onTap: controller.toggleSave(listing.id)    \- Icon bookmark : rempli si sauvegardé, outline sinon    \- Counter : listing.savedBy.length 3\. 📤 PARTAGER    \- onTap: Share.share('${listing.address} \- ${listing.price}€')    \- Icon: Icons.share 4\. 📞 CONTACTER / RÉSERVER    \- onTap: controller.openContactSheet(listing.id)    \- Icon: Icons.phone\_outlined    \- Label: 'Visiter'    \- Couleur : or/cuivre \#B8860B (action prioritaire) 5\. ⋯ PLUS    \- onTap: showModalBottomSheet avec options      \['Signaler', 'Partager', 'Copier le lien'\] BADGE LIVE (optionnel) :   if (listing.isLive)     Positioned(top: \-4, right: \-4,       child: AnimatedOpacity alternant 1.0/0.4 (500ms) :         Container('🔴 LIVE', color: red, borderRadius: 4)) CONTRAINTES :   \- Espacement entre items : SizedBox(height: 20\)   \- Icônes : taille 32, ombres légères   \- Texte counters : blanc 12px |
| :---- |

# **ÉTAPE 4 — Player Vidéo & Animations**

## **Prompt 4.1 — PropVideoPlayer Widget**

| ⚠️ Garde-fous qualité OBLIGATION : dispose() sur VideoPlayerController et AnimationController. Sans dispose(), les fuite mémoire causeront des crashs sur le feed scroll. |
| :---- |

### **Prompt à coller dans Cursor :**

| Crée PropVideoPlayer, le widget vidéo plein écran pour PropFeed. \#\# FICHIER : lib/presentation/widgets/prop\_video\_player.dart PROPS : PropListing listing LIFECYCLE :   \- initState() : initialiser VideoPlayerController.networkUrl(Uri.parse(listing.videoUrl))   \- Après initialize() : play() \+ setLooping(true) \+ setVolume(1.0)   \- dispose() : OBLIGATOIRE — \_controller.dispose() INTERACTIONS :   \- Tap simple : toggle pause/play   \- Double tap : controller.toggleSave(listing.id) \+ animation cœur     HeartAnimation : FadeTransition \+ ScaleTransition (0→1.5→0, 800ms)   \- Swipe gauche : Navigator.push vers ListingDetailScreen(listing) OVERLAY GRADIENT BAS :   Positioned(bottom: 0, left: 0, right: 0,     Container(height: 300,       decoration: BoxDecoration(         gradient: LinearGradient(           begin: Alignment.bottomCenter,           end: Alignment.topCenter,           colors: \[Colors.black.withOpacity(0.6), Colors.transparent\])))) CONTRAINTES :   \- VideoPlayer remplit 100% écran : SizedBox.expand \+ FittedBox   \- Gérer le cas d'erreur réseau : Center(Icon(Icons.error))   \- Afficher CircularProgressIndicator pendant buffering   \- N'utiliser JAMAIS setState pour l'état vidéo → utiliser ValueListenableBuilder |
| :---- |

## **Prompt 4.2 — Animations Différenciantes**

### **Prompt à coller dans Cursor :**

| Crée les widgets d'animation différenciants de PropFeed. \#\# 1\. AnimatedPriceWidget \#\# FICHIER : lib/presentation/widgets/animated\_price.dart TweenAnimationBuilder\<double\>(   tween: Tween(begin: 0, end: listing.price),   duration: Duration(milliseconds: 1200),   curve: Curves.easeOut,   builder: (ctx, value, \_) {     final formatted \= NumberFormat('\#,\#\#\#', 'fr\_FR').format(value.round());     final suffix \= listing.listingType \== PropType.location       ? '€/mois CC' : '€';     return Text('$formatted $suffix',       style: TextStyle(color: white, fontSize: 28, fontWeight: bold));   } ) \#\# 2\. HeartAnimation (double tap) \#\# FICHIER : lib/presentation/widgets/heart\_animation.dart StatefulWidget avec AnimationController duration: 800ms Combiner :   \- ScaleAnimation : 0.0 → 1.5 → 0.0   \- FadeAnimation : 0.0 → 1.0 → 0.0   \- Position : centre écran   \- Icon : Icons.favorite, color: red, size: 100   \- dispose() : OBLIGATOIRE \#\# 3\. GlassmorphismPill (pills catégorie) \#\# FICHIER : lib/presentation/widgets/glassmorphism\_pill.dart ClipRRect(borderRadius: 20,   BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),     Container(       decoration: BoxDecoration(         color: isActive ? white : white.withOpacity(0.15),         border: Border.all(color: white.withOpacity(0.3)),         borderRadius: 20),       child: Text(label, style: isActive ? black bold : white)))) |
| :---- |

# **ÉTAPE 5 — Features Sociales & Profil**

## **Prompt 5.1 — Profil Utilisateur avec Coups de Cœur**

### **Prompt à coller dans Cursor :**

| Crée ProfileScreen pour PropFeed avec grille de biens. \#\# FICHIER : lib/presentation/screens/profile/profile\_screen.dart SECTIONS : 1\. HEADER PROFIL    \- Avatar \+ nom \+ @handle    \- Row métriques : \[X Biens\] \[X Followers\] \[X Suivis\] \[X ❤️ Total\]    \- Bouton Suivre/Ne plus suivre (état via controller.isFollowing) 2\. TABS — 2 onglets :    Tab 1 : 'Mes Annonces' → grille vidéos uploadées    Tab 2 : '🔖 Coups de cœur' → grille biens sauvegardés 3\. GRILLE VIDÉOS (GridView.builder)    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(      crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2\)    Chaque item : Stack(      Image.network(v.thumbnailUrl, fit: BoxFit.cover),      Positioned(bottom: 0, left: 0, right: 0,        Container(color: black54,          Text('❤ ${v.likes.length}  💬 ${v.commentCount}')))) 4\. LOADING / EMPTY STATE    \- CircularProgressIndicator pendant chargement    \- Placeholder 'Aucun bien publié' si liste vide BUG À CORRIGER (audit existant) :    Dans ProfileController.followUser() :    isFollowing DOIT être toggleé dans les 2 branches (if ET else) |
| :---- |

## **Prompt 5.2 — Sheet de Contact & Recherche de Biens**

### **Prompt à coller dans Cursor :**

| Crée ContactSheet et PropertySearchScreen pour PropFeed. \#\# 1\. ContactSheet \#\# FICHIER : lib/presentation/widgets/contact\_sheet.dart showModalBottomSheet DraggableScrollable CONTENU :   \- Header : avatar \+ nom agent \+ badge vérifié ✓   \- Fiche bien résumée (photo thumb \+ adresse \+ prix)   \- 3 actions :     \[📞 Appeler\]  \[💬 Message\]  \[📅 Visiter\]   \- Champ message rapide : TextFormField     placeholder: 'Bonjour, je suis intéressé par ce bien...'   \- Bouton Envoyer \#\# 2\. PropertySearchScreen \#\# FICHIER : lib/presentation/screens/search/search\_screen.dart STRUCTURE :   \- AppBar avec TextFormField (onChanged → controller.search)   \- Row filtres rapides : type \+ maxPrice slider   \- ListView.builder résultats (cards biens)   \- Card bien : thumb \+ titre \+ prix \+ adresse \+ badge type   \- Tap → PropDetailScreen(listing) CONTRAINTES :   \- Debounce 500ms sur saisie   \- Empty state : 'Aucun résultat pour cette recherche'   \- Loading skeleton pendant la recherche |
| :---- |

# **ÉTAPE 6 — Qualité & Corrections de Bugs**

## **Prompt 6.1 — Corrections des Bugs Identifiés en Audit**

| 🐛 Bugs Critiques à Corriger Bug 1 — MyVideoPlayer : dispose() manquant → fuite mémoire Bug 2 — AnimationCircle : AnimationController non disposé Bug 3 — ProfileController.followUser() : isFollowing non toggleé dans le if Bug 4 — User model : name mappé sur 'email' au lieu de 'name' Bug 5 — CommentController : cast dynamic au lieu de Map\<String,dynamic\> |
| :---- |

### **Prompt à coller dans Cursor :**

| Corrige les bugs critiques identifiés dans l'audit du projet. \#\# BUG 1 — PropVideoPlayer dispose() Dans lib/presentation/widgets/prop\_video\_player.dart :   @override   void dispose() {     \_videoController.dispose();  // OBLIGATOIRE     \_animationController.dispose();  // OBLIGATOIRE     super.dispose();   } \#\# BUG 2 — AnimationCircle dispose() Dans lib/views/widgets/animation\_circle.dart :   Ajouter dispose() avec \_animationController.dispose() \#\# BUG 3 — ProfileController.followUser() AVANT (buggé) :   if (isFollowing.value) {     // unfollow logic     // isFollowing pas toggleé ici ← BUG   } else {     isFollowing.value \= true;   } APRÈS (corrigé) :   if (isFollowing.value) {     await socialRepo.toggleFollow(...);     isFollowing.value \= false;  // ← AJOUTÉ     followersCount.value--;   } else {     await socialRepo.toggleFollow(...);     isFollowing.value \= true;     followersCount.value++;   } \#\# BUG 4 — AppUser model mapping AVANT : name: snapshot\['email'\]  ← BUG APRÈS : name: snapshot\['name'\] as String \#\# BUG 5 — CommentController cast AVANT : (userDoc as dynamic)\['name'\]  ← BUG APRÈS : (userDoc.data() as Map\<String,dynamic\>)\['name'\] |
| :---- |

## **Prompt 6.2 — Checklist Finale & Garde-Fous**

### **Prompt à coller dans Cursor :**

| Vérifie la qualité globale de l'implémentation PropFeed. \#\# CHECKLIST À VALIDER MÉMOIRE & LIFECYCLE   ✓ Tous les VideoPlayerController ont dispose()   ✓ Tous les AnimationController ont dispose()   ✓ Tous les StreamSubscription sont cancel() dans onClose() ARCHITECTURE   ✓ Zéro logique backend dans les widgets UI   ✓ Zéro logique backend dans les controllers     (uniquement via interfaces Repository)   ✓ Tous les modèles ont toMap() / fromMap() / copyWith()   ✓ Types stricts partout (pas de dynamic ni de cast non sécurisé) IDs & DONNÉES   ✓ IDs générés avec uuid (pas docs.length ni timestamp seul)   ✓ Pagination prévue sur FeedController (lazy load pageSize: 10\)   ✓ Pagination prévue sur la grille profil UX STATES   ✓ Loading state sur chaque écran   ✓ Error state avec message clair   ✓ Empty state avec illustration   ✓ Get.snackbar pour actions utilisateur (like, save, follow, upload) PROPFEED SPÉCIFIQUE   ✓ Animation prix reveal au démarrage vidéo   ✓ Double-tap \= sauvegarde \+ animation cœur   ✓ Swipe gauche \= fiche détail   ✓ Pills catégorie glassmorphism opérationnels   ✓ Bouton Vivre flottant avec dégradé or   ✓ Badge LIVE fonctionnel (isLive flag) SIGNALE tout ce qui n'est pas conforme et propose un fix. |
| :---- |

# **TABLEAU DE MAPPING — Existant → PropFeed**

| COMPOSANT ACTUEL | ÉVOLUTION PROPFEED |
| :---- | :---- |
| home\_screen.dart (5 onglets) | 2 onglets: ▶︎ Vivre \+ 👤 Profil |
| video\_screen.dart (feed) | PropFeedScreen \+ header \+ pills |
| Modèle Video | PropListing (price, type, address...) |
| Like \+ Comment | Like \+ Sauver \+ Contacter \+ Share |
| CommentScreen | Sheet Contact (mini-chat/appel) |
| Recherche users | PropertySearchController |
| Profil actuel | Profil \+ onglet Coups de cœur |

# **ORDRE D'EXÉCUTION RECOMMANDÉ**

1. Prompt 1.1 — Entités & Structure (fondations)

2. Prompt 2.1 — FeedController

3. Prompt 2.2 — UploadController

4. Prompt 2.3 — ProfileController \+ SearchController

5. Prompt 3.1 — HomeScreen (bottom bar)

6. Prompt 3.2 — PropFeedScreen (layout principal)

7. Prompt 3.3 — ListingOverlay widget

8. Prompt 3.4 — ActionsColumn widget

9. Prompt 4.1 — PropVideoPlayer

10. Prompt 4.2 — Animations (prix, cœur, glassmorphism)

11. Prompt 5.1 — ProfileScreen avec grille

12. Prompt 5.2 — ContactSheet \+ SearchScreen

13. Prompt 6.1 — Corrections bugs

14. Prompt 6.2 — Checklist qualité finale

---

# **Tester le feed avec des vidéos réelles**

Pour tester le feed sans backend, l’app utilise un **mode démo** avec des vidéos réelles (URLs publiques) :

- **Implémentation** : `lib/app/features/prop_feed/data/sample_feed_repository.dart`
- **URLs utilisées** : constante `kPropFeedSampleVideoUrls` (samples Google : Big Buck Bunny, Sintel, etc.)
- **Activation** : en ouvrant l’onglet **Vivre** (bottom bar), les bindings enregistrent `SampleFeedRepository` et `SampleSocialRepository` ; le feed affiche alors 6 biens avec ces vidéos.

Pour utiliser **vos propres vidéos** en test :

1. Modifier `kPropFeedSampleVideoUrls` dans `sample_feed_repository.dart` avec vos URLs (MP4 accessibles en HTTPS), ou
2. Étendre `_createSampleListings()` pour ajouter des `PropListing` avec vos `videoUrl` / `thumbnailUrl`.

En production, remplacer l’enregistrement dans `prop_feed_binding.dart` par vos implémentations réelles de `FeedRepository` et `SocialRepository` (Firebase, API, etc.).

---

*PropFeed — Document généré pour Cursor AI  •  ▶︎ Vivre*