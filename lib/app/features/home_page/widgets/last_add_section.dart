part of homePage;

// class LastAddSection extends StatelessWidget {
//   const LastAddSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate((context, index) {
//         return Padding(
//           padding: EdgeInsets.only(left: 10, right: 10),
//           child: SizedBox(
//             width: double.infinity,
//             height: 430,
//             child: BlocBuilder<HomeProductBloc, ScreenState>(
//               builder: (context, state) {
//                 return GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       mainAxisSpacing: 10,
//                       crossAxisSpacing: 10,
//                       mainAxisExtent: 210,
//                       crossAxisCount: 2,
//                     ),
//                     itemCount: 4,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (state is PendingScreenSlideState) {
//                         return Container(
//                           color: Theme.of(context).colorScheme.onBackground,
//                           width: double.infinity,
//                           child: Center(
//                               child: CupertinoActivityIndicator(
//                             color: Theme.of(context).colorScheme.onSecondary,
//                             radius: 20,
//                           )),
//                         );
//                       } else if (state is ReadyScreenSlideState) {
//                         return (state.data.isNotEmpty)
//                             ? TicketCardBig(
//                                 product: state.data[index],
//                               )
//                             : Container();
//                       }
//                       return Container(
//                           //color: Colors.red,
//                           );
//                     });
//               },
//             ),
//           ),
//         );
//       }, childCount: 1),
//     );
//   }
// }
