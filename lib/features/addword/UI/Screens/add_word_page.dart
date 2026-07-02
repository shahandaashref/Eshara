import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/features/addword/UI/Screens/add_word_success_page.dart';
import 'package:eshara/features/addword/UI/Widgets/video_upload_box.dart';
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
    if (!sl.isRegistered<AddWordBloc>()) {
      initDependencies();
    }

    return BlocProvider(
      create: (_) => sl<AddWordBloc>(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AddWordSuccessPage()),
              );
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
                          Text(
                            'طلب إضافة كلمة جديدة',
                            style: tt.displaySmall!.copyWith(
                              color: EsharaTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'أدخل بيانات الكلمة الجديدة وسيتم إرسالها للمراجعة والموافقة من الأدمن.',
                            style: tt.bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: EsharaTheme.primaryBlue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: EsharaTheme.primaryBlue.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              'سيتم إرسال الكلمة كطلب إلى الأدمن، وبعد الموافقة ستظهر في القاموس.',
                              style: tt.bodySmall!.copyWith(
                                color: EsharaTheme.primaryBlue,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── الكلمة ────────────────────────────────────
                          _buildLabel(tt, 'الكلمة'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _wordController,
                            textAlign: TextAlign.right,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'الكلمة مطلوبة' : null,
                            decoration: const InputDecoration(
                              hintText: 'اكتب الكلمة هنا',
                              prefixIcon: Icon(
                                Icons.text_fields_rounded,
                                color: EsharaTheme.textHint,
                                size: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── رفع الفيديو ───────────────────────────────
                          _buildLabel(tt, 'فيديو الإشارة'),
                          const SizedBox(height: 6),
                          VideoUploadBox(
                            videoPicked: videoPicked,
                            videoName: videoPicked ? (state).videoName : null,
                            onPick: () => context.read<AddWordBloc>().add(
                              PickVideoEvent(),
                            ),
                            onCancel: () => context.read<AddWordBloc>().add(
                              CancelUploadEvent(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── الوصف ─────────────────────────────────────
                          _buildLabel(tt, 'شرح الحركة'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descController,
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'اكتب التفاصيل',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(bottom: 48),
                                child: Icon(
                                  Icons.description_outlined,
                                  color: EsharaTheme.textHint,
                                  size: 20,
                                ),
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
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('إرسال طلب'),
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
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: EsharaTheme.textPrimary,
              ),
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
    return Text(
      text,
      style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<AddWordBloc>().state;
      final videoPath = state is VideoPickedState ? state.videoPath : null;

      context.read<AddWordBloc>().add(
        SubmitWordEvent(
          word: _wordController.text.trim(),
          description: _descController.text.trim(),
          videoPath: videoPath,
        ),
      );
    }
  }
}
