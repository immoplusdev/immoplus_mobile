// import "package:flutter/material.dart";
// import 'package:go_router/go_router.dart';
// import 'package:immoplus/app/features/home_page/home_page.dart';
// import 'package:immoplus/app/features/onboardinng_slider/flutter_onboarding_slider.dart';
// import 'package:immoplus/app/routes/app_router.dart';
// import 'package:immoplus/app/utils/session_manager.dart';

// class OnBoardingPage extends StatelessWidget {
//   static String name = 'ONBOARDING';
//   final TextStyle _textStyle = const TextStyle(
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//     shadows: [
//       Shadow(
//           blurRadius: 3,
//           color: Color.fromARGB(255, 70, 69, 69),
//           offset: Offset(0, 0))
//     ],
//     fontSize: 26,
//   );

//   const OnBoardingPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OnBoardingSlider(
//         indicatorAbove: true,
//         showNavBar: false,
//         //indicatorPosition: 100,
//         // imageHorizontalOffset: 0.0,
//         // imageVerticalOffset: -100,

//         hasFloatingButton: true,
//         headerBackgroundColor: Colors.transparent,
//         controllerColor: Colors.white,

//         centerBackground: true,
//         finishButtonText: 'Commencer',
//         middle: const Text('Skip'),
//         trailing: const Text('Login'),
//         indicatorPosition: 110,
//         finishButtonStyle: FinishButtonStyle(
//             backgroundColor: Theme.of(context).colorScheme.primary,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//             elevation: 2),
//         onFinish: () async {
//           await SessionManager().setOpended();
//           AppRouter.showOnboarding = false;
//           context.goNamed(HomePage.name);
//           //context.go('/login');
//         },
//         trailingFunction: () {
//           //context.go('/signin');
//         },

//         background: [
//           Image.asset(
//             'assets/img/onboarding/1.jpg',
//             fit: BoxFit.cover,
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//           ),
//           Image.asset(
//             'assets/img/onboarding/2.jpg',
//             fit: BoxFit.cover,
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//           ),
//           Image.asset(
//             'assets/img/onboarding/3.jpg',
//             fit: BoxFit.cover,
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//           ),
//           //Image.asset('assets/slide_2.png'),
//         ],
//         totalPage: 3,
//         speed: 1,

//         pageBackgroundColor: Colors.white,
//         pageBodies: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.5,
//                 ),
//                 Text(
//                   'Avec ImmoPLus, vous trouverez ce qu\'il vous faut pour votre immobilier en un clic.',
//                   style: _textStyle,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                 ),
//                 Text(
//                   'Recherchez facilement des propriétés et des meubles',
//                   style: _textStyle,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                 ),
//                 Text(
//                   'Suivez l\'état de vos demandes',
//                   style: _textStyle,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
