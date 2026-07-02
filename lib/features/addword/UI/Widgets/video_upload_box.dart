import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';


// ── Video Upload Box ───────────────────────────────────────────────────────
/// [Widget] — _VideoUploadBox
/// بيعرض منطقة رفع الفيديو:
/// - لو مفيش فيديو: بيعرض أيقونة الرفع
/// - لو اتختار فيديو: بيعرض اسمه مع زرار إلغاء

class VideoUploadBox extends StatelessWidget {
  final bool videoPicked;
  final String? videoName;
  final VoidCallback onPick;
  final VoidCallback onCancel;

  const VideoUploadBox({super.key, 
    required this.videoPicked,
    required this.onPick,
    required this.onCancel,
    this.videoName,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: videoPicked ? null : onPick,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EsharaTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: videoPicked
                ? EsharaTheme.primaryBlue
                : EsharaTheme.border,
            style: BorderStyle.solid,
          ),
        ),
        child: videoPicked
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // زرار إلغاء العملية
                  GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: EsharaTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('إلغاء العملية',
                          style: tt.labelMedium!.copyWith(
                              color: EsharaTheme.error)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      videoName ?? '',
                      style: tt.bodyMedium!
                          .copyWith(color: EsharaTheme.textPrimary),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.video_file_rounded,
                      color: EsharaTheme.primaryBlue, size: 28),
                ],
              )
            : Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined,
                      size: 40, color: EsharaTheme.textHint),
                  const SizedBox(height: 8),
                  Text(
                    'ارفع فيديو من الاستوديو',
                    style:
                        tt.bodyMedium!.copyWith(color: EsharaTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('يدعم ملفات MP4، MOV',
                      style: tt.bodySmall),
                ],
              ),
      ),
    );
  }
}
