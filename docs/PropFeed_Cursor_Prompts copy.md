# ▶︎ PropFeed — TikTok rencontre l'Immobilier
### CURSOR IMPLEMENTATION GUIDE
**Flutter / GetX · Clean Architecture · Material You · 2026**

---

## À propos de ce document

Ce guide contient l'ensemble des prompts structurés pour implémenter PropFeed dans Cursor. Chaque étape est découpée en instructions précises, prêtes à copier-coller. L'architecture suit le pattern Clean Architecture Flutter / GetX.

> **Approche :** Coller chaque PROMPT dans Cursor → laisser l'IA générer → valider visuellement → passer à l'étape suivante. Ne pas sauter d'étape : les entités du Prompt 1.1 sont requises par tous les autres.

---

## Convention de chemins — Projet ImmoPlus

Tout PropFeed est regroupé sous une seule feature. Ne jamais créer `lib/domain/`, `lib/application/`, `lib/presentation/` à la racine de `lib/`.

**Racine du module :** `lib/app/features/prop_feed/`

| Dans les prompts | Dans le code ImmoPlus |
|---|---|
| `lib/domain/...` | `lib/app/features/prop_feed/domain/...` |
| `lib/application/...` | `lib/app/features/prop_feed/application/...` |
| `lib/presentation/...` | `lib/app/features/prop_feed/presentation/...` |
| `lib/views/...` | `lib/app/features/prop_feed/presentation/widgets/...` |

**Imports Dart :** préfixe `package:immoplus/app/features/prop_feed/...`

---

## Intégration dans la Bottom Bar existante

PropFeed s'intègre dans l'application **sans toucher à la structure de navigation existante**. Une seule règle :

> L'onglet **"Vivre"** de la bottom bar actuelle pointe directement sur `PropFeedScreen()`. C'est le seul point d'entrée. Aucune modification de la bottom bar n'est nécessaire.

```dart
// Dans le fichier de navigation existant, remplacer le placeholder
// de l'onglet "Vivre" par :
pages[indexVivre] = const PropFeedScreen();
```

Tout le reste de la bottom bar (autres onglets, structure, styles) reste **inchangé**.

---

## Design System — UI Moderne & Sans Friction

PropFeed cible une qualité visuelle niveau Airbnb / TikTok 2026. Chaque composant respecte ce système de design pour garantir une expérience immersive, fluide, sans friction.

### Couleurs — Palette ImmoPlus

| Token | Valeur | Usage |
|---|---|---|
| `primary` | `#2744DE` | Boutons CTA, liens, icônes actives, indicateurs |
| `primaryLight` | `#2744DE` à 15% opacity | Indicateur NavigationBar, backgrounds subtils |
| `primaryDark` | `#1A33B8` | États pressed sur le primary |
| `background` | `#FFFFFF` | Fond principal de tous les écrans |
| `surface` | `#F2F4FC` | Cards, champs input, surfaces légèrement teintées |
| `surface2` | `#E8EBF8` | Borders, séparateurs, état hover |
| `textPrimary` | `#0A0A0A` | Titres, corps principal |
| `textSecondary` | `#6B7280` | Labels secondaires, placeholders |
| `textTertiary` | `#9CA3AF` | Métadonnées, timestamps |
| `feedBackground` | `#000000` | Fond du feed vidéo uniquement (plein écran) |
| `feedSurface` | `#1C1C1E` | Cards et sheets sur fond sombre (feed) |
| `accentGreen` | `#22C55E` | Disponibilité, succès |
| `accentRed` | `#EF4444` | Like actif, alertes |
| `accentOrange` | `#F97316` | Badges vente |
| `accentPurple` | `#8B5CF6` | Badges saisonnier |
| `border` | `#E5E7EB` | Borders cards et inputs |

> **Règle d'or :** dans les écrans classiques (liste, profil, recherche) → fond blanc + primary bleu. Dans le feed vidéo plein écran → fond noir + overlays transparents.

### Tokens Typographie — Inter

| Usage | Taille | Poids | Couleur |
|---|---|---|---|
| Titre écran | 22px | Bold 700 | `#0A0A0A` |
| Prix animé (feed) | 28px | Bold 700 | `#FFFFFF` |
| Titre bien (feed) | 17px | SemiBold 600 | `#FFFFFF` |
| Corps / description | 14px | Regular 400 | `#6B7280` |
| Labels pills | 13px | Medium 500 | White ou Black |
| Counters actions | 12px | Regular 400 | `#FFFFFF` |
| Agent handle | 14px | Bold 700 | contextuel |
| Badge type bien | 11px | SemiBold 600 | `#FFFFFF` allCaps |
| Bouton CTA | 16px | SemiBold 600 | `#FFFFFF` |

### Espacement & Radius

Grille de base **8px**. Toutes les marges et paddings sont multiples de 4 ou 8.

| Élément | Radius |
|---|---|
| Cards, images | `12px` |
| Boutons CTA | `14px` |
| Bottom sheets | `24px` (top only) |
| Pills / badges | `999px` |
| Avatars | circulaire |
| Inputs | `12px` |
| Thumbnails grille | `8px` |o

### ThemeData Material 3 — À configurer dans `main.dart`

```dart
ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2744DE),
    onPrimary: Colors.white,
    surface: Color(0xFFF2F4FC),
    background: Colors.white,
    onBackground: Color(0xFF0A0A0A),
    outline: Color(0xFFE5E7EB),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Color(0xFFE5E7EB)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2744DE),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      minimumSize: Size(double.infinity, 52),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF2F4FC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF2744DE), width: 2),
    ),
    hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorColor: Color(0xFF2744DE),
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Color(0xFF2744DE),
    unselectedLabelColor: Color(0xFF6B7280),
    labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  ),
)
```

### Animations — Durées & Courbes Référence

| Animation | Durée | Courbe |
|---|---|---|
| Micro-interaction tap | 150ms | `Curves.easeOut` |
| Transition page | 280ms | `Curves.easeInOutCubic` |
| Bottom sheet open | 350ms | `Curves.easeOutQuart` |
| Prix reveal (AnimatedPrice) | 1200ms | `Curves.easeOut` |
| Cœur double-tap | 800ms | `Curves.elasticOut` |
| Fade in overlay | 200ms | `Curves.easeIn` |
| Skeleton shimmer | 1500ms | `Curves.linear` (loop) |
| Glassmorphism appear | 250ms | `Curves.easeOut` |
| Pills catégorie switch | 200ms | `Curves.easeOut` |
| Follow button toggle | 250ms | `Curves.easeInOut` |

---

## ÉTAPE 1 — Fondations & Architecture

### Prompt 1.1 — Structure du Projet & Entités de Domaine

> **Objectif :** Créer la structure de fichiers et les entités de base (PropListing, AppUser, AppComment). Clean Architecture avec séparation domain / application / presentation.

```
Tu es un expert Flutter / Dart. Je construis PropFeed,
une application de feed immobilier vidéo type TikTok.

MISSION : Crée la structure de fichiers et les entités de domaine.

Convention ImmoPlus : créer toute la structure sous
lib/app/features/prop_feed/ (pas à la racine lib/).

## STRUCTURE À CRÉER

lib/app/features/prop_feed/
  domain/
    entities/
      prop_listing.dart       # Bien immobilier (remplace Video)
      app_user.dart           # Utilisateur / Agent
      app_comment.dart        # Commentaire
    repositories/             # Interfaces abstraites
      feed_repository.dart
      social_repository.dart
      media_storage_service.dart
      media_processor_service.dart
  application/controllers/    # GetX controllers
  presentation/screens/       # Écrans
  presentation/widgets/       # Widgets réutilisables

## ENTITÉ PropListing (prop_listing.dart)

Champs requis :
  - id: String
  - videoUrl: String
  - thumbnailUrl: String
  - price: double
  - currency: String (défaut 'EUR')
  - listingType: enum PropType { location, vente, saisonnier,
                                  meuble, luxe, coloc, neuf }
  - address: String
  - area: double (m²)
  - rooms: int
  - availableFrom: DateTime
  - agentId: String
  - agentHandle: String (ex: @AgenceLeMarais)
  - agentAvatarUrl: String
  - likes: List<String> (userId list)
  - savedBy: List<String> (coups de cœur)
  - commentCount: int
  - shareCount: int
  - isLive: bool (visite live en cours)
  - createdAt: DateTime

## ENTITÉ AppUser (app_user.dart)

Champs requis :
  - id: String
  - name: String          # ← JAMAIS mapper sur 'email'
  - handle: String
  - avatarUrl: String
  - bio: String
  - isAgent: bool
  - isVerified: bool
  - followersCount: int
  - followingCount: int
  - totalLikes: int
  - createdAt: DateTime

## ENTITÉ AppComment (app_comment.dart)

Champs requis :
  - id: String
  - listingId: String
  - userId: String
  - userHandle: String
  - userAvatarUrl: String
  - text: String
  - likes: List<String>
  - createdAt: DateTime

CONTRAINTES :
  - toMap() / fromMap() obligatoires sur les 3 entités
  - const constructors si possible
  - copyWith() pour mutations immutables
  - Types stricts, pas de dynamic
  - Générer les 3 entités + les 4 interfaces repository
```

---

## ÉTAPE 2 — Controllers GetX

### Prompt 2.1 — FeedController

> **Objectif :** Gérer la liste réactive des biens, le filtre par catégorie, et les actions like / sauver / contacter.

```
Tu es un expert Flutter / GetX. Crée le FeedController pour PropFeed.

## FICHIER : lib/application/controllers/feed_controller.dart

ÉTAT RÉACTIF :
  RxList<PropListing> listings = <PropListing>[].obs
  Rx<PropType?> activeFilter = Rx<PropType?>(null)
  RxBool isLoading = true.obs
  RxString error = ''.obs
  RxInt currentIndex = 0.obs

GETTER FILTRÉ :
  List<PropListing> get filteredListings =>
    activeFilter.value == null
      ? listings
      : listings.where((l) => l.listingType == activeFilter.value).toList()

MÉTHODES :
  - onInit() : s'abonner au stream FeedRepository.watchFeed()
  - void setFilter(PropType? type)  // null = tout
  - Future<void> toggleLike(String listingId)
  - Future<void> toggleSave(String listingId)
  - void openContactSheet(String listingId)  // Get.bottomSheet(...)
  - void preloadAdjacentVideos(int index)    // précharger ±1

PAGINATION LAZY LOAD :
  - pageSize: 10
  - Charger plus quand currentIndex >= listings.length - 3
  - RxBool hasMore = true.obs

GESTION ERREURS :
  - try/catch avec Get.snackbar personnalisé :
    Get.snackbar('', message,
      backgroundColor: Color(0xFF0A0A0A).withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.info_outline, color: Color(0xFF2744DE)),
    )
  - onClose() : cancel subscription stream

CONTRAINTES :
  - Injecter FeedRepository via Get.find<FeedRepository>()
  - Jamais de logique Firebase/backend dans ce controller
  - Optimistic update : modifier liste locale AVANT requête serveur
```

### Prompt 2.2 — UploadController

> **Objectif :** Créer le flux complet de publication d'un bien : pick vidéo → compression → thumbnail → upload → save.

```
Crée UploadController pour PropFeed.

## FICHIER : lib/application/controllers/upload_controller.dart

FLUX EN 5 ÉTAPES :

ÉTAPE 1 — PICK VIDEO
  Future<void> pickVideo({required bool useCamera})
  Utilise MediaPickerService.pickVideoPath()
  Stocker dans RxnString rawVideoPath

ÉTAPE 2 — PRÉVISUALISATION (ConfirmScreen)
  File get videoFile => File(rawVideoPath.value!)
  Champs éditables :
    RxString price
    Rx<PropType> listingType
    RxString address
    RxInt rooms
    RxDouble area

ÉTAPE 3 — COMPRESSION
  MediaProcessorService.compressMedium(rawVideoPath)
  Afficher RxDouble compressionProgress (0.0 → 1.0)
  LinearProgressIndicator avec color: Color(0xFF2744DE)

ÉTAPE 4 — THUMBNAIL
  MediaProcessorService.generateThumbnail(rawVideoPath)

ÉTAPE 5 — PUBLISH
  Upload vidéo + thumbnail via MediaStorageService
  Créer PropListing avec les métadonnées saisies
  Appeler FeedRepository.createListing(listing)
  Get.snackbar avec animation slide-in depuis le bas
  Naviguer vers le feed avec transition fade

CONTRAINTES :
  - RxBool isPublishing pour bloquer double-tap
  - Générer l'ID avec uuid (pas docs.length ni timestamp seul)
  - Libérer les ressources dans onClose()
```

### Prompt 2.3 — ProfileController & SearchController

```
Crée ProfileController et PropertySearchController pour PropFeed.

## ProfileController
## FICHIER : lib/application/controllers/profile_controller.dart

STATE :
  Rx<AppUser?> user
  RxList<PropListing> userListings    (grille vidéo)
  RxList<PropListing> savedListings   (coups de cœur)
  RxBool isFollowing
  RxInt followersCount, followingCount, totalLikes
  RxBool isLoading

MÉTHODES :
  - onInit() : charger profil + s'abonner aux stats via stream
  - toggleFollow() : optimistic update sur followersCount
  - loadSavedListings() : charger les coups de cœur

BUG À ÉVITER : isFollowing doit être toggleé dans les 2 branches :
  if (isFollowing.value) {
    await socialRepo.toggleFollow(...);
    isFollowing.value = false;    // ← OBLIGATOIRE ici aussi
    followersCount.value--;
  } else {
    await socialRepo.toggleFollow(...);
    isFollowing.value = true;
    followersCount.value++;
  }

## PropertySearchController
## FICHIER : lib/application/controllers/search_controller.dart

STATE :
  RxList<PropListing> results
  RxString query
  Rx<PropType?> filterType
  RxDouble? maxPrice
  RxBool isSearching

MÉTHODES :
  - void search(String query) : debounce 500ms
  - void applyFilters({PropType? type, double? maxPrice})
  - void clearFilters()
  - void clearSearch()     // reset complet query + filtres + résultats
```

---

## ÉTAPE 3 — Écrans & Navigation

### Prompt 3.1 — Intégration PropFeedScreen dans la navigation

> **Objectif :** Connecter PropFeedScreen à l'onglet "Vivre" de la bottom bar existante. Aucune modification de la bottom bar elle-même.

```
Intègre PropFeedScreen dans la navigation existante d'ImmoPlus.

## RÈGLE UNIQUE
L'onglet "Vivre" de la bottom bar existante doit pointer
sur PropFeedScreen(). Ne pas modifier la bottom bar.

## DANS LE FICHIER DE NAVIGATION EXISTANT
Localise le tableau pages[] ou le switch case qui mappe
les indices de la bottom bar vers les écrans.

Remplacer le placeholder de l'onglet Vivre par :
  pages[indexVivre] = const PropFeedScreen();

## ROUTE NOMMÉE (optionnel)
Si le projet utilise GetX routing :
  GetPage(
    name: '/feed',
    page: () => const PropFeedScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<FeedController>(() => FeedController());
    }),
  )

## CONTRAINTES
  - Ne toucher à aucun autre onglet ni à la structure de navigation
  - PropFeedScreen doit être disposé quand on quitte l'onglet Vivre
  - Utiliser AutomaticKeepAliveClientMixin sur PropFeedScreen
    seulement si le projet garde l'état entre onglets
```

### Prompt 3.2 — PropFeedScreen (Écran Principal)

> **Objectif :** Créer l'écran de feed vertical immersif avec header transparent, pills catégorie, overlay fiche bien (bas-gauche), et barre d'actions (droite).

```
Crée PropFeedScreen, l'écran principal de PropFeed.

## FICHIER : lib/presentation/screens/feed/prop_feed_screen.dart

STRUCTURE GLOBALE :
  Scaffold(
    backgroundColor: Colors.black,
    extendBodyBehindAppBar: true,
    body: Stack(children: [
      // 1. PageView vidéo plein écran
      // 2. Header transparent (top)
      // 3. Pills catégorie (sous le header)
      // 4. Overlay fiche bien (bas-gauche)
      // 5. Barre d'actions (droite)
      // 6. Progress dots (bord droit, centre vertical)
    ])
  )

1. PAGEVIEW VIDÉO :
  Obx(() => PageView.builder(
    scrollDirection: Axis.vertical,
    physics: BouncingScrollPhysics(),
    itemCount: controller.filteredListings.length,
    onPageChanged: (i) {
      controller.currentIndex.value = i;
      controller.preloadAdjacentVideos(i);
    },
    itemBuilder: (ctx, i) => PropVideoPlayer(
      listing: controller.filteredListings[i],
      isActive: controller.currentIndex.value == i,
    ),
  ))

2. HEADER TRANSPARENT :
  Positioned(top: 0, left: 0, right: 0,
    Container(
      decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.black.withOpacity(0.6), Colors.transparent]
      )),
      child: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          // Pill filtre actif : '📍 Paris · Location' avec fond primary bleu
          // Centre : logo PropFeed (vide pour immersion)
          // Droite : IconButton filtre + IconButton recherche (icons blancs)
        ])
      ))
    )
  )

3. PILLS CATÉGORIE :
  Position: top: 88 (sous safe area + header)
  SingleChildScrollView(scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [
      GlassmorphismPill(label: 'Tout', isActive: ...),
      GlassmorphismPill(label: 'Location', isActive: ...),
      // ... Vente, Saisonnier, Coloc, Meublé, Neuf, Luxe
    ])
  )

  Style actif : fond Color(0xFF2744DE), texte blanc, borderRadius 999
  Style inactif : GlassmorphismPill (BackdropFilter blur:8,
    color: white.withOpacity(0.12), border: white.withOpacity(0.25))

6. PROGRESS DOTS :
  Position: right: 6, centre vertical
  3 points max visibles (current ±1)
  Point actif : blanc plein, 8px
  Points inactifs : blanc 30%, 5px
  AnimatedContainer sur changement (150ms)
```

### Prompt 3.3 — Widget Overlay Fiche Bien

```
Crée le widget ListingOverlay pour la fiche bien en bas-gauche du feed.

## FICHIER : lib/presentation/widgets/listing_overlay.dart
PROPS : PropListing listing, VoidCallback onFollowTap

FOND GRADIENT :
  Positioned(bottom: 0, left: 0, right: 0,
    IgnorePointer(child: Container(height: 380,
      decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.bottomCenter, end: Alignment.topCenter,
        stops: [0.0, 0.4, 1.0],
        colors: [
          Colors.black.withOpacity(0.85),
          Colors.black.withOpacity(0.4),
          Colors.transparent,
        ]
      )))
    )
  )

CONTENU (padding: EdgeInsets.only(left:16, bottom:90, right:88)) :

LIGNE 1 — Agent :
  Row(children: [
    Stack(children: [
      CircleAvatar(radius: 18,
        backgroundImage: NetworkImage(listing.agentAvatarUrl)),
      if (listing.isLive)
        Positioned(bottom:0, right:0,
          _PulsingDot(color: Colors.red, size: 10))
    ]),
    SizedBox(width: 8),
    Column(crossAxisAlignment: start, children: [
      Text('@${listing.agentHandle}',
        style: white bold 14),
      Text('Agent certifié ✓',
        style: TextStyle(color: Color(0xFF2744DE), fontSize: 11,
                         fontWeight: FontWeight.w600)),
    ]),
    SizedBox(width: 10),
    _FollowButton(isFollowing: ..., onTap: onFollowTap),
  ])

  _FollowButton :
    AnimatedContainer(
      duration: 250ms,
      width: 72, height: 28,
      decoration: BoxDecoration(
        color: isFollowing ? Color(0xFF2744DE) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFollowing ? Color(0xFF2744DE) : Colors.white,
          width: 1.5)),
      child: Center(child: Text(
        isFollowing ? 'Suivi ✓' : '+ Suivre',
        style: TextStyle(color: white, fontSize: 12,
                         fontWeight: FontWeight.w600))),
    )

LIGNE 2 — Badge type + infos :
  Row(children: [
    _TypeBadge(listing.listingType),
    SizedBox(width: 8),
    Text('${listing.rooms}P · ${listing.area}m²',
      style: TextStyle(color: white, fontSize: 13)),
  ])

LIGNE 3 — Localisation :
  Row(children: [
    Icon(Icons.location_on_rounded, size: 13, color: Colors.white70),
    SizedBox(width: 4),
    Expanded(child: Text(listing.address,
      style: TextStyle(color: Colors.white70, fontSize: 13),
      overflow: TextOverflow.ellipsis, maxLines: 1)),
  ])

LIGNE 4 — PRIX ANIMÉ :
  AnimatedPriceWidget(
    targetPrice: listing.price,
    listingType: listing.listingType,
    key: ValueKey(listing.id),   // reset anim au changement de page
  )
  SizedBox(height: 2)
  Text('Disponible ${_formatDate(listing.availableFrom)}',
    style: TextStyle(color: Colors.white60, fontSize: 12))

CTA PILL :
  GestureDetector(
    onTap: () => showListingDetail(context, listing),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)),
      child: Text('VOIR L\'ANNONCE',
        style: TextStyle(color: Color(0xFF0A0A0A), fontSize: 13,
                         fontWeight: FontWeight.w700,
                         letterSpacing: 0.5)),
    )
  )

BADGE TYPE (_TypeBadge) :
  location    → Color(0xFF2744DE)   (bleu primary)
  vente       → Color(0xFFF97316)   (orange)
  saisonnier  → Color(0xFF8B5CF6)   (violet)
  meuble      → Color(0xFF22C55E)   (vert)
  luxe        → Color(0xFFB8860B)   (or)
  coloc       → Color(0xFF06B6D4)   (cyan)
  neuf        → Color(0xFFEF4444)   (rouge)

  Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: badgeColor.withOpacity(0.9),
      borderRadius: BorderRadius.circular(6)),
    child: Text(label.toUpperCase(),
      style: TextStyle(color: white, fontSize: 11,
                       fontWeight: FontWeight.w600,
                       letterSpacing: 0.3)),
  )

LARGEUR MAX : MediaQuery.sizeOf(context).width * 0.72
```

### Prompt 3.4 — Widget Barre d'Actions (Droite)

```
Crée ActionsColumn, la barre d'actions verticale droite du feed.

## FICHIER : lib/presentation/widgets/actions_column.dart
PROPS : PropListing listing, FeedController controller

STRUCTURE :
  Positioned(bottom: 90, right: 16,
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionItem(like),
        SizedBox(height: 20),
        _ActionItem(save),
        SizedBox(height: 20),
        _ActionItem(share),
        SizedBox(height: 20),
        _ContactButton(),
        SizedBox(height: 20),
        _MoreButton(),
      ]
    )
  )

PATRON _ActionItem :
  GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      _animCtrl.forward().then((_) => _animCtrl.reverse());
      onTap();
    },
    child: Column(children: [
      ScaleTransition(scale: _bounceAnim,
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.1))),
          child: Icon(icon, size: 26, color: iconColor))),
      SizedBox(height: 4),
      Text(counter,
        style: TextStyle(color: Colors.white, fontSize: 12,
                         fontWeight: FontWeight.w500,
                         shadows: [Shadow(blurRadius: 4)])),
    ])
  )

Animation bounce : Tween(0.8, 1.3 → 1.0) duration:150ms elasticOut

1. ❤️ LIKE :
  Icon rouge (Icons.favorite) si liked, blanc sinon
  HapticFeedback.mediumImpact()

2. 🔖 SAUVER :
  Icon filled/outline selon état
  Animation scale 0.9 → 1.2 → 1.0

3. 📤 PARTAGER :
  Share.share('${listing.address} — ${_formatPrice(listing.price)}')
  Icon Icons.ios_share (cohérent iOS/Android)

4. 📞 CONTACTER (action prioritaire) :
  Container(
    width: 50, height: 50,
    decoration: BoxDecoration(
      color: Color(0xFF2744DE),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(
        color: Color(0xFF2744DE).withOpacity(0.4),
        blurRadius: 16, offset: Offset(0, 4))]),
    child: Icon(Icons.calendar_today_rounded,
      color: Colors.white, size: 24))
  Label: 'Visiter'

5. ⋯ PLUS :
  showModalBottomSheet Material 3 :
  ListTile items : Signaler · Partager · Copier le lien

BADGE LIVE :
  if (listing.isLive)
    Positioned(top: -4, right: -4,
      AnimatedOpacity alternant 1.0/0.3 toutes les 600ms,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6)),
        child: Text('● LIVE',
          style: TextStyle(color: white, fontSize: 9,
                           fontWeight: FontWeight.w700))))
```

---

## ÉTAPE 4 — Player Vidéo & Animations

### Prompt 4.1 — PropVideoPlayer Widget

> ⚠️ **OBLIGATION :** `dispose()` sur `VideoPlayerController` ET `AnimationController`. Sans dispose(), les fuites mémoire causeront des crashs sur le feed scroll.

```
Crée PropVideoPlayer, le widget vidéo plein écran pour PropFeed.

## FICHIER : lib/presentation/widgets/prop_video_player.dart
PROPS : PropListing listing, bool isActive

LIFECYCLE :
  initState() :
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(listing.videoUrl))
    _controller.initialize().then((_) {
      if (isActive) _controller.play();
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      setState(() {});
    })

  didUpdateWidget(old) :
    if (widget.isActive != old.isActive) {
      widget.isActive ? _controller.play() : _controller.pause();
    }

  dispose() :
    _controller.dispose();         // OBLIGATOIRE
    _animationController.dispose(); // OBLIGATOIRE
    super.dispose();

INTERACTIONS :
  - Tap simple : toggle pause/play
    + FadeIn/Out icône play centré (Icon size:64, white60, 300ms)
  - Double tap : controller.toggleSave(listing.id)
    + HeartAnimation centrée
    + HapticFeedback.heavyImpact()
  - Swipe gauche (velocity > 600) :
    Navigator.push avec slide transition vers ListingDetailScreen

RENDER VIDÉO :
  SizedBox.expand(
    child: FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller))))

ÉTATS :
  Buffering :
    Center(child: CircularProgressIndicator(
      color: Color(0xFF2744DE), strokeWidth: 2))

  Error réseau :
    Center(child: Column(children: [
      Icon(Icons.wifi_off_rounded, color: white54, size: 48),
      SizedBox(height: 12),
      Text('Vérifiez votre connexion',
        style: TextStyle(color: white54, fontSize: 14)),
    ]))

  Thumbnail pendant load :
    Image.network(listing.thumbnailUrl,
      fit: BoxFit.cover, width: double.infinity, height: double.infinity)

OVERLAY GRADIENT BAS :
  Positioned(bottom: 0, left: 0, right: 0,
    IgnorePointer(child: Container(height: 350,
      decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.bottomCenter, end: Alignment.topCenter,
        stops: [0.0, 0.5, 1.0],
        colors: [black.withOpacity(0.8), black.withOpacity(0.3),
                 Colors.transparent])))))

OVERLAY GRADIENT HAUT :
  Positioned(top: 0, left: 0, right: 0,
    IgnorePointer(child: Container(height: 120,
      decoration: BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [black.withOpacity(0.5), Colors.transparent])))))

CONTRAINTES :
  - N'utiliser JAMAIS setState pour l'état vidéo → ValueListenableBuilder
  - Précharger seulement si isActive == true
```

### Prompt 4.2 — Animations Différenciantes

```
Crée les 4 widgets d'animation différenciants de PropFeed.

## 1. AnimatedPriceWidget
## FICHIER : lib/presentation/widgets/animated_price.dart

TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: listing.price),
  duration: Duration(milliseconds: 1200),
  curve: Curves.easeOut,
  builder: (ctx, value, _) {
    final formatted =
      NumberFormat('#,###', 'fr_FR').format(value.round());
    final suffix = listing.listingType == PropType.location
      ? '€/mois CC' : '€';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('$formatted',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            fontFamily: 'Inter',
            shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
          )),
        SizedBox(width: 4),
        Text(suffix,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500)),
      ],
    );
  },
)

## 2. HeartAnimation (double-tap)
## FICHIER : lib/presentation/widgets/heart_animation.dart

StatefulWidget + SingleTickerProviderStateMixin
AnimationController(duration: Duration(milliseconds: 800), vsync: this)

Animations combinées :
  _scaleIn = Tween(0.0, 1.0).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Interval(0.0, 0.6, curve: Curves.elasticOut)))

  _scaleOut = Tween(1.0, 0.0).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Interval(0.65, 1.0, curve: Curves.easeIn)))

  _fade = Tween(0.0, 1.0).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Interval(0.0, 0.3)))

  _fadeOut = Tween(1.0, 0.0).animate(CurvedAnimation(
    parent: _ctrl,
    curve: Interval(0.7, 1.0)))

Rendu :
  Center(child: AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => Opacity(
      opacity: (_fade.value * _fadeOut.value).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: _scaleIn.value * (1 + _scaleOut.value * 0.5),
        child: Icon(Icons.favorite_rounded,
          color: Colors.red, size: 100,
          shadows: [Shadow(blurRadius: 20, color: Colors.red.withOpacity(0.5))])
      )
    )
  ))

dispose() : _ctrl.dispose();  // OBLIGATOIRE

## 3. GlassmorphismPill (pills catégorie)
## FICHIER : lib/presentation/widgets/glassmorphism_pill.dart
PROPS : String label, bool isActive, VoidCallback onTap

GestureDetector(
  onTap: () {
    HapticFeedback.selectionClick();
    onTap();
  },
  child: AnimatedContainer(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOut,
    margin: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: isActive
        ? Color(0xFF2744DE)
        : Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: isActive
          ? Colors.transparent
          : Colors.white.withOpacity(0.25),
        width: 1)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: isActive
      ? Text(label, style: TextStyle(
          color: Colors.white, fontSize: 13,
          fontWeight: FontWeight.w600))
      : ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Text(label, style: TextStyle(
              color: Colors.white, fontSize: 13,
              fontWeight: FontWeight.w600)))),
  )
)

## 4. ShimmerSkeleton (états loading)
## FICHIER : lib/presentation/widgets/shimmer_skeleton.dart

AnimationController(duration: Duration(milliseconds: 1500), vsync: this)
  ..repeat()

build() :
  AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) {
      final shimmer = LinearGradient(
        colors: [
          Color(0xFFE8EBF8),
          Color(0xFFF2F4FC),
          Color(0xFFE8EBF8),
        ],
        stops: [0.1, 0.5, 0.9],
        begin: Alignment(-1 + 2 * _ctrl.value, -0.3),
        end: Alignment(1 + 2 * _ctrl.value, 0.3),
      );
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: shimmer,
          borderRadius: BorderRadius.circular(borderRadius)),
      );
    }
  )

// Couleurs shimmer sur fond sombre (feed) :
//   Color(0xFF2C2C2E), Color(0xFF3A3A3C), Color(0xFF2C2C2E)
// Couleurs shimmer sur fond blanc (listes) :
//   Color(0xFFE8EBF8), Color(0xFFF2F4FC), Color(0xFFE8EBF8)

dispose() : _ctrl.dispose();  // OBLIGATOIRE
```

---

## ÉTAPE 5 — Features Sociales & Profil

### Prompt 5.1 — ProfileScreen

```
Crée ProfileScreen pour PropFeed avec grille de biens.

## FICHIER : lib/presentation/screens/profile/profile_screen.dart

SCAFFOLD :
  Scaffold(
    backgroundColor: Colors.white,
    body: NestedScrollView(
      headerSliverBuilder: (ctx, _) => [_ProfileHeader()],
      body: DefaultTabController(length: 2, child: Column(children: [
        _TabsBar(),
        Expanded(child: TabBarView(children: [
          _ListingsGrid(),
          _SavedGrid(),
        ])),
      ]))
    )
  )

1. HEADER PROFIL :
  SliverToBoxAdapter(
    Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Row(children: [
          Stack(children: [
            CircleAvatar(radius: 40,
              backgroundImage: NetworkImage(user.avatarUrl)),
            if (user.isVerified)
              Positioned(bottom: 0, right: 0,
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color(0xFF2744DE),
                    shape: BoxShape.circle,
                    border: Border.all(color: white, width: 2)),
                  child: Icon(Icons.check, color: white, size: 10)))
          ]),
          SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                                 color: Color(0xFF0A0A0A))),
              Text('@${user.handle}',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
            ]
          )),
          if (isCurrentUser)
            OutlinedButton('Modifier',
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF2744DE),
                side: BorderSide(color: Color(0xFF2744DE)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))))
          else
            _FollowButton(isFollowing: controller.isFollowing),
        ]),
        SizedBox(height: 20),
        _MetricsRow(),
      ])
    )
  )

_MetricsRow — 4 colonnes égales :
  _MetricItem(value: formatCount(listings.length), label: 'Biens')
  _MetricItem(value: formatCount(followersCount), label: 'Followers')
  _MetricItem(value: formatCount(followingCount), label: 'Suivis')
  _MetricItem(value: formatCount(totalLikes), label: '❤️ Likes')

  _MetricItem :
    Column(children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                                    color: Color(0xFF0A0A0A))),
      Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
    ])

  Séparateurs verticaux : Container(width:1, height:32,
    color: Color(0xFFE5E7EB)) entre chaque item

2. TABBAR :
  TabBar(
    indicatorColor: Color(0xFF2744DE),
    indicatorWeight: 2,
    labelColor: Color(0xFF2744DE),
    unselectedLabelColor: Color(0xFF6B7280),
    labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    tabs: [
      Tab(text: 'Annonces'),
      Tab(text: '🔖 Coups de cœur'),
    ]
  )

3. GRILLE VIDÉOS (_ListingsGrid) :
  GridView.builder(
    padding: EdgeInsets.zero,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
    itemBuilder: (ctx, i) => _VideoThumbnail(listing: listings[i]))

_VideoThumbnail :
  Stack(children: [
    Positioned.fill(child: Image.network(thumbnailUrl, fit: BoxFit.cover)),
    Positioned(top: 6, left: 6,
      child: _TypeBadge(listing.listingType, small: true)),
    if (listing.isLive)
      Positioned(top: 6, right: 6,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(color: Colors.red,
            borderRadius: BorderRadius.circular(4)),
          child: Text('LIVE', style: TextStyle(color: white,
            fontSize: 9, fontWeight: FontWeight.w700)))),
    Positioned(bottom: 0, left: 0, right: 0,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.bottomCenter, end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent])),
        child: Row(children: [
          Icon(Icons.favorite, color: white, size: 11),
          SizedBox(width: 2),
          Text('${listing.likes.length}', style: TextStyle(color: white, fontSize: 11)),
          Spacer(),
          Text(_formatPrice(listing.price), style: TextStyle(
            color: white, fontSize: 11, fontWeight: FontWeight.w600)),
        ])
      )),
  ])

STATES :
  Loading : GridView de 9 ShimmerSkeleton(borderRadius: 0)
  Empty 'Annonces' :
    Center(child: Column(children: [
      Icon(Icons.video_library_outlined, size: 48, color: Color(0xFF6B7280)),
      SizedBox(height: 12),
      Text('Aucun bien publié', style: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0A0A0A))),
      Text('Publiez votre premier bien via l\'onglet Vivre',
        style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
    ]))
  Empty 'Coups de cœur' :
    Même structure, icône Icons.bookmark_outline_rounded,
    texte 'Sauvegardez les biens qui vous intéressent'
```

### Prompt 5.2 — ContactSheet & SearchScreen

```
Crée ContactSheet et PropertySearchScreen pour PropFeed.

## 1. ContactSheet
## FICHIER : lib/presentation/widgets/contact_sheet.dart

showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => DraggableScrollableSheet(
    initialChildSize: 0.62,
    maxChildSize: 0.92,
    minChildSize: 0.42,
    builder: (_, scrollCtrl) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [
        // Drag handle
        Center(child: Container(
          margin: EdgeInsets.only(top: 12),
          width: 40, height: 4,
          decoration: BoxDecoration(
            color: Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(2)))),
        // Agent header
        _AgentHeader(listing),
        Divider(color: Color(0xFFE5E7EB), height: 1),
        // Fiche résumé
        _ListingSummaryTile(listing),
        Divider(color: Color(0xFFE5E7EB), height: 1),
        // 3 actions
        _ContactActions(),
        SizedBox(height: 16),
        // Champ message
        _QuickMessageField(),
        // Bouton envoyer
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ElevatedButton('Envoyer',   // style global primary bleu
            onPressed: controller.sendMessage)),
      ])
    )
  )
)

_ContactActions : Row de 3 boutons égaux
  Appeler  : fond Color(0xFF22C55E) Icon phone_rounded
  Message  : fond Color(0xFF2744DE) Icon chat_bubble_outline_rounded
  Visiter  : fond Color(0xFF2744DE) à 15% + bord bleu Icon calendar_today
  Format : Expanded(Column(Container(icon 24px, borderRadius:14),
    SizedBox(height:6), Text(label, grey 12)))

_QuickMessageField :
  Padding(padding: EdgeInsets.symmetric(horizontal: 16),
    TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Bonjour, je suis intéressé par ce bien...',
        // Style global inputDecorationTheme appliqué automatiquement
      )
    )
  )

## 2. PropertySearchScreen
## FICHIER : lib/presentation/screens/search/search_screen.dart

Scaffold(
  backgroundColor: Colors.white,
  body: SafeArea(child: Column(children: [
    _SearchBar(),
    _FilterRow(),
    Expanded(child: Obx(() =>
      controller.isSearching.value
        ? _LoadingSkeletons()
        : controller.results.isEmpty && controller.query.isNotEmpty
          ? _EmptyState()
          : _ResultsList()
    )),
  ]))
)

_SearchBar :
  Container(
    margin: EdgeInsets.all(16),
    child: TextField(
      autofocus: true,
      onChanged: (v) => controller.search(v),   // debounce 500ms
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
        hintText: 'Paris, Lyon, 3 pièces, appartement...',
        suffixIcon: Obx(() => controller.query.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear_rounded, color: Color(0xFF6B7280)),
              onPressed: controller.clearSearch)
          : SizedBox.shrink()),
      ),
    )
  )

_FilterRow : SingleChildScrollView horizontal, padding: h16,
  Row de GlassmorphismPill pour chaque PropType
  Mais sur fond blanc → pill active : fond Color(0xFF2744DE), texte blanc
  Pill inactive : fond Color(0xFFF2F4FC), texte Color(0xFF6B7280),
                  border Color(0xFFE5E7EB)

_ResultCard :
  Card(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: ListTile(
      leading: ClipRRect(borderRadius: BorderRadius.circular(8),
        child: Image.network(listing.thumbnailUrl,
          width: 72, height: 72, fit: BoxFit.cover)),
      title: Row(children: [
        _TypeBadge(listing.listingType, small: true),
        SizedBox(width: 6),
        Text('${listing.rooms}P · ${listing.area}m²',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
      ]),
      subtitle: Column(crossAxisAlignment: start, children: [
        SizedBox(height: 2),
        Text(listing.address,
          style: TextStyle(fontSize: 13), overflow: ellipsis),
        SizedBox(height: 4),
        Text(_formatPrice(listing.price),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                           color: Color(0xFF0A0A0A))),
      ]),
      onTap: () => Get.to(() => PropDetailScreen(listing)),
    )
  )

_EmptyState :
  Center(child: Column(children: [
    Icon(Icons.search_off_rounded, size: 64, color: Color(0xFFE5E7EB)),
    SizedBox(height: 16),
    Text('Aucun résultat',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                       color: Color(0xFF0A0A0A))),
    Text('Essayez avec d\'autres mots-clés ou filtres',
      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
  ]))
```

---

## ÉTAPE 6 — Qualité, Bugs & Performance

### Prompt 6.1 — Corrections Bugs Critiques

> ⚠️ **Bugs identifiés en audit :**
> - Bug 1 — `MyVideoPlayer` : `dispose()` manquant → fuite mémoire
> - Bug 2 — `AnimationCircle` : `AnimationController` non disposé
> - Bug 3 — `ProfileController.followUser()` : `isFollowing` non toggleé dans le `if`
> - Bug 4 — User model : `name` mappé sur `'email'` au lieu de `'name'`
> - Bug 5 — `CommentController` : cast `dynamic` au lieu de `Map<String,dynamic>`

```
Corrige les bugs critiques identifiés dans l'audit du projet.

## BUG 1 — PropVideoPlayer dispose()

@override
void dispose() {
  _videoController.dispose();        // OBLIGATOIRE
  _animationController.dispose();    // OBLIGATOIRE
  super.dispose();
}

## BUG 2 — AnimationCircle dispose()

// Dans lib/views/widgets/animation_circle.dart
@override
void dispose() {
  _animationController.dispose();    // AJOUTÉ
  super.dispose();
}

## BUG 3 — ProfileController.followUser()

// APRÈS (corrigé) :
if (isFollowing.value) {
  await socialRepo.toggleFollow(userId: userId, targetId: targetId);
  isFollowing.value = false;         // ← AJOUTÉ
  followersCount.value--;
} else {
  await socialRepo.toggleFollow(userId: userId, targetId: targetId);
  isFollowing.value = true;
  followersCount.value++;
}

## BUG 4 — AppUser model mapping

// AVANT : name: snapshot['email']   ← BUG
// APRÈS :
name: snapshot['name'] as String,

## BUG 5 — CommentController cast

// AVANT : (userDoc as dynamic)['name']   ← BUG
// APRÈS :
(userDoc.data() as Map<String, dynamic>)['name'] as String
```

### Prompt 6.2 — Performance & UX No-Friction

```
Optimise la fluidité de PropFeed.

## PERFORMANCE VIDÉO
  - PageView.builder physics: BouncingScrollPhysics()
  - AutomaticKeepAliveClientMixin sur PropVideoPlayer
    wantKeepAlive: true SEULEMENT pour currentIndex ± 1
  - Pauser toutes les vidéos non-actives dans didUpdateWidget
  - CachedNetworkImage pour tous les thumbnails et avatars
  - PropVideoPlayer : charger seulement si isActive == true
  - Purger les vidéos éloignées de plus de 3 positions

## GESTES FLUIDES
  - Pas de setState dans GestureDetector → GetX obs uniquement
  - Swipe bas depuis le premier item : dismiss avec animation scale
  - Retour iOS : PopScope avec geste natif préservé

## ÉTATS UI — OBLIGATOIRES SUR TOUS LES ÉCRANS
  Loading  : ShimmerSkeleton avec bonnes couleurs (blanc ou sombre)
  Error    : Icon + message clair + ElevatedButton 'Réessayer'
  Empty    : Icon + titre + sous-titre contextuel
  Success  : Get.snackbar personnalisé (fond sombre, icône ✓ vert)

## ACCESSIBILITÉ
  - Semantics() sur tous les boutons d'action du feed
  - Contrast ratio ≥ 4.5:1 texte sur fond (blanc sur bleu OK)
  - HapticFeedback sur toutes les interactions tactiles :
    selectionClick() → pills, onglets
    lightImpact()    → toggles secondaires
    mediumImpact()   → like, save
    heavyImpact()    → double tap cœur

## NO-FRICTION CHECKLIST
  ✓ Aucun écran blanc au démarrage
  ✓ Pills catégorie : filtre instantané sans reload
  ✓ Like/Save : optimistic update immédiat côté UI
  ✓ Bottom sheet : ouverture < 350ms
  ✓ Jamais de dialog bloquant → snackbar ou sheet
  ✓ Keyboard dismiss : tap outside any field
  ✓ Navigation retour : geste swipe natif iOS/Android
  ✓ Scroll vidéo : zéro frame drop (éviter rebuild excessif)
  ✓ Transitions entre onglets : < 200ms
```

### Prompt 6.3 — Checklist Qualité Finale

```
Vérifie la qualité globale de l'implémentation PropFeed.

## MÉMOIRE & LIFECYCLE
  ✓ Tous les VideoPlayerController ont dispose()
  ✓ Tous les AnimationController ont dispose()
  ✓ Tous les StreamSubscription sont cancel() dans onClose()
  ✓ ShimmerSkeleton AnimationController disposé

## ARCHITECTURE
  ✓ Zéro logique backend dans les widgets UI
  ✓ Zéro logique backend dans les controllers
    (uniquement via interfaces Repository)
  ✓ Tous les modèles ont toMap() / fromMap() / copyWith()
  ✓ Types stricts partout (pas de dynamic ni cast non sécurisé)
  ✓ IDs générés avec uuid (pas docs.length ni timestamp seul)

## DESIGN SYSTEM
  ✓ ThemeData Material 3 configuré dans main.dart
  ✓ Inter comme fontFamily globale (google_fonts)
  ✓ Couleur primary : Color(0xFF2744DE) partout (boutons, indicateurs, liens)
  ✓ Fond blanc (#FFFFFF) sur tous les écrans hors feed vidéo
  ✓ Fond noir (#000000) sur le feed vidéo uniquement
  ✓ Tous les radius cohérents (8/12/14/16/24/999)
  ✓ Aucune couleur hardcodée hors des tokens AppColors
  ✓ HapticFeedback sur toutes les interactions tactiles

## PROPFEED SPÉCIFIQUE
  ✓ Animation prix reveal à chaque changement de page (key: ValueKey(id))
  ✓ Double-tap = sauvegarder + HeartAnimation + heavyImpact
  ✓ Swipe gauche = fiche détail (velocity check > 600)
  ✓ Pills glassmorphism actif = Color(0xFF2744DE) plein
  ✓ Badge LIVE pulsant si isLive == true
  ✓ ShimmerSkeleton sur tous les états loading
  ✓ Empty states avec icône + texte sur tous les écrans
  ✓ Snackbar personnalisé fond sombre sur toutes les actions

SIGNALE tout ce qui n'est pas conforme et propose un fix.
```

---

## Tableau de Mapping — Existant → PropFeed

| Composant actuel | Évolution PropFeed |
|---|---|
| `home_screen.dart` bottom bar | **Inchangée** — onglet Vivre → `PropFeedScreen()` |
| `video_screen.dart` (feed) | `PropFeedScreen` + header + pills glassmorphism |
| Modèle `Video` | `PropListing` (price, type, address, area...) |
| `BottomNavigationBar` | **Inchangée** |
| Like + Comment | Like + Sauver + Contacter + Share |
| `CommentScreen` | `ContactSheet` DraggableScrollable |
| Recherche users | `PropertySearchController` + `SearchScreen` |
| Profil actuel | Profil + onglet Coups de cœur + grille thumbnails |
| `CircularProgressIndicator` | `ShimmerSkeleton` partout + spinner bleu `#2744DE` |
| `Get.snackbar` default | Snackbar custom fond sombre, icône, durée 2s |
| Couleurs accent existantes | `Color(0xFF2744DE)` primary — fond `Colors.white` |

---

## Ordre d'Exécution Recommandé

1. **Prompt 1.1** — Entités & Structure *(fondations absolues)*
2. **Prompt 2.1** — FeedController
3. **Prompt 2.2** — UploadController
4. **Prompt 2.3** — ProfileController + SearchController
5. **Prompt 3.1** — Intégration dans la navigation existante *(onglet Vivre → PropFeedScreen)*
6. **Prompt 3.2** — PropFeedScreen layout principal
7. **Prompt 3.3** — ListingOverlay widget
8. **Prompt 3.4** — ActionsColumn widget
9. **Prompt 4.1** — PropVideoPlayer *(+ dispose() !!)*
10. **Prompt 4.2** — Animations (prix, cœur, glassmorphism, shimmer)
11. **Prompt 5.1** — ProfileScreen avec grille thumbnails
12. **Prompt 5.2** — ContactSheet + SearchScreen
13. **Prompt 6.1** — Corrections bugs critiques
14. **Prompt 6.2** — Performance & UX no-friction
15. **Prompt 6.3** — Checklist qualité finale

---

*PropFeed — Flutter · GetX · Material You · Clean Architecture · 2026*
*Primary: `#2744DE` — Background: `#FFFFFF` — Feed: `#000000`*