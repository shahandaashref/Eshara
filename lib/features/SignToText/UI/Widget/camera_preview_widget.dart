import 'package:camera/camera.dart';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  final bool isRecording;

  const CameraPreviewWidget({super.key, required this.isRecording});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController? _controller;
  bool _isInitialized = false;
  final List<Offset> _landmarks = []; // قائمة لتخزين إحداثيات النقاط
  bool _isDetecting = false; // لمنع تداخل الإطارات أثناء التحليل
  // Interpreter? _interpreter; // ⚠️ متغير نموذج TFLite (قم بإلغاء التعليق بعد تثبيت tflite_flutter)

  @override
  void initState() {
    super.initState();
    // _loadModel(); // تحميل النموذج عند فتح الشاشة
    _initializeCamera();
  }

  // دالة لتحميل النموذج من الـ Assets
  // Future<void> _loadModel() async {
  //   try {
  //     _interpreter = await Interpreter.fromAsset('assets/models/hand_model.tflite');
  //     debugPrint('تم تحميل النموذج بنجاح');
  //   } catch (e) {
  //     debugPrint('خطأ في تحميل النموذج: $e');
  //   }
  // }

  Future<void> _initializeCamera() async {
    try {
      // جلب جميع الكاميرات المتاحة في الجهاز
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // البحث عن الكاميرا الأمامية (Front Camera) لأنها الأنسب للغة الإشارة
      CameraDescription selectedCamera = cameras.first;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      // تهيئة متحكم الكاميرا
      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false, // لا نحتاج للصوت في لغة الإشارة غالباً
      );

      await _controller!.initialize();

      // التقاط الإطارات المباشرة
      _controller!.startImageStream((CameraImage image) async {
        // إذا كان النموذج لا يزال يعالج الإطار السابق، أو لم يتم تحميله بعد، تجاهل الإطار الحالي
        if (_isDetecting) return;
        // if (_interpreter == null) return;

        _isDetecting = true;

        try {
          // 1. تحويل الصورة (CameraImage) لتناسب مدخلات نموذجك (مثلاً مصفوفة بأبعاد 224x224x3)
          // var input = _preprocessCameraImage(image);

          // 2. تجهيز مصفوفة المخرجات (تعتمد على تصميم النموذج، مثلاً 21 نقطة كل نقطة لها إحداثيات X, Y)
          // var output = List.filled(1 * 21 * 2, 0.0).reshape([1, 21, 2]);

          // 3. تشغيل النموذج
          // _interpreter!.run(input, output);

          // 4. استخراج النقاط وتحديث الواجهة
          // List<Offset> detectedPoints = _extractLandmarks(output);
          // if (mounted) {
          //   setState(() {
          //     _landmarks.clear();
          //     _landmarks.addAll(detectedPoints);
          //   });
          // }
        } catch (e) {
          debugPrint('خطأ أثناء المعالجة: $e');
        } finally {
          _isDetecting = false; // السماح باستقبال الإطار التالي
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تشغيل الكاميرا: $e');
    }
  }

  @override
  void dispose() {
    // _interpreter?.close(); // إغلاق النموذج لتحرير الذاكرة
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // عرض الكاميرا الفعلي إذا تم التهيئة بنجاح
          if (_isInitialized && _controller != null) ...[
            CameraPreview(_controller!),

            // رسم نقاط الـ Landmarks فوق الكاميرا المباشرة
            Positioned.fill(
              child: CustomPaint(
                painter: HandLandmarksPainter(landmarks: _landmarks),
              ),
            ),
          ] else
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white24),
              ),
            ),

          // Recording indicator
          if (widget.isRecording)
            Positioned(top: 12, left: 12, child: _RecordingBadge()),
        ],
      ),
    );
  }
}

// ── كلاس رسم النقاط (CustomPainter) ──────────────────────────────────────
class HandLandmarksPainter extends CustomPainter {
  final List<Offset> landmarks;

  HandLandmarksPainter({required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    // إعدادات فرشاة الرسم (اللون، الحجم، والشكل)
    final paint = Paint()
      ..color = EsharaTheme
          .success // لون النقاط (أخضر مثلاً)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.fill;

    // رسم دائرة صغيرة عند كل نقطة (إحداثي)
    for (var point in landmarks) {
      // ملاحظة: قد تحتاج لعمل Scale للنقاط لتتناسب مع حجم الشاشة مقابل حجم الـ CameraImage
      canvas.drawCircle(point, 4.0, paint);
    }
    // يمكن أيضاً رسم خطوط (drawLines) لربط المفاصل ببعضها إذا توفرت
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    // يتم إعادة الرسم فقط إذا تغيرت قائمة النقاط
    return oldDelegate.landmarks != landmarks;
  }
}

class _RecordingBadge extends StatefulWidget {
  @override
  State<_RecordingBadge> createState() => _RecordingBadgeState();
}

class _RecordingBadgeState extends State<_RecordingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: EsharaTheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'تسجيل',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
