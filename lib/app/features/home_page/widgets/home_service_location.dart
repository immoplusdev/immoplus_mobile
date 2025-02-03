// part of homePage;

// class HomeServiceLocation extends StatelessWidget {
//   const HomeServiceLocation({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductCubit, AppState>(
//       buildWhen: (previous, current) =>
//           current is PendingState<LocationServiceState> ||
//           current is DoneState<LocationServiceState>,
//       builder: (context, state) {
//         return SliverToBoxAdapter(
//             child: (state is DoneState<LocationServiceState>)
//                 ? (state.finishData.data.isNotEmpty)
//                     ? Container(
//                         height: 290,
//                         width: double.infinity,
//                         margin: EdgeInsets.only(bottom: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 0,
//                                 left: 10,
//                                 bottom: 0,
//                                 right: 10,
//                               ),
//                               child: HeaderSection(
//                                 onTap: () {
//                                   FilterSearchModel().category = (state
//                                               .finishData
//                                           as FinishState<List<ProductModel>>)
//                                       .data[0]
//                                       .category!
//                                       .id;
//                                   context
//                                       .read<NavigationCubit>()
//                                       .switchPage(PageState.explore);
//                                 },
//                                 title: (state.finishData.data.isNotEmpty)
//                                     ? 'Location'
//                                     : '',
//                               ),
//                             ),
//                             Expanded(
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: state.finishData.data.length,
//                                 itemExtent: 220,
//                                 cacheExtent: 10,
//                                 itemBuilder: (context, index) => Card(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: TicketCardBig(
//                                     product: state.finishData.data[index],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Container(
//                         height: 10,
//                       )
//                 : HomeSectionLoading());
//       },
//     );
//   }
// }
