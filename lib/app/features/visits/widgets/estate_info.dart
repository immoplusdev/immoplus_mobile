import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/utils.dart';

class EstateInfo extends StatelessWidget {
  const EstateInfo({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      tileColor: CupertinoColors.tertiarySystemFill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: const CircleAvatar(
          //backgroundImage: Utils.getImage(id: bienImmobilierModel.images.first),
          ),
      title: Text(bienImmobilierModel.nom ?? 'no name'),
      subtitle: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: Utils.formatCurrency(bienImmobilierModel.prix),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700)),
        TextSpan(
            text: ' Par mois', style: TextStyle(color: Colors.grey.shade600))
      ])),
    );
  }
}
