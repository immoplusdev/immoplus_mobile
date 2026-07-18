import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/logger/immo_logger.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/features/visits/visit_formular_action.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/property_card.dart';
import 'package:immoplus/app/widgets/property_tab_bar.dart';
import 'package:lottie/lottie.dart';

/// Paramètres pour contrôler la taille du bottom sheet.
class ReservationSheetSize {
  const ReservationSheetSize({
    this.heightFactor,
    this.height,
    this.maxHeight,
    this.minHeight,
    this.cardWidth,
    this.cardHeight,
    this.cardImageWidth = 92,
    this.cardImageHeight = 114,
    this.cardMapHeight = 150,
    this.cardFloating = true,
    this.cardElevation = 20,
  })  : assert(
          heightFactor == null || (heightFactor > 0 && heightFactor <= 1),
          'heightFactor doit être entre 0 et 1',
        ),
        assert(cardWidth == null || cardWidth > 0, 'cardWidth doit etre > 0'),
        assert(
            cardHeight == null || cardHeight > 0, 'cardHeight doit etre > 0'),
        assert(
          cardImageWidth > 0,
          'cardImageWidth doit etre > 0',
        ),
        assert(
          cardImageHeight > 0,
          'cardImageHeight doit etre > 0',
        );

  /// Fraction de la hauteur de l'écran (0.0 à 1.0). Ex: 0.4 = 40% de l'écran.
  final double? heightFactor;

  /// Hauteur fixe en pixels (logical).
  final double? height;

  /// Hauteur maximale en pixels.
  final double? maxHeight;

  /// Hauteur minimale en pixels.
  final double? minHeight;

  /// Largeur de la carte affichée dans le bottom sheet.
  final double? cardWidth;

  /// Hauteur totale de la carte (optionnel). Attention au contenu si trop petit.
  final double? cardHeight;

  /// Taille de l'image dans la [PropertyCard].
  final double cardImageWidth;
  final double cardImageHeight;

  /// Hauteur de la mini-carte Google Map dans la [PropertyCard].
  final double cardMapHeight;

  /// Active un effet visuel "carte flottante".
  final bool cardFloating;

  /// Intensité de l'ombre de la carte flottante.
  final double cardElevation;
}

/// Données passées au bottom sheet Réserver pour personnaliser l'affichage.
class ReservationSheetData {
  const ReservationSheetData({
    required this.entity,
    required this.entityId,
    required this.videoId,
    this.title,
    this.description,
    this.price,
    this.location,
    this.commodites = const [],
    this.pieces = const [],
    this.authorName,
    this.authorAvatarUrl,
    this.thumbnailUrl,
    // Champs spécifiques furniture
    this.furnitureType,
    this.furnitureCategory,
    this.furnitureEtat,
    this.furnitureColors = const [],
  });

  /// Type d'entité : 'residence' | 'bien_immobilier' | 'furniture'
  final String entity;

  /// ID du bien (résidence, estate, meuble)
  final String entityId;

  /// ID de la vidéo du feed
  final String videoId;

  final String? title;
  final String? description;
  final String? price;
  final String? location;

  /// Commodités (API: [{ "text": "WiFi", "icon": "wifi" }, ...]).
  final List<CommoditeData> commodites;

  /// Pièces (API: [{ "nom": "Chambre", "nombre": 1 }, ...]).
  final List<PieceData> pieces;

  final String? authorName;
  final String? authorAvatarUrl;
  final String? thumbnailUrl;

  /// Caractéristiques furniture (type, category, etat, colors)
  final String? furnitureType;
  final String? furnitureCategory;
  final String? furnitureEtat;
  final List<String> furnitureColors;

  bool get isFurniture => entity == 'furniture';
  bool get isBienImmobilier => entity == 'bien_immobilier';
  bool get isResidence => entity == 'residence';

  /// Label du bouton d'action selon le type d'entité
  String get actionButtonLabel {
    switch (entity) {
      case 'bien_immobilier':
        return 'Demander une visite';
      case 'furniture':
        return 'Contacter';
      case 'residence':
      default:
        return 'Réserver';
    }
  }

  /// Période affichée avec le prix selon le type d'entité
  String get pricePeriod {
    switch (entity) {
      case 'bien_immobilier':
        return 'vente';
      case 'furniture':
        return 'unité';
      case 'residence':
      default:
        return 'mo';
    }
  }
}

/// Résultat du fetch : données pour l'affichage + modèle brut pour les actions.
class ReservationSheetResult {
  const ReservationSheetResult({
    required this.data,
    this.rawResidence,
    this.rawBienImmobilier,
    this.rawFurniture,
  });

  final ReservationSheetData data;
  final ResidenceModel? rawResidence;
  final BienImmobilierModel? rawBienImmobilier;
  final FurnitureModel? rawFurniture;
}

/// Bottom sheet affiché au tap sur "Réserver" dans le feed vidéo.
/// Utilise [ReservationSheetData] pour afficher les infos du bien.
class ReservationBottomSheet extends StatelessWidget {
  const ReservationBottomSheet({
    super.key,
    required this.data,
    this.result,
    this.onReserve,
    this.onViewDetail,
    this.size = const ReservationSheetSize(),
  });

  final ReservationSheetData data;

  /// Modèle brut pour exécuter les actions (réserver, visiter, contacter).
  final ReservationSheetResult? result;
  final VoidCallback? onReserve;
  final VoidCallback? onViewDetail;
  final ReservationSheetSize size;

  /// Affiche le bottom sheet Réserver avec récupération automatique des données via l'API.
  /// Charge les données en fonction de l'entityId et entityType.
  static Future<T?> showWithEntityData<T>({
    required BuildContext context,
    required String entityId,
    required String entityType,
    required String videoId,
    VoidCallback? onReserve,
    VoidCallback? onViewDetail,
    ReservationSheetSize size = const ReservationSheetSize(),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FutureBuilder<ReservationSheetResult>(
            future: fetchEntityData(
              entityId: entityId,
              entityType: entityType,
              videoId: videoId,
            ),
            builder: (context, snapshot) {
              Widget content;
              if (snapshot.connectionState == ConnectionState.waiting) {
                content = Center(
                    child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/immo-loading.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    reverse: false,
                  ),
                ));
              } else if (snapshot.hasError) {
                content = SafeArea(
                  top: false,
                  bottom: false,
                  left: false,
                  right: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: Color(0xFFCCCCCC),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Impossible de charger les données',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Vérifiez votre connexion et réessayez.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              } else {
                final result = snapshot.data;
                if (result == null) {
                  content = const Center(
                    child: Text('Données non trouvées'),
                  );
                } else {
                  content = ReservationBottomSheet(
                    data: result.data,
                    result: result,
                    onReserve: onReserve,
                    onViewDetail: onViewDetail,
                    size: size,
                  );
                }
              }

              // Appliquer les mêmes contraintes de taille au loading et au contenu
              if (size.heightFactor != null) {
                content = FractionallySizedBox(
                  heightFactor: size.heightFactor!,
                  child: content,
                );
              } else if (size.height != null) {
                content = SizedBox(height: size.height, child: content);
              }
              if (size.maxHeight != null || size.minHeight != null) {
                content = ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: size.maxHeight ?? double.infinity,
                    minHeight: size.minHeight ?? 0,
                  ),
                  child: content,
                );
              }
              return content;
            },
          ),
        );
      },
    );
  }

  /// Affiche le bottom sheet Réserver. Le sheet vient du bas et s'affiche
  /// au-dessus de la navigation bar. Utilise [size] pour ajuster la hauteur.
  static Future<T?> show<T>({
    required BuildContext context,
    required ReservationSheetData data,
    VoidCallback? onReserve,
    VoidCallback? onViewDetail,
    ReservationSheetSize size = const ReservationSheetSize(),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      //showDragHandle: true,
      builder: (context) {
        Widget content = ReservationBottomSheet(
          data: data,
          onReserve: onReserve,
          onViewDetail: onViewDetail,
          size: size,
        );
        if (size.heightFactor != null) {
          content = FractionallySizedBox(
            heightFactor: size.heightFactor!,
            child: content,
          );
        } else if (size.height != null) {
          content = SizedBox(height: size.height, child: content);
        }
        if (size.maxHeight != null || size.minHeight != null) {
          content = ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.maxHeight ?? double.infinity,
              minHeight: size.minHeight ?? 0,
            ),
            child: content,
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: content,
        );
      },
    );
  }

  /// Exécute l'action du bouton (réserver, visiter, contacter) en utilisant les routes existantes.
  void _handleActionButtonTap(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    final navigator = Navigator.of(context);

    if (sessionManager.currentUser == null) {
      navigator.pop();
      context.pushNamed(AuthenticationPage.name);
      return;
    }

    navigator.pop();
    onReserve?.call();

    if (result == null) {
      onViewDetail?.call();
      return;
    }

    if (result!.rawResidence != null) {
      navigator.push(
        CupertinoPageRoute(
          builder: (_) => BookingFormularAction(
            residenceModel: result!.rawResidence!,
          ),
        ),
      );
      return;
    }

    if (result!.rawBienImmobilier != null) {
      final bien = result!.rawBienImmobilier!;
      if (bien.aLouer) {
        navigator.push(
          CupertinoPageRoute(
            builder: (_) => VisitFormularAction(bienImmoModel: bien),
          ),
        );
      } else {
        ContactUtils.showContact(id: bien.id);
      }
      return;
    }

    if (result!.rawFurniture != null) {
      final furniture = result!.rawFurniture!;
      final phone = furniture.ownerPhoneNumber.trim();
      if (phone.isEmpty) {
        ToastUtils.error('Numéro du propriétaire indisponible');
      } else {
        Utils.makePhoneCall(phone);
      }
      return;
    }

    onViewDetail?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasPrice = data.price != null && data.price!.trim().isNotEmpty;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fixedBarHeight = 76.0;
    final scrollBottomPadding = fixedBarHeight + bottomInset + 20;

    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 20, 16, scrollBottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PropertyInfo(
                  title: data.title ?? '',
                  location: data.location,
                ),
                const SizedBox(height: 6),
                PropertyTabBar(
                  tabs: [
                    PropertyTabItem(
                      label: 'À propos',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          if (data.description != null &&
                              data.description!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.description!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PropertyTabItem(
                      label: 'Cartes',
                      child: PropertyMapCard(
                        imageUrl: data.thumbnailUrl,
                        lat: 5.403045654441625,
                        lng: -3.9564392567144426,
                        height: size.cardMapHeight,
                      ),
                    ),
                    PropertyTabItem(
                      label:
                          data.isFurniture ? 'Caractéristiques' : 'Equipements',
                      child: data.isFurniture
                          ? _FurnitureCaracteristiques(data: data)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PropertyCommodites(
                                  commodites: data.commodites.isNotEmpty
                                      ? data.commodites
                                      : [
                                          const CommoditeData(
                                              text: 'WiFi', icon: 'wifi'),
                                          const CommoditeData(
                                              text: 'Climatisation',
                                              icon: 'ac'),
                                          const CommoditeData(
                                              text: 'Parking', icon: 'parking'),
                                        ],
                                  iconSize: 14,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 14),
                                PropertyPieces(
                                  pieces: data.pieces.isNotEmpty
                                      ? data.pieces
                                      : [
                                          const PieceData(
                                              nom: 'Chambre', nombre: 1),
                                          const PieceData(
                                              nom: 'Salon', nombre: 1),
                                          const PieceData(
                                              nom: 'Cuisine', nombre: 1),
                                        ],
                                  iconSize: 28,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.1), width: 0.5),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  if (hasPrice)
                    PropertyPrice(
                      price: data.price!.trim(),
                      period: data.pricePeriod,
                    ),
                  if (hasPrice) const SizedBox(width: 12),
                  Expanded(
                    child: BookNowButton(
                      label: data.actionButtonLabel,
                      compact: false,
                      onPressed: () => _handleActionButtonTap(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Récupère les données du bien via l'API en fonction du type d'entité.
  /// Retourne [ReservationSheetResult] avec les données d'affichage et le modèle brut pour les actions.
  static Future<ReservationSheetResult> fetchEntityData({
    required String entityId,
    required String entityType,
    required String videoId,
  }) async {
    ImmoLogger.i(
        '[ReservationSheet] fetchEntityData → type=$entityType | id=$entityId | video=$videoId');

    try {
      final getIt = GetIt.instance;

      switch (entityType.toLowerCase()) {
        case 'residence':
          ImmoLogger.d('[ReservationSheet] → GET /residences/$entityId');
          final residenceRepo = getIt<ResidenceRepository>();
          final response = await residenceRepo.getResidence(entityId);
          final residence = response.data;
          ImmoLogger.i(
              '[ReservationSheet] ✓ residence chargée: ${residence.nom}');
          return ReservationSheetResult(
            data: _mapResidenceToSheetData(residence, videoId),
            rawResidence: residence,
          );

        case 'bien_immobilier':
          ImmoLogger.d('[ReservationSheet] → GET /bien-immobiliers/$entityId');
          final bienRepo = getIt<BienImmobilierRepository>();
          final response = await bienRepo.getBiensImmobilier(entityId);
          final bien = response.data;
          if (bien == null) throw Exception('Bien immobilier non trouvé');
          ImmoLogger.i('[ReservationSheet] ✓ bien chargé: ${bien.nom}');
          return ReservationSheetResult(
            data: _mapBienToSheetData(bien, videoId),
            rawBienImmobilier: bien,
          );

        case 'furniture':
          ImmoLogger.d('[ReservationSheet] → GET /furnitures/$entityId');
          final furnitureRepo = getIt<FurnitureRepository>();
          final response = await furnitureRepo.getFurniture(entityId);
          final furniture = response.data;
          if (furniture == null) throw Exception('Meuble non trouvé');
          ImmoLogger.i(
              '[ReservationSheet] ✓ furniture chargée: ${furniture.titre}');
          return ReservationSheetResult(
            data: _mapFurnitureToSheetData(furniture, videoId),
            rawFurniture: furniture,
          );

        default:
          ImmoLogger.w(
              '[ReservationSheet] ⚠ entityType inconnu: "$entityType"');
          throw Exception('Unknown entity type: $entityType');
      }
    } catch (e, st) {
      ImmoLogger.e('[ReservationSheet] ✗ erreur fetchEntityData', e, st);
      throw Exception('Failed to fetch entity data: $e');
    }
  }

  /// Mappe les données de résidence
  static ReservationSheetData _mapResidenceToSheetData(
    dynamic residence,
    String videoId,
  ) {
    // Mappe les commodités (CommoditeModel avec text et icon)
    final commodites = (residence.commodites as List?)
            ?.map((c) => CommoditeData(
                  text: c.text ?? '',
                  icon: c.icon ?? '',
                ))
            .toList() ??
        [];

    // Mappe les pièces (PieceModel avec nom et nombre)
    final pieces = (residence.pieces as List?)
            ?.map((p) => PieceData(
                  nom: p.nom ?? '',
                  nombre: p.nombre ?? 0,
                ))
            .toList() ??
        [];

    return ReservationSheetData(
      entity: 'residence',
      entityId: residence.id,
      videoId: videoId,
      title: residence.nom,
      description: residence.description,
      price: residence.prixReservation?.toString(),
      location: residence.adresse,
      commodites: commodites,
      pieces: pieces,
      authorName: null,
      thumbnailUrl: residence.miniature,
    );
  }

  /// Mappe les données de bien immobilier
  static ReservationSheetData _mapBienToSheetData(
    dynamic bien,
    String videoId,
  ) {
    // Mappe les commodités (CommoditeModel avec text et icon)
    final commodites = (bien.amentities as List?)
            ?.map((c) => CommoditeData(
                  text: c.text ?? '',
                  icon: c.icon ?? '',
                ))
            .toList() ??
        [];

    // Mappe les pièces (PieceModel avec nom et nombre)
    final pieces = (bien.pieces as List?)
            ?.map((p) => PieceData(
                  nom: p.nom ?? '',
                  nombre: p.nombre ?? 0,
                ))
            .toList() ??
        [];

    // Récupère la première image comme miniature
    final thumbnailUrl = (bien.images as List?)?.isNotEmpty ?? false
        ? (bien.images as List).first
        : null;

    return ReservationSheetData(
      entity: 'bien_immobilier',
      entityId: bien.id,
      videoId: videoId,
      title: bien.nom,
      description: bien.description,
      price: bien.prix?.toString(),
      location: bien.adresse,
      commodites: commodites,
      pieces: pieces,
      thumbnailUrl: thumbnailUrl as String?,
    );
  }

  /// Mappe les données de meuble
  static ReservationSheetData _mapFurnitureToSheetData(
    dynamic furniture,
    String videoId,
  ) {
    // Récupère la première image comme miniature
    final thumbnailUrl = (furniture.images as List?)?.isNotEmpty ?? false
        ? (furniture.images as List).first
        : null;

    // Récupère les couleurs depuis metadata
    final colors = (furniture.metadata?.colors as List?)
            ?.map((c) => c.toString())
            .toList() ??
        [];

    return ReservationSheetData(
      entity: 'furniture',
      entityId: furniture.id,
      videoId: videoId,
      title: furniture.titre,
      description: furniture.description,
      price: furniture.prix?.toString(),
      location: furniture.adresse,
      commodites: [],
      pieces: [],
      thumbnailUrl: thumbnailUrl as String?,
      furnitureType: furniture.type,
      furnitureCategory: furniture.category,
      furnitureEtat: furniture.etat,
      furnitureColors: colors,
    );
  }
}

/// Onglet "Caractéristiques" pour les meubles (furniture).
/// Affiche type, category, etat et couleurs.
class _FurnitureCaracteristiques extends StatelessWidget {
  const _FurnitureCaracteristiques({required this.data});

  final ReservationSheetData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne type + état
          Row(
            children: [
              if (data.furnitureType != null && data.furnitureType!.isNotEmpty)
                _CaracChip(
                    label: data.furnitureType!, icon: Icons.category_outlined),
              if (data.furnitureType != null && data.furnitureEtat != null)
                const SizedBox(width: 8),
              if (data.furnitureEtat != null && data.furnitureEtat!.isNotEmpty)
                _CaracChip(
                    label: data.furnitureEtat!, icon: Icons.info_outline),
            ],
          ),

          if (data.furnitureCategory != null &&
              data.furnitureCategory!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CaracChip(
                label: data.furnitureCategory!, icon: Icons.label_outline),
          ],

          // Couleurs
          if (data.furnitureColors.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Couleurs',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: data.furnitureColors
                  .map((color) => _ColorChip(label: color))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Chip pour une caractéristique (type, category, etat)
class _CaracChip extends StatelessWidget {
  const _CaracChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.blue4227DE),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip pour une couleur
class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
