// PDFViewerPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class PDFViewerPage extends StatefulWidget {
  final String storagePath;
  final String title;

  const PDFViewerPage({
    super.key,
    required this.storagePath,
    required this.title,
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadPDF();
  }

  Future<void> _downloadAndLoadPDF() async {
    try {
      final pdfUrl = await FirebaseStorage.instance
          .ref(widget.storagePath)
          .getDownloadURL();

      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode != 200) {
        throw Exception("PDF indirme başarısız: HTTP ${response.statusCode}");
      }

      final filename = '${widget.title.replaceAll(RegExp(r'[^\w]'), '')}.pdf';
      final file = File('${(await getTemporaryDirectory()).path}/$filename');
      await file.writeAsBytes(response.bodyBytes);

      if (!mounted) return;
      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        localPath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF yüklenirken hata oluştu: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
              ? PDFView(
                  filePath: localPath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                  fitPolicy: FitPolicy.BOTH,
                )
              : const Center(child: Text('PDF bulunamadı')),
    );
  }
}
