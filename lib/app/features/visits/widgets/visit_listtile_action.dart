import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitListTileAction extends StatelessWidget {
  const VisitListTileAction({
    super.key,
    required this.title,
    required this.subTiltle,
    required this.onTap,
    required this.price,
    required this.backgroundImage,
  });
  final String title;
  final String subTiltle;
  final void Function()? onTap;
  final String price;
  final ImageProvider<Object>? backgroundImage;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //side: BorderSide(color: Colors.grey),
        ),
        onTap: onTap,
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: backgroundImage,
            ),
          ],
        ),
        isThreeLine: true,
        //dense: true,
        minVerticalPadding: 8,
        horizontalTitleGap: 4,
        minLeadingWidth: 5,
        title: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: '  $price Fcfa',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ))
        ])),
        titleTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: Colors.black,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey,
        ),
        subtitle: Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(subTiltle),
        ),
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.forward,
              size: 25,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
