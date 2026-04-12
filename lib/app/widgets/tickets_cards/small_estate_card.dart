import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class SmallEstateCard extends StatefulWidget {
  const SmallEstateCard({
    super.key,
    required this.bienImmobilier,
    this.closeTap,
    this.onCardTap,
    this.onShareTap,
  });
  final BienImmobilierModel bienImmobilier;
  final VoidCallback? closeTap;
  final VoidCallback? onCardTap;
  final VoidCallback? onShareTap;

  @override
  State<SmallEstateCard> createState() => _SmallEstateCardState();
}

class _SmallEstateCardState extends State<SmallEstateCard> {
  final favoriesUtils = getIt<FavoriesUtils>();
  final ValueNotifier<bool> _liked = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    favoriesUtils.isFavorite(widget.bienImmobilier.id).then((v) {
      _liked.value = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bien = widget.bienImmobilier;
    final price = CurrencyFormatter().format(bien.prix.toString());

    int countPiece(String name) {
      final match = bien.pieces
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
              // ── Image ──
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
                            id: bien.images.isNotEmpty
                                ? bien.images.first
                                : bien.miniatureId),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade100),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade100,
                          child: Icon(FontAwesomeIcons.images,
                              size: 32, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    // Badge type
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          bien.typeBienImmobilier,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Badge photos
                    if (bien.images.length > 1)
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
                            '${bien.images.length} photos',
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
                              favoriesUtils.addEstateToFavorites(bien);
                            } else {
                              favoriesUtils.deleteFavoriteByItemId(bien.id);
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

              // ── Contenu ──
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom + Prix
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bien.nom,
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
                                      bien.adresse.isNotEmpty
                                          ? bien.adresse
                                          : '${bien.commune ?? ''}, ${bien.ville ?? ''}',
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
                            Text(
                              bien.aLouer ? '/ mois' : '',
                              style: const TextStyle(
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

                    // Commodités
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

                    // Boutons CTA
                    Row(
                      children: [
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
                        _ActionIconButton(
                          icon: Icons.share_outlined,
                          onTap: widget.onShareTap,
                        ),
                        const SizedBox(width: 8),
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

        // Triangle pointer
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
  const _ActionIconButton({required this.icon, this.onTap});
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
