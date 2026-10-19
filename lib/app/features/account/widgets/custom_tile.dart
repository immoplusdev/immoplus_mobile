import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, required this.title, this.target, this.leading});
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
      trailing: const Icon(Icons.chevron_right),
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
