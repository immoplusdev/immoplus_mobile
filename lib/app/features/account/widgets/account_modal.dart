// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../logic/bloc/account_bloc.dart';

// void showMadalAccount(BuildContext context) {
//   showModalBottomSheet<void>(
//     isDismissible: false,
//     isScrollControlled: false,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30), topRight: Radius.circular(30))),
//     backgroundColor: Colors.white,
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         padding: const EdgeInsets.only(top: 1),
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30), topRight: Radius.circular(30))),
//         height: MediaQuery.of(context).size.height - 250,
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             automaticallyImplyLeading: false,
//             actions: [
//               IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.cancel,
//                   color: Theme.of(context).colorScheme.onSecondary,
//                 ),
//               )
//             ],
//             elevation: 0,
//           ),
//           body: SingleChildScrollView(
//               child: BlocBuilder<AccountBloc, AccountState>(
//             builder: (context, state) {
//               return (state is AccounReadyState)
//                   ? Container(
//                       //color: Colors.amber,
//                       width: double.infinity,
//                       height: 300,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             (state.status)
//                                 ? Icons.check_rounded
//                                 : Icons.report_problem_rounded,
//                             size: 100,
//                             color: (state.status)
//                                 ? Color.fromARGB(255, 81, 150, 92)
//                                 : Colors.redAccent,
//                           ),
//                           Text(
//                             (state.status)
//                                 ? "Opperation réussit"
//                                 : "Opperation échoué",
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: (state.status)
//                                   ? Color.fromARGB(255, 81, 150, 92)
//                                   : Colors.redAccent,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           (state.status)
//                               ? CustomButtom(
//                                   text: 'Continuer',
//                                   onClick: () {
//                                     int count = 0;
//                                     Navigator.of(context)
//                                         .popUntil((_) => count++ >= 2);
//                                   },
//                                 )
//                               : CustomButtom(
//                                   text: 'Reéssayer',
//                                   onClick: () {
//                                     Navigator.pop(context);
//                                   },
//                                 )
//                         ],
//                       ),
//                     )
//                   : (state is AccountPendingState)
//                       ? Container(
//                           //color: Colors.red,
//                           //width: double.infinity,
//                           height: 300,
//                           child: Center(
//                             child: CupertinoActivityIndicator(
//                               color: Theme.of(context).colorScheme.onSecondary,
//                               radius: 20,
//                             ),
//                           ),
//                         )
//                       : Container();
//             },
//           )),
//         ),
//       );
//     },
//   );
// }
