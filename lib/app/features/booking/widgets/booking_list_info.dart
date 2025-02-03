import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingListInfo extends StatelessWidget {
  const BookingListInfo({
    super.key,
    required this.title,
    required this.info,
  });
  final String title;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(title),
        trailing: Text(
          info,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
