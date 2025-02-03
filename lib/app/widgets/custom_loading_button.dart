import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class CustomLoadingButtom extends StatelessWidget {
  const CustomLoadingButtom({
    super.key,
    required this.text,
    this.onClick,
    this.clickable = true,
    this.color,
    this.textColor,
    required this.isLoading,
  });
  final String text;
  final void Function()? onClick;
  final Color? color;
  final Color? textColor;
  final bool isLoading;

  final bool clickable;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        //padding: EdgeInsets.only(left: 30, right: 30),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            disabledBackgroundColor: Colors.blue.shade100,
            backgroundColor: (clickable)
                ? (color == null)
                    ? AppColors.primary
                    : color
                : Colors.grey[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: (isLoading) ? null : onClick,
          child: (isLoading)
              ? const CupertinoActivityIndicator(
                  radius: 16,
                )
              : Text(
                  text,
                  style: GoogleFonts.inter(
                      color: Colors
                          .white, //(textColor == null) ? textColor : null,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
        ),
      ),
    );
  }
}
