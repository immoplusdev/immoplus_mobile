import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat formatDate = DateFormat('d MMMM yyyy');

class DateCreationWidget extends StatelessWidget {
  final DateTime? createdAt;
  const DateCreationWidget({super.key, this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "Créé le ${formatDate.format(createdAt ?? DateTime.now())}",
      ),
    );
  }
}
