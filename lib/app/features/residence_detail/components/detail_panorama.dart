// part of detailProduct;

// class DdetailPanorama extends StatelessWidget {
//   const DdetailPanorama({super.key, required this.logmentModel});
//   final LogmentModel logmentModel;
//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: logmentModel.panoramas!.isNotEmpty,
//       replacement: SliverToBoxAdapter(),
//       child: SliverPadding(
//         padding: EdgeInsets.all(10),
//         sliver: SliverToBoxAdapter(
//             child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: CupertinoListTile(
//             backgroundColor: AppColors.primaryLite,
//             onTap: () {
//               Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     builder: (context) =>
//                         PanoramaPage(panos: logmentModel.panoramas!),
//                   ));
//             },
//             leading: Icon(Icons.panorama),
//             title: Text('Visite guidée panoramique'),
//             trailing: Icon(CupertinoIcons.chevron_forward),
//           ),
//         )),
//       ),
//     );
//   }
// }
