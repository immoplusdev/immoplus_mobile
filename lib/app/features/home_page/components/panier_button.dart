// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:immoplus/constantes/immo_icons.dart';
// import 'package:immoplus/utils/local_storagre.dart';

// class PannierButton extends StatelessWidget {
//   const PannierButton({super.key, required this.onSearchEnd});
//   final void Function() onSearchEnd;
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: LocalStorage().getProduct(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data!.isEmpty) {
//               onSearchEnd();
//             }
//             return FloatingActionButton(
//               elevation: 5,
//               backgroundColor: Colors.white,
//               onPressed: () {
//                 if (snapshot.data!.isNotEmpty) {
//                   context.push('/panier');
//                 }
//               },
//               child: Badge(
//                 isLabelVisible: snapshot.data!.isNotEmpty,
//                 label: Text(
//                   '${snapshot.data!.length}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   padding: EdgeInsets.all(8),
//                   child: ImmoIcon(
//                     ImmoIcons.panier,
//                     size: 10,
//                   ),
//                 ),
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             onSearchEnd();
//           }

//           return Container(
//             width: 40,
//             height: 40,
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(60),
//             ),
//             child: ImmoIcon(
//               ImmoIcons.panier,
//               size: 10,
//             ),
//           );
//         });
//   }
// }
