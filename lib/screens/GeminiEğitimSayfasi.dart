import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GeminiEgitimSayfasi extends StatefulWidget {
  const GeminiEgitimSayfasi({super.key});

  @override
  State<GeminiEgitimSayfasi> createState() => _GeminiEgitimSayfasiState();
}

class _GeminiEgitimSayfasiState extends State<GeminiEgitimSayfasi> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _isLoading = false;

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyDQ7Y6aTCJ7uBOGgDHiu9qpslh4-NWUDVI',
  );

  Future<void> _getEducationalContent() async {
    setState(() {
      _isLoading = true;
      _response = "";
    });

    final konu = _controller.text.trim();
    if (konu.isEmpty) {
      setState(() {
        _response = "Lütfen bir konu giriniz.";
        _isLoading = false;
      });
      return;
    }

    try {
      final prompt = """
Sen profesyonel bir çocuk eğitmenisin. 10 yaşındaki bir çocuğun anlayabileceği şekilde, örnekler ve küçük alıştırmalarla eğitim materyali oluştur:
- Konu: $konu
""";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      setState(() {
        _response = response.text ?? "Yanıt alınamadı.";
      });
    } catch (e) {
      setState(() {
        _response = "Bir hata oluştu: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    // Renk paleti (pastel, yumuşak ve okunabilir)
    final primaryColor = Color(0xFF4A90E2); // mavi
    final backgroundColor = Color(0xFFF5F7FA); // açık gri/mavi ton
    final inputFillColor = Colors.white;
    final buttonColor = Color(0xFF6BBF59); // yumuşak yeşil
    final errorColor = Colors.redAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Eğitim İçeriği Üretici",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: "Konu giriniz (ör: Güneş Sistemi)",
                labelStyle: TextStyle(color: primaryColor),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (!_isLoading) _getEducationalContent();
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _getEducationalContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Text(
                  "İçerik Üret",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: _response.isEmpty
                    ? Center(
                  child: Text(
                    "Eğitim içeriğiniz burada görünecek.",
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    : Markdown(
                  data: _response,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                    p: const TextStyle(fontSize: 16, height: 1.5),
                    h1: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    h2: TextStyle(
                      color: buttonColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    listBullet:
                    const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
