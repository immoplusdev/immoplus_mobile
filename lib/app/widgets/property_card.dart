import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/monogram_avatar.dart';

/// Bouton "Book Now" réutilisable.
class BookNowButton extends StatelessWidget {
  const BookNowButton({
    super.key,
    this.onPressed,
    this.label = 'Reserver maintenant',
    this.compact = false,
  });

  final VoidCallback? onPressed;
  final String label;

  /// Mode compact : padding et police réduits (pour bottom sheet).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical:  14,
          horizontal: 22,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize:  16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Action button displayed in the bottom row of [PropertyCard].
class PropertyCardAction {
  const PropertyCardAction({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;
}

/// Reusable property listing card widget.
///
/// Displays a property image with rating, key info (title, amenities,
/// location, price) and a row of quick-action buttons.
///
/// Usage:
/// ```dart
/// PropertyCard(
///   title: 'Black Modern Apartment',
///   price: '\$1,250/mo',
///   imageUrl: '...',
///   beds: 3, baths: 2, sqm: 1050,
///   location: 'Florida, USA',
///   rating: 4.5,
///   isVerified: true,
///   activeActionIndex: 1,
/// )
/// ```
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.beds,
    this.baths,
    this.sqm,
    this.location,
    this.isVerified = false,
    this.onBookNow,
    this.lat,
    this.lng,
    this.imageWidth = 92,
    this.imageHeight = 60,
    this.mapHeight = 150,
  })  : assert(mapHeight > 0, 'mapHeight doit etre > 0'),
        assert(imageWidth > 0, 'imageWidth doit etre > 0'),
        assert(imageHeight > 0, 'imageHeight doit etre > 0');

  final String title;
  final String price;
  final String? imageUrl;
  final int? beds;
  final int? baths;
  final double? sqm;
  final String? location;
  final bool isVerified;
  final VoidCallback? onBookNow;

  /// Coordonnées réelles pour la carte. Si null, utilise des coords de démo.
  final double? lat;
  final double? lng;
  final double imageWidth;
  final double imageHeight;
  final double mapHeight;

  /// Index of the highlighted action button (0-based).
  // final int activeActionIndex;

  // /// List of action buttons in the bottom row.
  // /// Defaults to the 4 standard actions if empty.
  // final List<PropertyCardAction> actions;

  // static const _defaultActions = [
  //   PropertyCardAction(icon: Iconsax.home),
  //   PropertyCardAction(icon: Iconsax.discover),
  //   PropertyCardAction(icon: Iconsax.heart),
  //   PropertyCardAction(icon: Iconsax.setting_4),
  // ];

  @override
  Widget build(BuildContext context) {
    // final effectiveActions = actions.isEmpty ? _defaultActions : actions;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     _PropertyImage(
          //       imageUrl: imageUrl,
          //       width: imageWidth,
          //       height: imageHeight,
          //       // rating: rating,
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: _PropertyInfo(
          //         title: title,
          //         price: price,
          //         beds: beds,
          //         baths: baths,
          //         sqm: sqm,
          //         location: location,
          //         isVerified: isVerified,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 16),

          // const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),
          // const SizedBox(height: 12),
          // _ActionRow(
          //   actions: effectiveActions,
          //   activeIndex: activeActionIndex,
          // ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets (private)
// ---------------------------------------------------------------------------

/// Carte mini style (same UI as DetailLogmentMap). Fausses données pour l'instant.
/// Widget réutilisable : carte Google Map avec marqueur personnalisé et image.
///
/// Peut être utilisé partout dans le projet, pas seulement pour PropertyCard.
///
/// Exemple:
/// ```dart
/// PropertyMapCard(
///   imageUrl: 'https://...',
///   lat: 5.403,
///   lng: -3.95,
///   height: 180,
/// )
/// ```
class PropertyMapCard extends StatefulWidget {
  const PropertyMapCard({
    Key? key,
    this.imageUrl,
    this.lat,
    this.lng,
    this.height = 280,
    this.borderRadius = 20,
    this.markerAsset = 'assets/svgs/icons/markers.svg',
  })  : assert(height > 0, 'height doit être > 0'),
        super(key: key);

  final String? imageUrl;
  final double? lat;
  final double? lng;
  final double height;
  final double borderRadius;
  final String markerAsset;

  @override
  State<PropertyMapCard> createState() => _PropertyMapCardState();
}

class _PropertyMapCardState extends State<PropertyMapCard> {
  static const double _defaultLat = 5.403045654441625;
  static const double _defaultLng = -3.9564392567144426;
  static const String _fakeImageUrl =
      'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=100&q=80';

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageUrl ?? _fakeImageUrl;
    final lat = widget.lat ?? _defaultLat;
    final lng = widget.lng ?? _defaultLng;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 15.4,
              ),
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (_) {},
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      widget.markerAsset,
                      height: 80,
                    ),
                    Positioned(
                      left: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    super.key,
    this.imageUrl,
    this.rating,
    this.width = 92,
    this.height = 114,
  })  : assert(width > 0, 'width doit être > 0'),
        assert(height > 0, 'height doit être > 0');

  final String? imageUrl;
  final double? rating;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: width,
              height: height,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFFEEEEEE)),
                      errorWidget: (_, __, ___) => _ImagePlaceholder(),
                    )
                  : _ImagePlaceholder(),
            ),
          ),
          if (rating != null)
            Positioned(
              bottom: 7,
              left: 7,
              child: _RatingBadge(rating: rating!),
            ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: const Center(
        child: Icon(Iconsax.building, color: Color(0xFFBBBBBB), size: 32),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, color: Color(0xFFFFD700), size: 13),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyInfo extends StatelessWidget {
  const PropertyInfo({
    super.key,
    required this.title,
    this.location,
    // this.avatarUrl,
    // this.avatarName,
  });

  final String title;
  final String? location;

  // /// URL de l'avatar (auteur, propriétaire…).
  // final String? avatarUrl;

  // /// Nom pour le monogramme si pas d'avatar.
  // final String? avatarName;

  @override
  Widget build(BuildContext context) {
    // final monogramName = avatarName ?? title;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // MonogramAvatar(
        //   name: monogramName,
        //   size: 28,
        //   imageUrl: avatarUrl,
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.capitalizeWords(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),
              if (location != null && location!.isNotEmpty)
                LocationRow(location: location!),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.close_circle,
            size: 24,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

/// Donnée commodité (API: { "text": "WiFi", "icon": "wifi" }).
class CommoditeData {
  const CommoditeData({required this.text, required this.icon});
  final String text;
  final String icon;
}

/// Donnée pièce (API: { "nom": "Chambre", "nombre": 1, "value": "15 m²" }).
class PieceData {
  const PieceData({
    required this.nom,
    required this.nombre,
    this.value,
  });
  final String nom;
  final int nombre;

  /// Valeur texte optionnelle (ex: "15 m²", "2").
  final String? value;
}

/// Couleurs par type de commodité.
const _commoditeColors = {
  'wifi': Color(0xFFFF5733),
  'ac': Color(0xFF33FFBD),
  'parking': Color(0xFFFFBD33),
};

/// Icônes Iconsax par type de commodité.
IconData _commoditeIcon(String iconKey) {
  switch (iconKey.toLowerCase()) {
    case 'wifi':
      return Iconsax.wifi;
    case 'ac':
      return Iconsax.wind_2;
    case 'parking':
      return Iconsax.car;
    default:
      return Iconsax.element_3;
  }
}

/// Couleurs par type de pièce.
const _pieceColors = {
  'chambre': Color(0xFF2744DE),
  'salon': Color(0xFFB833FF),
  'cuisine': Color(0xFFFF3385),
};

/// Icônes Iconsax par type de pièce.
IconData _pieceIcon(String nom) {
  final lower = nom.toLowerCase();
  if (lower.contains('chambre')) return Iconsax.home_2;
  if (lower.contains('salon')) return Iconsax.home;
  if (lower.contains('cuisine')) return Iconsax.cake;
  return Iconsax.building_4;
}

/// Commodités (WiFi, Climatisation, Parking) — format API.
///
/// ```dart
/// PropertyCommodites(commodites: [
///   CommoditeData(text: 'WiFi', icon: 'wifi'),
///   CommoditeData(text: 'Climatisation', icon: 'ac'),
///   CommoditeData(text: 'Parking', icon: 'parking'),
/// ])
/// ```
class PropertyCommodites extends StatelessWidget {
  const PropertyCommodites({
    super.key,
    required this.commodites,
    this.iconSize = 14,
    this.fontSize = 12,
    this.pillStyle = true,
  });

  final List<CommoditeData> commodites;
  final double iconSize;
  final double fontSize;
  final bool pillStyle;

  @override
  Widget build(BuildContext context) {
    if (commodites.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: commodites.map((c) {
        final color = _commoditeColors[c.icon.toLowerCase()] ?? AppColors.primary;
        return _CommoditeChip(
          icon: _commoditeIcon(c.icon),
          label: c.text,
          color: color,
          iconSize: iconSize,
          fontSize: fontSize,
          pillStyle: pillStyle,
        );
      }).toList(),
    );
  }
}

class _CommoditeChip extends StatelessWidget {
  const _CommoditeChip({
    required this.icon,
    required this.label,
    required this.color,
    this.iconSize = 14,
    this.fontSize = 12,
    this.pillStyle = true,
  });

  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;
  final double fontSize;
  final bool pillStyle;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: color),
        SizedBox(width: pillStyle ? 6 : 3),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
    if (pillStyle) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: content,
      );
    }
    return content;
  }
}

/// Données pour un chip d'équipement personnalisé (legacy).
class AmenityData {
  const AmenityData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Pièces (Chambre, Salon, Cuisine) en cartes 115×115 — format API.
///
/// ```dart
/// PropertyPieces(pieces: [
///   PieceData(nom: 'Chambre', nombre: 1),
///   PieceData(nom: 'Salon', nombre: 1),
///   PieceData(nom: 'Cuisine', nombre: 1),
/// ])
/// ```
class PropertyPieces extends StatelessWidget {
  const PropertyPieces({
    super.key,
    required this.pieces,
    this.iconSize = 28,
    this.fontSize = 12,
    this.pieceWidth = 100,
    this.pieceHeight = 90,
    this.borderRadius = 20,
  });

  final List<PieceData> pieces;
  final double iconSize;
  final double fontSize;
  final double pieceWidth;
  final double pieceHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (pieces.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: pieces.map((p) {
        Color color = AppColors.primary;
        for (final e in _pieceColors.entries) {
          if (p.nom.toLowerCase().contains(e.key)) {
            color = e.value;
            break;
          }
        }
        return _PieceCard(
          icon: _pieceIcon(p.nom),
          label: '${p.nombre} ${p.nom} ',
          color: color,
          iconSize: iconSize,
          fontSize: fontSize,
          width: pieceWidth,
          height: pieceHeight,
          borderRadius: borderRadius,
        );
      }).toList(),
    );
  }
}

class _PieceCard extends StatelessWidget {
  const _PieceCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconSize,
    required this.fontSize,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;
  final double fontSize;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: color),

          SizedBox(height: fontSize * 0.5),
          
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationRow extends StatelessWidget {
  const LocationRow({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Iconsax.location, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Badge « Verified ✓ » réutilisable.
///
/// ```dart
/// VerifiedBadge()
/// VerifiedBadge(label: 'Certifié')
/// ```
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.label = 'Verified', this.iconSize = 15});

  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(
        //     fontSize: 12,
        //     color: Colors.black,
        //     fontWeight: FontWeight.normal,
        //   ),
        // ),
        // const SizedBox(width: 4),
        Icon(Iconsax.verify, color: AppColors.primary, size: iconSize),
      ],
    );
  }
}

/// Affichage du prix avec séparateur « /mo » réutilisable.
/// Pilule stylisée avec accent primaire.
///
/// ```dart
/// PropertyPrice(price: '150 000 FCFA')
/// PropertyPrice(price: '150 000 FCFA/mo')  // le "/mo" est auto-séparé
/// PropertyPrice(price: '1 250 000', period: 'an')
/// ```
class PropertyPrice extends StatelessWidget {
  const PropertyPrice({
    super.key,
    required this.price,
    this.period = 'mo',
    this.priceFontSize = 13,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.pillRadius = 24.0,
    this.showIcon = false,
  });

  final String price;
  final String period;
  final double priceFontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? accentColor;
  final EdgeInsetsGeometry padding;
  final double pillRadius;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final displayPrice = price
        .replaceFirst(RegExp(r'/\s*mo(is)?\s*$', caseSensitive: false), '')
        .trim();

    final bg = backgroundColor ?? AppColors.primaryLite;
    final accent = accentColor ?? AppColors.primary;
    final fg = textColor ?? const Color(0xFF1A1A2E);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(pillRadius),
        border: Border.all(
          color: accent.withValues(alpha: 0.25),
          width: 1,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: accent.withValues(alpha: 0.08),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIcon) ...[
            Icon(
              Iconsax.dollar_circle,
              size: priceFontSize + 2,
              color: accent,
            ),
            SizedBox(width: priceFontSize * 0.5),
          ],
          Text(
            displayPrice,
            style: TextStyle(
              fontSize: priceFontSize,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: 0.2,
            ),
          ),
          if (period.isNotEmpty) ...[
            Text(
              ' / ',
              style: TextStyle(
                fontSize: priceFontSize - 1,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.5),
              ),
            ),
            Text(
              period,
              style: TextStyle(
                fontSize: priceFontSize - 2,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.65),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// class _ActionRow extends StatelessWidget {
//   const _ActionRow({required this.actions, required this.activeIndex});

//   final List<PropertyCardAction> actions;
//   final int activeIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: List.generate(actions.length, (i) {
//         final action = actions[i];
//         final isActive = i == activeIndex;
//         return GestureDetector(
//           onTap: action.onTap,
//           child: Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               color: isActive ? AppColors.primary : const Color(0xFFF4F4F4),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               action.icon,
//               size: 20,
//               color: isActive ? Colors.white : Colors.grey.shade600,
//             ),
//           ),
//         );
//       }),
