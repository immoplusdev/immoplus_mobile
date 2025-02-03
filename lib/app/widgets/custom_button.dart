import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButtom extends StatelessWidget {
  const CustomButtom({
    super.key,
    required this.text,
    this.onClick,
    this.clickable = true,
    this.color,
    this.textColor,
    this.fontSize,
    this.elevation,
    this.isLoading = false,
  });
  final String text;
  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;
  final bool clickable;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        //padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation ?? 0,
            backgroundColor: (clickable)
                ? (color == null)
                    ? HexColor('#2172cb')
                    : color
                : Colors.grey[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: isLoading
              ? null
              : (clickable)
                  ? onClick
                  : null,
          child: isLoading
              ? CupertinoActivityIndicator()
              : Text(
                  text,
                  style: GoogleFonts.inter(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
