import 'package:flutter/material.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile(
      {super.key, required this.title, required this.trailing});
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Text(trailing,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
