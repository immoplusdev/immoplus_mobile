// part of homePage;

// class RecommandedSection extends StatelessWidget {
//   const RecommandedSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductCubit, AppState>(
//       buildWhen: (previous, current) =>
//           current is PendingState<RecommendedServiceState> ||
//           current is DoneState<RecommendedServiceState>,
//       builder: (context, state) {
//         return SliverToBoxAdapter(
//           child: (state is DoneState<RecommendedServiceState>)
//               ? (state.finishData.data.isNotEmpty)
//                   ? Container(
//                       height: 270,
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
//                                   ? 'Recommandations'
//                                   : '',
//                             ),
//                           ),
//                           Expanded(
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: state.finishData.data.length,
//                               itemExtent: 205,
//                               cacheExtent: 10,
//                               itemBuilder: (context, index) => Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: TicketCardBig(
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
