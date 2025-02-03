import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialNetworkButton extends StatelessWidget {
  const SocialNetworkButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final Widget icon;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: onTap,
        //tileColor: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey)),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: icon,
        ),
        title: Text(title),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        titleTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
        trailing: const Icon(
          FontAwesomeIcons.circleArrowRight,
          size: 20,
        ),
      ),
    );
  }
}
