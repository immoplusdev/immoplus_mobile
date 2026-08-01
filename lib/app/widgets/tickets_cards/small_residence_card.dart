import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/services/share_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class SmallResidenceCard extends StatefulWidget {
  final VoidCallback? closeTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onNavigateTap;
  final Function(Rect?)? onShareTap;
  final VoidCallback? onCallTap;
  const SmallResidenceCard({
    super.key,
    required this.residenceModel,
    this.closeTap,
    this.onCardTap,
    this.onNavigateTap,
    this.onShareTap,
    this.onCallTap,
  });
  final ResidenceModel residenceModel;
  @override
  State<SmallResidenceCard> createState() => _SmallResidenceCardState();
}

class _SmallResidenceCardState extends State<SmallResidenceCard> {
  final favoriesUtils = getIt<FavoriesUtils>();
  final ValueNotifier<bool> _liked = ValueNotifier(false);
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    favoriesUtils.isFavorite(widget.residenceModel.id).then((v) {
      _liked.value = v;
    });
  }

  void _handleShareTap() {
    final origin = ShareService.getSharePositionFromKey(_shareButtonKey);
    widget.onShareTap?.call(origin);
  }

  @override
  Widget build(BuildContext context) {
    final residence = widget.residenceModel;
    final price =
        CurrencyFormatter().format(residence.prixReservation.toString());

    // Compter chambres, salles de bain, cuisines depuis les pièces
    int countPiece(String name) {
      final match = residence.pieces
          .where((p) => p.nom.toLowerCase().contains(name.toLowerCase()));
      if (match.isEmpty) return 0;
      return match.fold<int>(0, (sum, p) => sum + p.nombre);
    }

    final chambres = countPiece('Chambre');
    final sdb = countPiece('Salle de bain');
    final cuisines = countPiece('Cuisine');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Card principale ──
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE8E6F8),
              width: 0.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── SECTION 1 : Image ──
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: widget.onCardTap,
                      child: CachedNetworkImage(
                        imageUrl: Utils.getImagePath(
                            id: residence.images.isNotEmpty
                                ? residence.images.first
                                : residence.miniature),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade100),
                        memCacheWidth: 400,
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade100,
                          child: FaIcon(FontAwesomeIcons.images,
                              size: 32, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    // Badge photos
                    if (residence.images.length > 1)
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${residence.images.length} photos',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    // Bouton favori
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _liked,
                        builder: (_, liked, __) => GestureDetector(
                          onTap: () {
                            if (!liked) {
                              favoriesUtils.addResidenceToFavorites(residence);
                            } else {
                              favoriesUtils
                                  .deleteFavoriteByItemId(residence.id);
                            }
                            _liked.value = !liked;
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              liked
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              size: 12,
                              color:
                                  liked ? Colors.redAccent : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── SECTION 2 : Contenu ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BLOCK A — Nom + Prix
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                residence.nom,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded,
                                      size: 10, color: AppColors.primary),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      residence.adresse.isNotEmpty
                                          ? residence.adresse
                                          : '${residence.commune}, ${residence.ville}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Prix
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$price F',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              '/ nuit',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: Color(0xFFF0EFF8)),
                    ),

                    // BLOCK C — Commodités
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _AmenityItem(
                          icon: Icons.bed_outlined,
                          count: chambres > 0 ? chambres : 1,
                          label: 'Chambre',
                        ),
                        Container(
                            width: 0.5,
                            height: 22,
                            color: const Color(0xFFE8E6F8)),
                        _AmenityItem(
                          icon: Icons.bathtub_outlined,
                          count: sdb > 0 ? sdb : 1,
                          label: 'Salle de bain',
                        ),
                        Container(
                            width: 0.5,
                            height: 22,
                            color: const Color(0xFFE8E6F8)),
                        _AmenityItem(
                          icon: Icons.soup_kitchen_outlined,
                          count: cuisines > 0 ? cuisines : 1,
                          label: 'Cuisine',
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: Color(0xFFF0EFF8)),
                    ),

                    // BLOCK D — Boutons CTA
                    Row(
                      children: [
                        // Naviguer ici
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onCardTap,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Voir détails',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Partager
                        _ActionIconButton(
                          key: _shareButtonKey,
                          icon: Icons.share_outlined,
                          onTap: _handleShareTap,
                        ),
                        const SizedBox(width: 8),
                        // Fermer
                        _ActionIconButton(
                          icon: Icons.close_rounded,
                          onTap: widget.closeTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Triangle pointer vers le bas ──
        CustomPaint(
          size: const Size(16, 8),
          painter: _TrianglePainter(),
        ),
      ],
    );
  }
}

class _AmenityItem extends StatelessWidget {
  const _AmenityItem({
    required this.icon,
    required this.count,
    required this.label,
  });
  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({required this.icon, this.onTap, Key? key})
      : super(key: key);
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F6FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE8E6F8),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 15, color: AppColors.primary),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = const Color(0xFFE8E6F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
