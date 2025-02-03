// import 'package:flutter/material.dart';
// import 'package:immoplus/data/models/logment_model.dart';
// import 'package:immoplus/data/models/model.dart';
// import 'package:immoplus/features/detail_product/detail_product_package.dart';
// import 'package:immoplus/features/logment/logment_page.dart';

// void bottomSheetDetail(BuildContext context,
//     {required Model product, void Function()? onItinerary}) {
//   // context.read<DetailTicketBloc>().add(GetProductsEvent(idProduct: idProduct));
//   showModalBottomSheet<void>(
//     isDismissible: true,
//     isScrollControlled: true,
//     useRootNavigator: true,
//     useSafeArea: true,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//     showDragHandle: true,
//     backgroundColor: Colors.white,
//     context: context,
//     builder: (context) => Container(
//       height: MediaQuery.of(context).size.height * 0.90,
//       child: (product is LogmentModel)
//           ? LogmentPage(
//               showBack: false,
//               idProduct: product.id ?? '',
//               logmentModel: product,
//             )
//           : DetailProductPage(
//               showBack: false,
//               idProduct: (product as ProductModel).id ?? 0,
//             ),
//     ),
//   );
// }
