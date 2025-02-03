import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImmoIcons {
  compte,
  historique,
  home,
  location,
  loupe,
  meubles,
  panier,
  resi,
  service,
  terrain,
  visua,
  recent,
  coeur,
  moving,
  coeur1,
  coeur2,
  map,
  search,
  marker,
}

class ImmoIcon extends StatelessWidget {
  const ImmoIcon(this.icon, {super.key, this.size, this.color});
  final ImmoIcons icon;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svgs/icons/${icon.name}.svg',
      height: size,
      width: size,
      color: color,
    );
  }
}
