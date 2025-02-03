// part of homePage;

// class RecentVew extends StatelessWidget {
//   const RecentVew({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductCubit, AppState>(
//       buildWhen: (previous, current) =>
//           current is PendingState<RecentViewServiceState> ||
//           current is DoneState<RecentViewServiceState>,
//       builder: (context, state) {
//         return SliverToBoxAdapter(
//           child: (state is DoneState<RecentViewServiceState>)
//               ? (state.finishData.data.isNotEmpty)
//                   ? Container(
//                       //color: Colors.yellow,
//                       height: 200,
//                       width: double.infinity,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               top: 0,
//                               left: 10,
//                               bottom: 0,
//                               right: 10,
//                             ),
//                             child: HeaderSection(
//                               title: (state.finishData.data.isNotEmpty)
//                                   ? 'Vue récemment'
//                                   : '',
//                             ),
//                           ),
//                           Expanded(
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: state.finishData.data.length,
//                               itemExtent: 360,
//                               itemBuilder: (context, index) => Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TicketCardSmall(
//                                   product: state.finishData.data[index],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(
//                       height: 10,
//                     )
//               : HomeSectionLoading(),
//         );
//       },
//     );
//   }
// }
