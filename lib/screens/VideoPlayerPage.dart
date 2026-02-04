import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import '../services/activity_tracking_service.dart';

class VideoPlayerPage extends StatefulWidget {
  final String storagePath;
  final String title;
  final String subject;
  final String topic;

  const VideoPlayerPage({
    super.key,
    required this.storagePath,
    required this.title,
    this.subject = '',
    this.topic = '',
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _controller;
  bool isLoading = true;
  final ActivityTrackingService _activityService = ActivityTrackingService();
  String? _activityId;

  @override
  void initState() {
    super.initState();
    _loadVideo();
    _startTracking();
  }

  Future<void> _startTracking() async {
    _activityId = await _activityService.startMaterialActivity(
      materialType: 'video',
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

  Future<void> _loadVideo() async {
    try {
      final videoUrl = await FirebaseStorage.instance
          .ref(widget.storagePath)
          .getDownloadURL();

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _controller!.initialize();
      _controller!.setLooping(false);
      _controller!.play();

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
        SnackBar(content: Text('Video yüklenirken hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _stopTracking();
    _controller?.dispose();
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
          : _controller != null && _controller!.value.isInitialized
              ? Column(
                  children: [
                    /// 🎥 Video alanı — ekranı taşırmaz
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),

                    /// ⏱ Slider ile ilerletme
                    Slider(
                      min: 0,
                      max: _controller!.value.duration.inMilliseconds.toDouble(),
                      value: _controller!.value.position.inMilliseconds
                          .clamp(0, _controller!.value.duration.inMilliseconds)
                          .toDouble(),
                      onChanged: (value) {
                        _controller!.seekTo(
                            Duration(milliseconds: value.toInt()));
                      },
                      activeColor: const Color(0xFFFF5C5C),
                      inactiveColor: Colors.grey[300],
                    ),

                    /// ▶️ Kontroller — SABİT ALTTA
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: IconButton(
                        iconSize: 60,
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Video bulunamadı')),
    );
  }
}
