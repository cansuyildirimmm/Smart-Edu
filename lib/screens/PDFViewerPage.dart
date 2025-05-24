import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String assetPath;

  const PDFViewerPage({super.key, required this.assetPath});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    final byteData = await rootBundle.load(widget.assetPath);
    final file = File('${(await getTemporaryDirectory()).path}/temp.pdf');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Görüntüleyici")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: localPath,
      ),
    );
  }
}
