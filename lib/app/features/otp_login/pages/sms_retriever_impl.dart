import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

/// You, as a developer should implement this interface.
/// You can use any package to retrieve the SMS code. in this example we are using SmartAuth
class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsRetrieverApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.hasData) {
      final code = res.requireData.code;

      return code;
      //  Use the code
    } else if (res.isCanceled) {
      // User canceled the dialog
    } else {
      // handle the error
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
