import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_compress/video_compress.dart';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:eshara/Core/Widgets/app_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:eshara/Core/di/dependency_injection.dart';
import 'package:eshara/Core/di/injection_container.dart';

import 'package:eshara/features/SignToText/UI/Widget/camera_preview_widget.dart';
import 'package:eshara/features/SignToText/UI/Widget/processing_indicator.dart';
import 'package:eshara/features/SignToText/UI/Widget/translation_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshara/Core/constants/app_strings.dart';
import '../bloc/sign_bloc.dart';
import '../bloc/sign_event.dart';
import '../bloc/sign_state.dart';

class SignToTextPage extends StatelessWidget {
  const SignToTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignBloc>(),
      child: const _SignToTextView(),
    );
  }
}

class _SignToTextView extends StatefulWidget {
  const _SignToTextView();

  @override
  State<_SignToTextView> createState() => _SignToTextViewState();
}

class _SignToTextViewState extends State<_SignToTextView> {
  final ImagePicker _picker = ImagePicker();
  String? _currentVideoPath;
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _deleteCurrentVideoFile();
    super.dispose();
  }

  /// دالة لحذف ملف الفيديو المؤقت من الجهاز لتوفير المساحة
  Future<void> _deleteCurrentVideoFile() async {
    final path = _currentVideoPath;
    if (path != null) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          debugPrint('تم حذف الفيديو المؤقت بنجاح: $path');
        }
        await VideoCompress.deleteAllCache(); // مسح الـ Cache الخاص بمكتبة الضغط
      } catch (e) {
        debugPrint('تعذر حذف الفيديو المؤقت: $e');
      }
    }
  }

  /// تهيئة الكاميرا الأمامية
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint('لم يتم العثور على كاميرات');
        if (!mounted) return;
        SnackbarHelper.showCustomSnackBar(
          context,
          'لم يتم العثور على كاميرات متاحة',
          isError: true,
        );
        return;
      }

      // البحث عن الكاميرا الأمامية واختيارها، أو اختيار أول كاميرا في حال عدم وجودها
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false, // لا نحتاج للصوت
      );

      await _controller!.initialize();

      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('خطأ في تشغيل الكاميرا: $e');
      if (!mounted) return;
      SnackbarHelper.showCustomSnackBar(
        context,
        'حدث خطأ أثناء تشغيل الكاميرا',
        isError: true,
      );
    }
  }

  /// دالة مساعدة لضغط الفيديو
  Future<String?> _compressVideo(String videoPath) async {
    try {
      if (mounted) {
        SnackbarHelper.showCustomSnackBar(
          context,
          'جاري ضغط الفيديو لتسريع الرفع...',
        );
      }
      final MediaInfo? info = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality
            .DefaultQuality, // جودة افتراضية (متوسطة) لتقليل الحجم بشكل كبير
        deleteOrigin:
            false, // سنتركه false لأننا نحذف الفيديوهات المؤقتة بأنفسنا
      );
      return info?.file?.path;
    } catch (e) {
      debugPrint('خطأ أثناء ضغط الفيديو: $e');
      return null;
    }
  }

  Future<void> _pickAndAnalyzeVideo() async {
    try {
      // فتح الاستوديو لاختيار فيديو
      final XFile? pickedVideo = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedVideo != null) {
        File videoFile = File(pickedVideo.path);

        if (!mounted) return;
        setState(() {
          _currentVideoPath = videoFile.path;
        });

        // ضغط الفيديو قبل الإرسال
        String pathToSend = videoFile.path;
        final compressedPath = await _compressVideo(pathToSend);
        if (compressedPath != null) {
          pathToSend = compressedPath;
          if (mounted) setState(() => _currentVideoPath = pathToSend);
        }

        if (!mounted) return;
        context.read<SignBloc>().add(StopRecordingEvent(videoPath: pathToSend));
      }
    } catch (e) {
      debugPrint("حدث خطأ أثناء اختيار الفيديو: $e");
      if (!mounted) return;
      SnackbarHelper.showCustomSnackBar(
        context,
        'حدث خطأ أثناء محاولة فتح الاستوديو',
        isError: true,
      );
    }
  }

  /// يبدأ تسجيل الفيديو ويرسل حدث للـ BLoC
  Future<void> _startRecording() async {
    if (!_isCameraInitialized ||
        _controller == null ||
        _controller!.value.isRecordingVideo) {
      return;
    }
    try {
      await _controller!.startVideoRecording();
      if (!mounted) return;
      context.read<SignBloc>().add(StartRecordingEvent());
    } catch (e) {
      debugPrint('خطأ عند بدء التسجيل: $e');
    }
  }

  /// يوقف تسجيل الفيديو ويستخرج المسار ثم يرسله للـ BLoC
  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      return;
    }
    try {
      final XFile videoFile = await _controller!.stopVideoRecording();
      if (!mounted) return;
      setState(() {
        _currentVideoPath = videoFile.path;
      });

      // ضغط الفيديو قبل الإرسال
      String pathToSend = videoFile.path;
      final compressedPath = await _compressVideo(pathToSend);
      if (compressedPath != null) {
        pathToSend = compressedPath;
        if (mounted) setState(() => _currentVideoPath = pathToSend);
      }

      if (!mounted) return;
      context.read<SignBloc>().add(StopRecordingEvent(videoPath: pathToSend));
    } catch (e) {
      debugPrint('خطأ عند إيقاف التسجيل: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            BuildAppBar(tt: tt),
            SizedBox(height: MediaQuery.of(context).padding.top),

            Expanded(
              child: BlocBuilder<SignBloc, SignState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _buildBody(context, state, tt),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Body router ───────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, SignState state, TextTheme tt) {
    if (state is SignProcessingState) {
      return _buildProcessingBody(context, state, tt);
    }
    if (state is SignResultState) {
      return _buildResultBody(context, state, tt);
    }
    if (state is SignErrorState) {
      return _buildErrorBody(context, state, tt);
    }
    // Idle or Recording
    return _buildCameraBody(context, state, tt);
  }

  // ── State: Idle / Recording ───────────────────────────────────────────────
  Widget _buildCameraBody(BuildContext context, SignState state, TextTheme tt) {
    final isRecording = state is SignRecordingState;

    return SingleChildScrollView(
      key: const ValueKey('camera'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // Camera preview
          SizedBox(
            height: 280,
            child: CameraPreviewWidget(
              controller: _controller,
              isRecording: isRecording,
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          if (!isRecording)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isCameraInitialized ? _startRecording : null,
                    icon: const Icon(Icons.videocam_rounded, size: 20),
                    label: Text(AppStrings.startRecognition),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickAndAnalyzeVideo,
                    icon: const Icon(Icons.upload_file_rounded, size: 20),
                    label: const Text('رفع فيديو'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EsharaTheme.surfaceVariant,
                      foregroundColor: EsharaTheme.primaryBlue,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _deleteCurrentVideoFile();
                      setState(() {
                        _currentVideoPath = null;
                      });
                      context.read<SignBloc>().add(CancelRecordingEvent());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: EsharaTheme.error,
                      side: const BorderSide(color: EsharaTheme.error),
                    ),
                    child: Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _stopRecording,
                    child: Text(AppStrings.stopRecording),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ── State: Processing ─────────────────────────────────────────────────────
  Widget _buildProcessingBody(
    BuildContext context,
    SignProcessingState state,
    TextTheme tt,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('processing'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Processing animation in camera area
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 237, 241),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: ProcessingIndicator(
                progress: state.progress,
                steps: state.steps,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Cancel button
          OutlinedButton(
            onPressed: () {
              _deleteCurrentVideoFile();
              setState(() {
                _currentVideoPath = null;
              });
              context.read<SignBloc>().add(CancelRecordingEvent());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: EsharaTheme.error,
              side: const BorderSide(color: EsharaTheme.error),
            ),
            child: Text(AppStrings.cancel),
          ),
        ],
      ),
    );
  }

  // ── State: Result ─────────────────────────────────────────────────────────
  Widget _buildResultBody(
    BuildContext context,
    SignResultState state,
    TextTheme tt,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (_currentVideoPath != null) ...[
            _VideoPlayerWidget(videoPath: _currentVideoPath!),
            const SizedBox(height: 20),
          ],
          TranslationResultCard(
            translation: state.translation,
            onNewTranslation: () {
              _deleteCurrentVideoFile();
              setState(() {
                _currentVideoPath = null;
              });
              context.read<SignBloc>().add(ResetEvent());
            },
          ),
        ],
      ),
    );
  }

  // ── State: Error ──────────────────────────────────────────────────────────
  Widget _buildErrorBody(
    BuildContext context,
    SignErrorState state,
    TextTheme tt,
  ) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: EsharaTheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: tt.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_currentVideoPath != null) ...[
              ElevatedButton.icon(
                onPressed: () {
                  SnackbarHelper.showCustomSnackBar(
                    context,
                    'جاري إعادة رفع الفيديو...',
                  );
                  // إعادة إرسال الحدث بنفس مسار الفيديو الحالي
                  context.read<SignBloc>().add(
                    StopRecordingEvent(videoPath: _currentVideoPath!),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('إعادة المحاولة بنفس الفيديو'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  _deleteCurrentVideoFile();
                  setState(() {
                    _currentVideoPath = null;
                  });
                  context.read<SignBloc>().add(ResetEvent());
                },
                child: const Text('تسجيل فيديو جديد'),
              ),
            ] else
              ElevatedButton(
                onPressed: () => context.read<SignBloc>().add(ResetEvent()),
                child: const Text('حاول مرة أخرى'),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Video Player Widget ───────────────────────────────────────────────────
class _VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const _VideoPlayerWidget({required this.videoPath});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final file = File(widget.videoPath);
    if (!await file.exists()) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    _controller = VideoPlayerController.file(file);
    try {
      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.play();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: EsharaTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'تعذر تشغيل الفيديو',
            style: TextStyle(color: EsharaTheme.error),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 19, 26),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 280),
        width: double.infinity,
        color: const Color.fromARGB(255, 41, 41, 57),
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }
}
