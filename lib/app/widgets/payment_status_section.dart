import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/status_chip.dart';

class PaymentStatusSection extends StatefulWidget {
  const PaymentStatusSection({super.key, required this.demandeVisitModel});
  final DemandeVisiteModel demandeVisitModel;
  @override
  State<PaymentStatusSection> createState() => _PaymentStatusSectionState();
}

class _PaymentStatusSectionState extends State<PaymentStatusSection> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ListTile(
        tileColor: Colors.white,
        trailing: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 15,
          child: Icon(
            FontAwesomeIcons.moneyBillWave.data,
            color: Utils.getServiceStatusColor(
                widget.demandeVisitModel.statusFacture.toString()),
          ),
        ),
        horizontalTitleGap: 3,
        dense: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statut de paiement :'),
            StatusChip(
                status: widget.demandeVisitModel.statusFacture.toString(),
                text: widget.demandeVisitModel.statusFacture.toString())
          ],
        ),
      ),
    );
  }
}
