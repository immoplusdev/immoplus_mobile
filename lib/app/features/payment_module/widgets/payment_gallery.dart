import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';

/// Galerie : grande photo avec compteur en bas à droite et jusqu'à deux
/// miniatures à droite. Taper une miniature la passe en grande photo.
class PaymentGallery extends StatefulWidget {
  const PaymentGallery({super.key, required this.imageIds, this.height = 160});

  final List<String> imageIds;
  final double height;

  @override
  State<PaymentGallery> createState() => _PaymentGalleryState();
}

class _PaymentGalleryState extends State<PaymentGallery> {
  static const _gap = 6.0;
  static final _radius = BorderRadius.circular(20);

  int _mainIndex = 0;

  Widget _image(String id) {
    return ClipRRect(
      borderRadius: _radius,
      child: CachedNetworkImage(
        imageUrl: Utils.getImagePath(id: id),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, __) => Container(color: AppColors.gray200),
        errorWidget: (_, __, ___) => Container(color: AppColors.gray200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ids = widget.imageIds;
    if (ids.isEmpty) return const SizedBox.shrink();

    final main = _mainIndex.clamp(0, ids.length - 1);
    final others = [
      for (var i = 0; i < ids.length; i++)
        if (i != main) i,
    ].take(2).toList();

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            flex: 735,
            child: Stack(
              children: [
                Positioned.fill(child: _image(ids[main])),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${main + 1} / ${ids.length}',
                      style: AppTypography.font(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (others.isNotEmpty) ...[
            const SizedBox(width: _gap),
            Expanded(
              flex: 370,
              child: Column(
                children: [
                  for (var n = 0; n < others.length; n++) ...[
                    if (n > 0) const SizedBox(height: _gap),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _mainIndex = others[n]),
                        child: _image(ids[others[n]]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
