import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:immoplus/app/data/models/remote/kyc/kyc_session_model.dart';

class KycWebViewPage extends StatefulWidget {
  final String url;
  final String? title;

  static final String routeName = "kyc_webview";

  const KycWebViewPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<KycWebViewPage> createState() => _KycWebViewPageState();
}

class _KycWebViewPageState extends State<KycWebViewPage> {
  InAppWebViewController? webViewController;
  bool _isLoading = true;

  final InAppWebViewSettings settings = InAppWebViewSettings(
    userAgent:
        "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    javaScriptEnabled: true,
  );

  void _checkUrl(WebUri? uri) {
    if (uri == null) return;
    final urlStr = uri.toString();
    debugPrint('Visited URL KYC: $urlStr');

    final statusParam = uri.queryParameters['status'];
    if (statusParam != null) {
      final status = KycStatus.fromUrlStatus(statusParam);
      if (status != KycStatus.unknown) {
        debugPrint(
            '✅ Callback KYC detected via URL check - Status Enum: $status');
        if (mounted) {
          Navigator.pop(context, status);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Vérification d'identité"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: settings,
            onWebViewCreated: (controller) => webViewController = controller,
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            onLoadStart: (controller, url) {
              setState(() => _isLoading = true);
              // _checkUrl(url);
            },
            onLoadStop: (controller, url) {
              setState(() => _isLoading = false);
              // _checkUrl(url);
            },
            onUpdateVisitedHistory: (controller, url, isReload) {
              // _checkUrl(url);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              _checkUrl(uri);
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
