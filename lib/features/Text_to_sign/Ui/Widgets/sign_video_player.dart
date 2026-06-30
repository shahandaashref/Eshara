import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:eshara/Core/Helper/theme.dart';
import '../../domain/entities/sign_video.dart';

class SignVideoPlayer extends StatefulWidget {
  final SignVideo signVideo;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onDownload;

  const SignVideoPlayer({
    super.key,
    required this.signVideo,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onDownload,
  });

  @override
  State<SignVideoPlayer> createState() => _SignVideoPlayerState();
}

class _SignVideoPlayerState extends State<SignVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // نقوم بتشغيل الفيديو من الرابط (URL) القادم من السيرفر
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.signVideo.videoUrl),
      );

      await _controller.initialize();
      _controller.setLooping(true); // تكرار الفيديو تلقائياً
      _controller.play(); // تشغيل تلقائي

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant SignVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو تغير رابط الفيديو (مثلاً المستخدم ترجم نص جديد)، نقوم بإعادة تحميله
    if (oldWidget.signVideo.videoUrl != widget.signVideo.videoUrl) {
      _isInitialized = false;
      _hasError = false;
      _controller.dispose();
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // خلفية داكنة أثناء التحميل
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. المشغل الفعلي
          if (_isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          // 2. حالة الخطأ
          else if (_hasError)
            const Center(
              child: Text(
                'تعذر تحميل الفيديو',
                style: TextStyle(color: EsharaTheme.error, fontFamily: 'Cairo'),
              ),
            )
          // 3. حالة التحميل
          else
            const Center(
              child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
            ),

          // ── أزرار التحكم (تشغيل/إيقاف وتحميل) ──
          if (_isInitialized)
            Positioned(
              bottom: 12,
              right: 12,
              left: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر التحميل
                  GestureDetector(
                    onTap: widget.onDownload,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  // زر التشغيل / الإيقاف المؤقت
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                      widget.onPlayPause(); // إبلاغ الصفحة بالأكشن
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
