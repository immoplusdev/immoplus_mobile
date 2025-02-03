// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:immoplus/views/appli/appli.dart';

// class SomethingWrong extends StatelessWidget {
//   const SomethingWrong({super.key, required this.erreur});
//   final String erreur;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         //backgroundColor: Colors.red,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.info,
//               size: 50,
//               color: Colors.grey,
//             ),
//             Center(
//               child: Text(erreur),
//             ),
//             SizedBox(
//               height: 100,
//             ),
//             ElevatedButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Application(),
//                     )),
//                 child: Text('forcer'))
//           ],
//         ),
//       ),
//     );
//   }
// }
