import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../common copounents/app_bar_back_button.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfBase64;

  const PdfViewerScreen({Key? key, required this.pdfBase64}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _loadPdf();
  }

  Future<Uint8List> _loadPdf() async {
    try {
      String cleanedBase64 = widget.pdfBase64
          .replaceAll('"', '')
          .trim();
      final bytes = base64.decode(cleanedBase64);

      return bytes;
    } catch (e) {
      throw Exception('Failed to load PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:BackButtonAppBar(context),
      body: FutureBuilder<Uint8List>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading PDF',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pdfFuture = _loadPdf();
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            return PdfPreview(
              build: (format) => snapshot.data!,
              allowSharing: true,
              allowPrinting: true,
              canChangePageFormat: false,
            );
          }

          return Center(child: Text('No PDF data available'));
        },
      ),
    );
  }
}