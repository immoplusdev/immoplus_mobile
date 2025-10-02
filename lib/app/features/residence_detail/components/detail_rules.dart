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
        // ListTile(
        //   tileColor: AppColors.scafold,
        //   horizontalTitleGap: 0,
        //   leading: Icon(FontAwesomeIcons.fileLines),
        //   title: Padding(
        //     padding: const EdgeInsets.only(bottom: 10),
        //     child: Text("Règles supplémentaires"),
        //   ),
        //   titleTextStyle: GoogleFonts.inter(
        //       fontWeight: FontWeight.bold, color: Colors.black),
        //   subtitle: Container(
        //     padding: EdgeInsets.only(top: 5),
        //     color: Colors.white,
        //     height: 100,
        //     child: Markdown(
        //       physics: NeverScrollableScrollPhysics(),
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       data: logmentModel.reglesSupplementaires ??
        //           '', //state.finishData.data!.description!,
        //       //styleSheet: MarkdownStyleSheet(),
        //     ),
        //   ),
        // ),
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20),
        //     child: OutlinedButton(
        //         onPressed: () {
        //           showModalBottomSheet<void>(
        //             context: context,
        //             isScrollControlled: true,
        //             useSafeArea: true,
        //             backgroundColor: Colors.white,
        //             showDragHandle: true,
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(20)),
        //             builder: (BuildContext context) {
        //               return Container(
        //                 padding: EdgeInsets.only(top: 10),
        //                 height: MediaQuery.of(context).size.height * 0.8,
        //                 color: Colors.transparent,
        //                 child: Scaffold(
        //                   backgroundColor: Colors.transparent,
        //                   // appBar: AppBar(
        //                   //   title: Text('Règle de la maison'),
        //                   //   backgroundColor: Colors.transparent,
        //                   //   centerTitle: false,
        //                   //   toolbarHeight: 30,
        //                   //   automaticallyImplyLeading: false,
        //                   //   actions: [
        //                   //     IconButton(
        //                   //       color: AppColors.primary,
        //                   //       onPressed: () => context.pop(),
        //                   //       icon: Icon(CupertinoIcons.xmark_circle_fill),
        //                   //     ),
        //                   //   ],
        //                   // ),
        //                   body: Markdown(
        //                     padding: EdgeInsets.symmetric(horizontal: 10),
        //                     data: logmentModel
        //                         .reglesSupplementaires!, //state.finishData.data!.description!,
        //                     //styleSheet: MarkdownStyleSheet(),
        //                   ),
        //                 ),
        //               );
        //             },
        //           );
        //         },
        //         child: Text('Voir toute les règles de la maison')),
        //   ),
      ],
    ));
  }
}
