import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//views/privacyPolicy
class CustomTile extends StatelessWidget {
  CustomTile({Key? key, required this.title, this.target, this.leading})
      : super(key: key);
  final String title;
  final Widget? target;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      horizontalTitleGap: 0,
      title: Text(
        title,
      ),
      //titleTextStyle: GoogleFonts.inter(fontSize: 12, color: Colors.black),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => target!,
            ));
      },
    );
  }
}
