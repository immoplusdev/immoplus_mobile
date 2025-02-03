// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:immoplus_pro/data/data.dart';
// import 'package:immoplus_pro/data/models/model.dart';
// import 'package:immoplus_pro/data/models/residence/residence_model.dart';
// import 'package:immoplus_pro/views/shared_widgets/shraed_widgets.dart';
// import 'package:shimmer/shimmer.dart';

// class SimilarLogmentSection extends StatefulWidget {
//   const SimilarLogmentSection({super.key});

//   @override
//   State<SimilarLogmentSection> createState() => _SimilarLogmentSectionState();
// }

// class _SimilarLogmentSectionState extends State<SimilarLogmentSection> {
//   BoxDecoration loadCardDecoration = BoxDecoration(
//     borderRadius: BorderRadius.circular(15),
//     color: Colors.red,
//   );
//   List<ResidenceModel> datas = [];
//   bool _isLoading = true;
//   getProducts() async {
//     datas = await Repository<ResidenceModel>(ResidenceModel()).fetchListData(
//         requestInfo: RequestInfo(method: METHOD.GET, path: '/items/products'),
//         context: context) as List<ResidenceModel>;
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return (_isLoading)
//         ? SizedBox(
//             height: 200,
//             child: Shimmer.fromColors(
//               period: Duration(milliseconds: 800),
//               baseColor: CupertinoColors.tertiarySystemFill,
//               highlightColor: Colors.grey.shade100,
//               child: ListView.builder(
//                 itemCount: 5,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) => Container(
//                   padding: EdgeInsets.all(10),
//                   margin: EdgeInsets.only(right: 10),
//                   width: 200,
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           decoration: loadCardDecoration,
//                           height: 100,
//                         ),
//                         Gap(6),
//                         Container(
//                           width: 150,
//                           margin: EdgeInsets.only(left: 8),
//                           decoration: loadCardDecoration,
//                           height: 10,
//                         ),
//                         Gap(8),
//                         Container(
//                           margin: EdgeInsets.only(left: 8),
//                           decoration: loadCardDecoration,
//                           height: 10,
//                           width: 100,
//                         ),
//                         Gap(4),
//                         Container(
//                           margin: EdgeInsets.only(left: 8),
//                           decoration: loadCardDecoration,
//                           width: 80,
//                           height: 10,
//                         ),
//                       ]),
//                 ),
//               ),
//             ),
//           )
//         : SizedBox(
//             height: 190,
//             child: ListView.builder(
//               itemCount: datas.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) => Container(
//                 width: 180,
//                 margin: EdgeInsets.only(left: 10),
//                 child: TicketCardBig(product: datas[index]),
//               ),
//             ),
//           );
//   }
// }
