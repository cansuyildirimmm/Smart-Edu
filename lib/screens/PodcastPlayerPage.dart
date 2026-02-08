import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../services/activity_tracking_service.dart';
import '../services/tts_service.dart';

class PodcastPlayerPage extends StatefulWidget {
  final String storagePath;
  final String title;
  final String subject;
  final String topic;

  const PodcastPlayerPage({
    super.key,
    required this.storagePath,
    required this.title,
    this.subject = '',
    this.topic = '',
  });

  @override
  State<PodcastPlayerPage> createState() => _PodcastPlayerPageState();
}

class _PodcastPlayerPageState extends State<PodcastPlayerPage> {
  final AudioPlayer _player = AudioPlayer();
  bool isLoading = true;
  final ActivityTrackingService _activityService = ActivityTrackingService();
  String? _activityId;
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _loadAudio();
    _startTracking();
    _announcePage();
  }

  void _announcePage() async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 1000));
      _ttsService.speak("${widget.title} podcasti oynatılıyor.");
    }
  }

  Future<void> _startTracking() async {
    _activityId = await _activityService.startMaterialActivity(
      materialType: 'podcast',
      subject: widget.subject,
      topic: widget.topic,
      title: widget.title,
    );
  }

  Future<void> _stopTracking() async {
    if (_activityId != null) {
      await _activityService.completeMaterialActivity(
        activityId: _activityId!,
      );
    }
  }

  Future<void> _loadAudio() async {
    try {
      final audioUrl = await FirebaseStorage.instance
          .ref(widget.storagePath)
          .getDownloadURL();

      await _player.setUrl(audioUrl);
      _player.play();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Podcast yüklenirken hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _stopTracking();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kulaklık simgesi
                    Icon(
                      Icons.headphones,
                      size: 100,
                      color: const Color(0xFFFF5C5C),
                    ),
                    const SizedBox(height: 16),
                    // Slider ile ilerleme
                    StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = _player.duration ?? Duration.zero;
                        return Slider(
                          min: 0,
                          max: duration.inMilliseconds.toDouble(),
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                          onChanged: (value) {
                            _player.seek(Duration(milliseconds: value.toInt()));
                          },
                          activeColor: const Color(0xFFFF5C5C),
                          inactiveColor: Colors.grey[300],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Play/Pause butonu
                    IconButton(
                      iconSize: 80,
                      icon: StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playing = snapshot.data?.playing ?? false;
                          return Icon(
                            playing ? Icons.pause_circle : Icons.play_circle,
                            color: const Color(0xFF2C3E50),
                          );
                        },
                      ),
                      onPressed: () {
                        _player.playing ? _player.pause() : _player.play();
                        
                        if (_ttsService.isEnabled) {
                           _ttsService.speak(_player.playing ? "Podcast durduruldu" : "Podcast oynatılıyor");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
