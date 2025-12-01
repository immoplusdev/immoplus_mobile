import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat formatDate = DateFormat('d MMMM yyyy');

class DateCreationWidget extends StatelessWidget {
  final DateTime? createdAt;
  final String? title;

  const DateCreationWidget({super.key, this.createdAt, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "${title ?? "Créé le"} ${formatDate.format(createdAt ?? DateTime.now())}",
      ),
    );
  }
}
