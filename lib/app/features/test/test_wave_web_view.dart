// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TestWaveWebView extends StatelessWidget {
//   const TestWaveWebView({super.key});
//   final String waveUrl =
//       "https://pay.wave.com/c/cos-1y8snac9g2132?a=104&c=XOF&m=AFRIQSOLUS%20CI%20%2A%20Conn";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("QR Code Wave via WebView")),
//       body: WebViewWidget(
//         controller: WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)

//           //..runJavaScript('''document.body.style.zoom = "1.5";''')
//           ..setUserAgent(
//               "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
//               "(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36") // Agent d’un vrai navigateur desktop
//           ..loadRequest(Uri.parse(waveUrl)),
//       ),
//     );
//   }
// }
