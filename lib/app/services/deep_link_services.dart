import 'dart:async';
import 'dart:developer';

import 'package:immoplus/app/routes/app_router.dart';
// import 'package:uni_links/uni_links.dart';

class DeepLinkServices {
  static StreamSubscription? _sub;

  static Future<void> initUniLinks() async {
    // ... check initialUri

    // Attach a listener to the stream
    // _sub = uriLinkStream.listen((Uri? uri) {
    //   // Use the uri and warn the user, if it is not correct
    //   log('DEEPLINK');
    //   inspect(uri);
    //   AppRouter.router.push(uri!.path);
    // }, onError: (err) {
    //   // Handle exception by warning the user their action did not succeed
    // });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }
}
