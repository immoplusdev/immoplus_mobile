import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static Color primary = HexColor("#006FFD"); // HexColor('#2172cb');
  static Color noSelected = CupertinoColors.inactiveGray;
  static Color primaryLite = Color.fromARGB(255, 234, 244, 254);
  static Color scafold = const Color.fromARGB(255, 238, 247, 255);

  static Color whiteBackground = const Color.fromARGB(
      255, 248, 253, 254); //Color.fromARGB(255, 255, 254, 250);
  static Color scaffoldBackgroundColor = Color(0xff121224);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color lightBlue = Color(0xff2072ca);
}
