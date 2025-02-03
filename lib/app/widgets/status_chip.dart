import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/utils.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.text, required this.status});
  final String text;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Chip(
      // color: WidgetStatePropertyAll(Utils.getServiceStatusColor(status)),
      autofocus: true,
      padding: EdgeInsets.zero,
      shape: StadiumBorder(
          side: BorderSide(color: Utils.getServiceStatusColor(status))),
      backgroundColor: Utils.getServiceStatusColor(status).withOpacity(0.2),
      label: Text(
        Utils.getServiceStatus(status),
        style: TextStyle(
          color: Utils.getServiceStatusColor(status),
        ),
      ),
    );
  }
}
