import 'package:flutter/material.dart';

import 'package:rct/view/final_orders/final-orders.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/l10n/app_localizations.dart';

import '../generated/l10n.dart';

class CalcPaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const CalcPaymentWebViewScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  _CalcPaymentWebViewScreenState createState() =>
      _CalcPaymentWebViewScreenState();
}

class _CalcPaymentWebViewScreenState extends State<CalcPaymentWebViewScreen> {
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(), // Replace with your target screen
                ),
              );
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
