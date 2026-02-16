import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';

import 'package:rct/view/final_orders/final-orders.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/l10n/app_localizations.dart';

class ServicePaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const ServicePaymentWebViewScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  _ServicePaymentWebViewScreenState createState() =>
      _ServicePaymentWebViewScreenState();
}

class _ServicePaymentWebViewScreenState
    extends State<ServicePaymentWebViewScreen> {
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
                  builder: (context) => FinalOrdersScreen(
                    initialIndex: 4,
                  ), // Replace with your target screen
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
