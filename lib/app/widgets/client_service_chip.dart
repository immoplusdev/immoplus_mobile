import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientServiceChip extends StatelessWidget {
  const ClientServiceChip({super.key});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      onPressed: () {
        // ContactUtils(productDetailModel: ProductDetailModel())
        //     .showDialog(context: context);
      },
      backgroundColor: Colors.white,
      avatar: Icon(
        FontAwesomeIcons.headset,
        color: Colors.black,
        size: 15,
      ),
      elevation: 1,
      labelPadding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(
        "Service client",
        style: GoogleFonts.inter(fontSize: 12),
      ),
    );
  }
}
