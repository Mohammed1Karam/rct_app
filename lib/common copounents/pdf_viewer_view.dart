import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'app_bar_back_button.dart';

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});
}

class _PDFViewerPageState extends State<PDFViewerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(context),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        canShowScrollHead: false,

      ),
    );
  }
}