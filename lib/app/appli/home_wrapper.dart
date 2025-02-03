// part of appli;

// class HomeWrapper extends StatefulWidget {
//   const HomeWrapper({super.key, required this.child});
//   final Widget child;
//   @override
//   State<HomeWrapper> createState() => _HomeWrapperState();
// }

// class _HomeWrapperState extends State<HomeWrapper> {
//   final int _selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.child,
//       bottomNavigationBar:
//           BlocBuilder<NavigationCubit, PageState>(builder: (context, state) {
//         return Container(
//           decoration: BoxDecoration(
//               color: Colors.red,
//               border: Border(
//                   top: BorderSide(
//                 color: Colors.grey.shade300,
//               ))),
//           child: BottomNavigationBar(
//             elevation: 0,
//             showSelectedLabels: false,
//             showUnselectedLabels: false,
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: AppColors.whiteBackground,
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.amber[800],
//             unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
//             iconSize: 20,
//             // selectedLabelStyle: GoogleFonts.inter(
//             //   fontSize: 0,
//             //   color: Theme.of(context).colorScheme.surface,
//             // ),
//             unselectedLabelStyle: GoogleFonts.inter(
//               color: Theme.of(context).colorScheme.surface,
//             ),
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: HomeIcon(
//                   expetedState: PageState.home,
//                   currentState: state,
//                   title: 'Accueil',
//                   immoIcons: ImmoIcons.home,
//                 ),
//                 label: '',
//               ),
//               // BottomNavigationBarItem(
//               //   icon: HomeIcon(
//               //     expetedState: PageState.explore,
//               //     currentState: state,
//               //     title: 'Pour moi',
//               //     immoIcons: ImmoIcons.coeur,
//               //   ),
//               //   label: '',
//               // ),
//               BottomNavigationBarItem(
//                 icon: HomeIcon(
//                   expetedState: PageState.history,
//                   currentState: state,
//                   title: 'Historique',
//                   immoIcons: ImmoIcons.historique,
//                 ),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: HomeIcon(
//                   expetedState: PageState.map,
//                   currentState: state,
//                   title: 'Visualiser',
//                   immoIcons: ImmoIcons.visua,
//                 ),
//                 label: '',
//               ),
//               BottomNavigationBarItem(
//                 icon: HomeIcon(
//                   expetedState: PageState.acount,
//                   currentState: state,
//                   title: 'Compte',
//                   immoIcons: ImmoIcons.compte,
//                 ),
//                 label: '',
//               ),
//             ],

//             onTap: (id) {
//               if (SessionManager().currentUser == null) {
//                 if (id == 1 || id == 3) {
//                 } else {
//                   //Vibrate.feedback(FeedbackType.light);

//                   context.read<NavigationCubit>().switchPage(
//                         (id == 0)
//                             ? PageState.home
//                             : (id == 1)
//                                 ?
//                                 // PageState.explore
//                                 // : (id == 2)
//                                 //     ?
//                                 PageState.history
//                                 : (id == 2)
//                                     ? PageState.map
//                                     : PageState.acount,
//                       );
//                 }
//               } else if (SessionManager().currentUser != null) {
//                 Vibrate.feedback(FeedbackType.light);

//                 context.read<NavigationCubit>().switchPage(
//                       (id == 0)
//                           ? PageState.home
//                           : (id == 1)
//                               ?
//                               // PageState.explore
//                               // : (id == 2)
//                               //     ?
//                               PageState.history
//                               : (id == 2)
//                                   ? PageState.map
//                                   : PageState.acount,
//                     );
//               }

//               switch (id) {
//                 case 0:
//                   context.go('/homePage');
//                   break;
//                 // case 1:
//                 //   context.go('/search');
//                 case 1:
//                   (SessionManager().currentUser != null)
//                       ? context.go('/history')
//                       : Utils.authentificationPopup(context: context);
//                   break;
//                 case 2:
//                   context.go('/map');
//                 case 3:
//                   (SessionManager().currentUser != null)
//                       ? context.go('/account')
//                       : Utils.authentificationPopup(context: context);
//                   {}
//                   break;
//                 default:
//                   context.go('/home');
//                   break;
//                 // Gérez plus d'indices si vous avez d'autres onglets
//               }
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
