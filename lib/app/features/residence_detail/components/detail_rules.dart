import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

class DetailLogmentRules extends StatelessWidget {
  const DetailLogmentRules({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
      [
        SizedBox(
          child: ListTile(
            horizontalTitleGap: 0,
            leading: const Icon(Icons.access_time),
            title:
                Text("Heure d'arrivé à partir de: ${logmentModel.heureEntree}"),
          ),
        ),
        ListTile(
          horizontalTitleGap: 0,
          leading: const Icon(Icons.access_time),
          title: Text("Heure de départ : ${logmentModel.heureDepart}"),
        ),
        Visibility(
          visible: !logmentModel.animauxAutorises,
          child: const ListTile(
            horizontalTitleGap: 0,
            leading: Icon(Icons.pets),
            title: Text("Animaux interdit"),
          ),
        ),
        const Visibility(
          child: ListTile(
            horizontalTitleGap: 0,
            leading: Icon(CupertinoIcons.speaker_2),
            title: Text("Éviter nuisance sonore"),
          ),
        ),
      ],
    ));
  }
}
