import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/svgs_icons.dart';

class DetailEstateAmentities extends StatelessWidget {
  const DetailEstateAmentities({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return SizedBox(
            height: 30,
            child: ListTile(
              dense: true,

              //padding: EdgeInsets.only(left: 10),
              leading: SvgPicture.asset(
                SVGMap.map[bienImmobilier.amentities[index].icon] ?? '',
                height: 15,
                width: 15,
              ),
              //  Icon(
              //   String2Icon.getIconDataFromString(
              //           productDetailModel.commodites![index].icon ?? 'home') ??
              //       Icons.home_filled,
              //   size: 20,
              //   color: Colors.grey.shade700,
              // ),
              minLeadingWidth: 2,
              title: Text(bienImmobilier.amentities[index].text),
            ),
          );
        },
        childCount: bienImmobilier.amentities.length,
      ),
    );
  }
}
