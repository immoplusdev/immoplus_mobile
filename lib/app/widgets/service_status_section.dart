import 'package:flutter/material.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/status_chip.dart';

class ServiceStatusSection extends StatelessWidget {
  const ServiceStatusSection({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: Colors.white,
      trailing: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Utils.getServiceStatusIcon(status),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statut du service :",
          ),
          StatusChip(
            status: status,
            text: Utils.getServiceStatus(status),
          )
        ],
      ),
    );
  }
}
