// part of homePage;

// class HomeCarousel extends StatelessWidget {
//   const HomeCarousel({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//         delegate: SliverChildBuilderDelegate((context, index) {
//       return BlocBuilder<GalleryCubit, AppState>(
//         builder: (context, state) {
//           return (state is FinishState<List<GalleryModel>>)
//               ? Visibility(
//                   visible: state.data.isNotEmpty,
//                   child: SizedBox(
//                     child: CarouselSlider.builder(
//                       itemCount: state.data.length,
//                       itemBuilder: (BuildContext context, int itemIndex,
//                           int pageViewIndex) {
//                         return _ImageContainer(
//                           image: state.data[itemIndex].image ??
//                               'https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=',
//                           category: state.data[itemIndex].category ?? 0,
//                         );
//                       },
//                       options: CarouselOptions(
//                         height: 180,
//                         autoPlay: true,
//                         enlargeCenterPage: true,
//                       ),
//                     ),
//                   ),
//                 )
//               : CarouselSlider(
//                   items: [
//                     Shimmer.fromColors(
//                       baseColor: (Colors.grey[300])!,
//                       highlightColor: Colors.white,
//                       period: Duration(milliseconds: 600),
//                       child: Container(
//                         height: 180,
//                         margin: const EdgeInsets.only(top: 10, bottom: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     )
//                   ],
//                   options: CarouselOptions(
//                     height: 180,
//                     autoPlay: false,
//                     enlargeCenterPage: true,
//                   ),
//                 );
//         },
//       );
//     }, childCount: 1));
//   }
// }

// class _ImageContainer extends StatefulWidget {
//   _ImageContainer({Key? key, required this.image, required this.category})
//       : super(key: key);
//   final String image;
//   final int category;

//   @override
//   State<_ImageContainer> createState() => __ImageContainerState();
// }

// class __ImageContainerState extends State<_ImageContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 250,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//                 image: AssetImage(
//                   'assets/img/void_image.png',
//                 ),
//                 fit: BoxFit.fill),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 3,
//                 blurRadius: 7,
//                 offset: Offset(0, 0), // changes position of shadow
//               ),
//             ],
//           ),
//           margin: const EdgeInsets.only(top: 10, bottom: 10),
//           child: FittedBox(
//             fit: BoxFit.fill,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30),
//               child: CachedNetworkImage(
//                 imageUrl: '${RequestPath.baseUrl}/api/file/${widget.image}',
//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     Padding(
//                   padding: const EdgeInsets.all(100.0),
//                   child: CircularProgressIndicator(
//                       value: downloadProgress.progress),
//                 ),
//                 errorWidget: (context, url, error) => Container(),
//               ),
//             ),
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             FilterSearchModel().category = widget.category;

//             context.read<NavigationCubit>().switchPage(PageState.explore);
//           },
//           child: Container(
//             alignment: Alignment.center,
//             margin: const EdgeInsets.only(top: 10, bottom: 10),
//             width: double.infinity,
//             height: 160,
//           ),
//         ),
//       ],
//     );
//   }
// }
