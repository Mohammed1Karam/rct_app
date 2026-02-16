import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/confirmRequest.dart';

import 'package:rct/view/home_screen.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:rct/l10n/app_localizations.dart';

import '../generated/l10n.dart';

class SharePaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const SharePaymentWebViewScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  _SharePaymentWebViewScreenState createState() =>
      _SharePaymentWebViewScreenState();
}

class _SharePaymentWebViewScreenState extends State<SharePaymentWebViewScreen> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('success')) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmRequest(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          )));

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Complete Payment"),
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
