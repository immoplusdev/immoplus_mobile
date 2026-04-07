import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/local/fovorite_model.dart';
import 'package:immoplus/app/extensions/string_extension.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_chip.dart';
import 'package:shimmer/shimmer.dart';

// White Luxury — cartes claires, pas de fond noir
const Color _kSurface = Color(0xFFF9FAFB);
const Color _kGold = Color(0xFF2744de);
const Color _kTextPrimary = Color(0xFF0A1128);
const Color _kTextSecondary = Color(0xFF6B7280);
const Color _kSeparator = Color(0xFFE5E7EB);
const Color _kTagBg = Color(0x26C9A84C); // rgba(201, 168, 76, 0.15)

class FavoriteCard extends StatefulWidget {
  final bool isSelect;
  const FavoriteCard({
    super.key,
    required this.favotiteModel,
    required this.isSelect,
  });
  final FovoriteModel favotiteModel;

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  static const double _imageWidth = 140;
  static const double _imageHeight = 160;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Constantes.tempPage = Utils.getCurrentLocation();
        context.push(widget.favotiteModel.destination!);
      },
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.05), width: 1),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.06),
          //     blurRadius: 24,
          //     offset: const Offset(0, 4),
          //     spreadRadius: 0,
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.favotiteModel.name?.capitalizeWords() ?? '',
                    maxLines: 3,
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _kTextPrimary,
                      height: 1.25,
                    ),
                  ),
                  const Gap(8),
                  _buildRating(widget.favotiteModel.itemScore ?? 0.0),
                  const Gap(8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: _kTextSecondary,
                      ),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          widget.favotiteModel.adress ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _kTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      width: _imageWidth,
      height: _imageHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.favotiteModel.images != null &&
                widget.favotiteModel.images!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: Utils.getImagePath(
                  id: widget.favotiteModel.images!.first,
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: _kSeparator,
                  highlightColor: _kSurface,
                  period: const Duration(milliseconds: 500),
                  child: Container(color: _kSeparator),
                ),
                errorWidget: (context, url, error) => Container(
                  color: _kSeparator,
                  child: Icon(
                    FontAwesomeIcons.images,
                    size: 36,
                    color: _kTextSecondary,
                  ),
                ),
                fit: BoxFit.cover,
              )
            else
              Container(
                color: _kSeparator,
                child: Icon(
                  FontAwesomeIcons.images,
                  size: 36,
                  color: _kTextSecondary,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: CustomChip(
                label: widget.favotiteModel.type!,
                labelStyle: Theme.of(context).textTheme.labelMedium,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tag type (maison/villa): pill, gold border, gold text, bg transparent (rgba gold 0.15).
  Widget _buildTypeTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: _kGold, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Rating: star #C9A84C, 14px weight 600.
  Widget _buildRating(num? score) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          FontAwesomeIcons.solidStar,
          color: Colors.orange,
          size: 14,
        ),
        const Gap(4),
        Text(
          score?.toStringAsFixed(1) ?? '0.0',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _kTextSecondary,
          ),
        ),
      ],
    );
  }
}
