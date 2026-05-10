import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_word_bloc.dart';
import '../bloc/add_word_bloc_state_event.dart';

/// [Page] — AddWordPage
/// بتتعرض لما المستخدم يضغط "إضافة كلمة جديدة".
/// فيها step واحد: إدخال الكلمة + رفع فيديو + إضافة.
/// لو اختار فيديو بتتحول لـ UploadVideoPage تلقائياً.
class AddWordPage extends StatelessWidget {
  const AddWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddWordBloc(),
      child: const _AddWordView(),
    );
  }
}

class _AddWordView extends StatefulWidget {
  const _AddWordView();

  @override
  State<_AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<_AddWordView> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: BlocConsumer<AddWordBloc, AddWordState>(
          listener: (context, state) {
            if (state is AddWordSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت إضافة الكلمة بنجاح ✅')),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final isLoading = state is AddWordLoadingState;
            final videoPicked = state is VideoPickedState;

            return Column(
              children: [
                _buildAppBar(context, tt),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 8),

                          // عنوان الصفحة
                          Text('إضافة كلمة جديدة',
                              style: tt.displaySmall!.copyWith(
                                  color: EsharaTheme.textPrimary)),
                          const SizedBox(height: 4),
                          Text(
                            'أضف كلمات لغة الإشارة الخاصة بك إلى القاموس الشخصي الخاص بك',
                            style: tt.bodyMedium,
                            textAlign: TextAlign.right,
                          ),

                          const SizedBox(height: 24),

                          // ── الكلمة ────────────────────────────────────
                          _buildLabel(tt, 'الكلمة'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _wordController,
                            textAlign: TextAlign.right,
                            validator: (v) => v == null || v.isEmpty
                                ? 'الكلمة مطلوبة'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'اكتب الكلمة هنا',
                              prefixIcon: Icon(Icons.text_fields_rounded,
                                  color: EsharaTheme.textHint, size: 20),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── رفع الفيديو ───────────────────────────────
                          _buildLabel(tt, 'فيديو الإشارة'),
                          const SizedBox(height: 6),
                          _VideoUploadBox(
                            videoPicked: videoPicked,
                            videoName: videoPicked
                                ? (state as VideoPickedState).videoName
                                : null,
                            onPick: () => context
                                .read<AddWordBloc>()
                                .add(PickVideoEvent()),
                            onCancel: () => context
                                .read<AddWordBloc>()
                                .add(CancelUploadEvent()),
                          ),

                          const SizedBox(height: 16),

                          // ── الوصف ─────────────────────────────────────
                          _buildLabel(tt, 'وصف الكلمة (اختياري)'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descController,
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'اكتب وصفاً للكلمة',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: 48),
                                child: Icon(Icons.description_outlined,
                                    color: EsharaTheme.textHint, size: 20),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── زرار الإضافة ──────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onSubmit,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text('إضافة'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, TextTheme tt) {
    return Container(
      color: EsharaTheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        right: 20,
        left: 20,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: EsharaTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: EsharaTheme.textPrimary),
            ),
          ),
          const Spacer(),
          Text('إضافة كلمة جديدة', style: tt.headlineLarge),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildLabel(TextTheme tt, String text) {
    return Text(text,
        style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary));
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddWordBloc>().add(SubmitWordEvent(
            word: _wordController.text.trim(),
            description: _descController.text.trim(),
          ));
    }
  }
}

// ── Video Upload Box ───────────────────────────────────────────────────────
/// [Widget] — _VideoUploadBox
/// بيعرض منطقة رفع الفيديو:
/// - لو مفيش فيديو: بيعرض أيقونة الرفع
/// - لو اتختار فيديو: بيعرض اسمه مع زرار إلغاء
class _VideoUploadBox extends StatelessWidget {
  final bool videoPicked;
  final String? videoName;
  final VoidCallback onPick;
  final VoidCallback onCancel;

  const _VideoUploadBox({
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
