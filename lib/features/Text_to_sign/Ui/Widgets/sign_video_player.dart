import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/sign_video.dart';

/// [Widget] — SignVideoPlayer
/// بيتعرض في حالة [TextToSignResultState]
/// بيعرض الـ AI avatar مع controls (play/pause، ±10 ثواني، download)
/// [signVideo]   — الـ entity اللي فيها رابط الفيديو
/// [isPlaying]   — حالة التشغيل الحالية
/// [onPlayPause] — callback لـ play/pause
/// [onDownload]  — callback للتنزيل
class SignVideoPlayer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Video Container ───────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // الـ AI Avatar placeholder
              // TODO: استبدل بـ VideoPlayer(controller) من video_player package
              Container(
                width: double.infinity,
                height: 320,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A0E27), Color(0xFF1A2050)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.smart_toy_rounded,
                    size: 90,
                    color: Colors.white24,
                  ),
                ),
              ),

              // "نشط" badge في الكورنر
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: EsharaTheme.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'نشط',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Video Controls ────────────────────────────────────────
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // رجوع 10 ثواني
                    _ControlBtn(
                      icon: Icons.replay_10_rounded,
                      onTap: () {
                        // TODO: controller.seekTo(position - 10s)
                      },
                    ),
                    const SizedBox(width: 16),

                    // Play / Pause
                    GestureDetector(
                      onTap: onPlayPause,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: EsharaTheme.primaryBlue,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // تقديم 10 ثواني
                    _ControlBtn(
                      icon: Icons.forward_10_rounded,
                      onTap: () {
                        // TODO: controller.seekTo(position + 10s)
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── زرار التحميل ──────────────────────────────────────────────
        GestureDetector(
          onTap: onDownload,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'تحميل',
                style: tt.labelMedium!.copyWith(
                  color: EsharaTheme.primaryBlue,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.download_rounded,
                color: EsharaTheme.primaryBlue,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Control Button ─────────────────────────────────────────────────────────
class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
