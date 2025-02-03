import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/svgs_icons.dart';

class DetailLogmentAmentities extends StatelessWidget {
  const DetailLogmentAmentities({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;

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
                SVGMap.map[residenceModel.commodites[index].icon] ?? '',
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
              title: Text(residenceModel.commodites[index].text),
            ),
          );
        },
        childCount: (residenceModel.commodites.length > 4)
            ? 4
            : residenceModel.commodites.length,
      ),
    );
  }
}
