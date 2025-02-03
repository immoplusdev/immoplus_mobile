// import 'package:flutter/cupertino.dart';
// import 'package:immoplus/cubits/cubits.dart';
// import 'package:immoplus/data/data.dart';
// import 'package:immoplus/data/models/model.dart';
// import 'package:immoplus/data/models/users_model.dart';
// import 'package:immoplus/domains/gallery/gallery.dart';
// import 'package:immoplus/request_path.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:immoplus/views/formulars_action/formular_action.dart';

// import '../app_states/services_state.dart';

// class ServicesApp {
//   static Future<ConfigModel> getConfig({required BuildContext context}) async {
//     ConfigModel configModel = await Repository<ConfigModel>(ConfigModel())
//         .fetchData(
//             requestInfo: RequestInfo(
//                 method: METHOD.GET, path: RequestPath.config, data: {}),
//             context: context) as ConfigModel;
//     return configModel;
//   }

//   // run bloc for home page
//   static getHomePageData({required BuildContext context}) {
//     context
//         .read<GalleryCubit>()
//         .getGroup(group: GalleryItemGroup.slider, context: context);
//     context.read<ProductCubit>().getAll<RecommendedServiceState>(
//         pathWith: RequestPath.productsRecommended, context: context);

//     if (UserModel.singleton.id!.isNotEmpty) {
//       context.read<ProductCubit>().getAll<RecentViewServiceState>(
//           pathWith: RequestPath.productViewed, context: context);
//     }

//     ConfigModel.singleton.categories!.forEach((e) {
//       //achat propriete

//       if (e.name == 'Location') {
//         context.read<ProductCubit>().getAll<LocationServiceState>(
//             pathWith: RequestPath.products, context: context, category: e.id);
//       } else if (e.name == 'Achat de propritétés') {
//         //achat propriete
//         context.read<ProductCubit>().getAll<AchatPropriServiceState>(
//             pathWith: RequestPath.products, context: context, category: e.id);
//       } else if (e.name == 'Meubles') {
//         context.read<ProductCubit>().getAll<MeubleServiceState>(
//             pathWith: RequestPath.products, context: context, category: e.id);
//       } else if (e.name == "Décoration d'intérieur") {
//         context.read<ProductCubit>().getAll<DecoServiceState>(
//             pathWith: RequestPath.products, context: context, category: e.id);
//       } else if (e.name == 'Déménagement') {
//         //Déménagement
//         context.read<ProductCubit>().getAll<DemServiceState>(
//             pathWith: RequestPath.products, context: context, category: e.id);
//       }
//     });

//     //Deco
//   }

//   static Widget getDetailsTargetPage(ProductDetailModel productDetailModel) {
//     //print(value);
//     switch (productDetailModel.category!.productType) {
//       case 'visit_to_ask':
//         return VisitFormularAction(
//           productDetailModel: productDetailModel,
//         );
//       case 'service':
//         return ServiceFormularAction(
//           productDetailModel: productDetailModel,
//         );
//       default:
//         return Container();
//     }
//   }
// }
