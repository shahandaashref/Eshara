import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:eshara/Core/Helper/theme.dart';
import '../../domain/entities/sign_video.dart';

class SignVideoPlayer extends StatefulWidget {
  final SignVideo signVideo;
  final VoidCallback onDownload;

  const SignVideoPlayer({
    super.key,
    required this.signVideo,
    required this.onDownload,
  });

  @override
  State<SignVideoPlayer> createState() => _SignVideoPlayerState();
}

class _SignVideoPlayerState extends State<SignVideoPlayer> {
  VideoPlayerController? _controller;
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
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.signVideo.videoUrl),
      );
      _controller = controller;
      await controller.initialize();
      _controller?.setLooping(true); // تكرار الفيديو تلقائياً
      _controller?.play(); // تشغيل تلقائي

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
      _controller?.dispose();
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      clipBehavior:
          Clip.antiAlias, // لضمان أن كل المحتوى يلتزم بالـ borderRadius
      decoration: BoxDecoration(
        color: EsharaTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EsharaTheme.border, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. المشغل الفعلي
          if (_isInitialized && !_hasError)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),

          // 2. حالة الخطأ
          if (_hasError)
            Center(
              child: Text(
                'تعذر تحميل الفيديو',
                style: TextStyle(color: EsharaTheme.error, fontFamily: 'Cairo'),
              ),
            ),

          // 3. حالة التحميل
          if (!_isInitialized && !_hasError)
            const Center(
              child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
            ),

          // ── أزرار التحكم (تشغيل/إيقاف وتحميل) ──
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: EsharaTheme.border)),
                color: EsharaTheme.surface, // خلفية شريط التحكم
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر التشغيل / الإيقاف المؤقت
                  IconButton(
                    onPressed: _isInitialized
                        ? () {
                            setState(() {
                              _controller?.value.isPlaying ?? false
                                  ? _controller?.pause()
                                  : _controller?.play();
                            });
                          }
                        : null,
                    icon: Icon(
                      _controller?.value.isPlaying ?? false
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: EsharaTheme.primaryBlue,
                      size: 36,
                    ),
                  ),

                  // زر التحميل
                  TextButton.icon(
                    onPressed: widget.onDownload,
                    icon: const Icon(Icons.download_rounded, size: 20),
                    label: Text(
                      'تحميل',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: EsharaTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
