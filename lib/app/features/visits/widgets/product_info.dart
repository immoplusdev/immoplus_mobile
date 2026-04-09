import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/formular_utils.dart';
import 'package:immoplus/app/utils/utils.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final period = FormUtils.getPeriod(value: bienImmobilierModel.typeLocation);

    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: primaryColor.withOpacity(0.08),
        backgroundImage: Utils.getImage(id: bienImmobilierModel.images.first),
      ),
      title: Text(
        bienImmobilierModel.nom,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${bienImmobilierModel.prix} F',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            if (period != null && period.isNotEmpty)
              TextSpan(
                text: period,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}