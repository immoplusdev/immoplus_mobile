// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class HomeBody extends StatelessWidget {
//   HomeBody({
//     super.key,
//     required this.datas,
//     required this.isLoading,
//     required this.loadingRequest,
//     required this.onRefresh,
//     required this.isLogment,
//   });
//   List<Model> datas;
//   bool isLoading;
//   bool loadingRequest;
//   Future<void> Function() onRefresh;
//   bool isLogment;
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => onRefresh(),
//       child: ListView.builder(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         //controller: _scrollController,
//         padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//         itemBuilder: (context, index) {
//           if (isLoading) {
//             return SizedBox(
//                 //height: 600,
//                 child: Column(
//               children: [
//                 for (int _i = 0; _i < 5; _i++) LoadProductCard(),
//               ],
//             ));
//           }
//           if (index < datas.length) {
//             return isLogment
//                 ? LogmentCard(
//                     logment: datas[index] as LogmentModel,
//                   )
//                 : ProductCard(
//                     product: datas[index] as ProductModel,
//                   );
//           }
//           if (loadingRequest) {
//             return SizedBox(
//                 //height: 600,
//                 child: Column(
//               children: [
//                 for (int _i = 0; _i < 5; _i++) LoadProductCard(),
//               ],
//             ));
//           }
//           // Display items in the list

//           // Show a loading indicator at the end of the list

//           // If there are no more items to load
//           return Center(
//             child: Icon(
//               CupertinoIcons.chevron_down_circle_fill,
//               color: CupertinoColors.systemFill,
//             ),
//           );
//         },
//         itemCount: datas.length + 1,
//       ),
//     );
//   }
// }
