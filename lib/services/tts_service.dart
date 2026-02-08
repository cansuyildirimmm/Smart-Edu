import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  late FlutterTts _flutterTts;
  bool _isEnabled = false;

  TtsService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      print("TTS: Başlatılıyor...");
      
      // Dil listesini al ve yazdır
      var languages = await _flutterTts.getLanguages;
      print("TTS: Mevcut Diller: $languages");

      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setSpeechRate(0.5); // Normal hız
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // Web için hata dinleyici
      _flutterTts.setErrorHandler((msg) {
        print("TTS Hata: $msg");
      });
      
      print("TTS: Ayarlar yapıldı (tr-TR)");
    } catch (e) {
      print("TTS Hatası (Init): $e");
    }
  }

  /// TTS'i etkinleştirir veya devre dışı bırakır.
  void setEnabled(bool enabled) {
    print("TTS: Durum değiştirildi -> $enabled");
    _isEnabled = enabled;
    if (!enabled) {
      stop();
    }
  }

  bool get isEnabled => _isEnabled;

  /// Metni seslendirir.
  Future<void> speak(String text) async {
    if (!_isEnabled) {
      print("TTS: Devre dışı, konuşulmadı: $text");
      return;
    }
    
    print("TTS: Konuşuluyor -> $text");
    try {
      // Önceki konuşmayı durdur
      await stop();
      
      if (text.isNotEmpty) {
        await _flutterTts.speak(text);
      }
    } catch (e) {
      print("TTS Hatası (Speak): $e");
    }
  }

  /// Konuşmayı durdurur.
  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
