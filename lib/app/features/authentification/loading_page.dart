import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  static String name = 'LOGIN_PAGE';
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late GifController controller;
  @override
  void initState() {
    controller = GifController(vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.repeat(
    //     min: 0,
    //     max: 94,
    //     reverse: true,
    //     period: const Duration(seconds: 1),
    //   );
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Gif(
            width: 220,
            height: 220,
            autostart: Autostart.loop,
            placeholder: (context) => const CupertinoActivityIndicator(),
            onFetchCompleted: () {
              controller.reset();
              controller.forward();
            },
            duration: Duration(milliseconds: 800),
            controller: controller,
            image: AssetImage(
              "assets/gif/loading.gif",
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     context.goNamed(
        //       OperatorsSelectorPage.name,
        //       extra: PaymentPageAdapter(
        //         itemId: "498ce7f9-f17c-4cc6-8c38-0751d42029ec",
        //         collection: "reservations",
        //         amount: 100,
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
