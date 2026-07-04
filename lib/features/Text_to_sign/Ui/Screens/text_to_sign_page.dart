import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshara/Core/di/dependency_injection.dart';
import 'package:eshara/Core/di/injection_container.dart';

import '../bloc/text_to_sign_bloc.dart';
import '../bloc/text_to_sign_state_event.dart';
import '../widgets/text_input_card.dart';
import '../widgets/text_to_sign_processing.dart';
import '../widgets/sign_video_player.dart';

/// [Page] — TextToSignPage
/// بتعرض 3 states:
/// 1. Idle    → text field + AI avatar placeholder
/// 2. Processing → circular progress + steps
/// 3. Result  → text + AI video player + download
class TextToSignPage extends StatelessWidget {
  const TextToSignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextToSignBloc>(
      create: (_) => sl<TextToSignBloc>(),
      child: const _TextToSignView(),
    );
  }
}

class _TextToSignView extends StatefulWidget {
  const _TextToSignView();

  @override
  State<_TextToSignView> createState() => _TextToSignViewState();
}

class _TextToSignViewState extends State<_TextToSignView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: BlocBuilder<TextToSignBloc, TextToSignState>(
          builder: (context, state) {
            // في حالة الـ processing بتظهر صفحة مختلفة خالص
            if (state is TextToSignProcessingState) {
              return _buildProcessingScreen(context, state, tt);
            }

            return Column(
              children: [
                _buildAppBar(context, tt, state),
                Expanded(
                  child: state is TextToSignResultState
                      ? _buildResultBody(context, state, tt)
                      : _buildIdleBody(context, tt),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(
    BuildContext context,
    TextTheme tt,
    TextToSignState state,
  ) {
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
          // زر الرجوع أو مساحة فارغة للحفاظ على التوسيط
          SizedBox(
            width: 40,
            child: state is TextToSignResultState
                ? IconButton(
                    onPressed: () => context.read<TextToSignBloc>().add(
                      ResetTextToSignEvent(),
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: EsharaTheme.textPrimary,
                    ),
                  )
                : null,
          ),
          const Spacer(),
          Text('ترجمة النص', style: tt.headlineLarge),
          const Spacer(),
          // زر التحديث أو مساحة فارغة
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () => _onReset(context),
              icon: const Icon(
                Icons.refresh_rounded,
                size: 22,
                color: EsharaTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── State: Idle ────────────────────────────────────────────────────────────
  Widget _buildIdleBody(BuildContext context, TextTheme tt) {
    return SingleChildScrollView(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // ── Text input ────────────────────────────────────────────────
          TextInputCard(
            controller: _textController,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          // ── Convert button ────────────────────────────────────────────
          ElevatedButton(
            onPressed: _textController.text.trim().isEmpty
                ? null
                : () => _onConvert(context),
            child: const Text('تحويل إلى إشارة'),
          ),

          const SizedBox(height: 24),

          // ── الترجمة الإشارية label ────────────────────────────────────
          Text(
            'الترجمة الإشارية',
            style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary),
          ),

          const SizedBox(height: 12),

          // ── AI Avatar Placeholder ─────────────────────────────────────
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: EsharaTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EsharaTheme.border, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sign_language,
                    size: 80,
                    color: EsharaTheme.primaryBlue.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'سيظهر فيديو الترجمة هنا',
                    style: tt.titleMedium?.copyWith(
                      color: EsharaTheme.textSecondary,
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

  // ── State: Processing (full screen) ───────────────────────────────────────
  Widget _buildProcessingScreen(
    BuildContext context,
    TextToSignProcessingState state,
    TextTheme tt,
  ) {
    return SafeArea(
      child: Center(
        child: TextToSignProcessing(
          progress: state.progress,
          steps: state.steps,
        ),
      ),
    );
  }

  // ── State: Result ──────────────────────────────────────────────────────────
  Widget _buildResultBody(
    BuildContext context,
    TextToSignResultState state,
    TextTheme tt,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),

          // ── النص المكتوب (read-only) ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: EsharaTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EsharaTheme.border),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      state.signVideo.inputText,
                      style: tt.bodyLarge!.copyWith(
                        color: EsharaTheme.textPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${state.signVideo.inputText.length} / 200',
                        style: tt.bodySmall,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: EsharaTheme.textHint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── label ─────────────────────────────────────────────────────
          Text(
            'الترجمة الإشارية',
            style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary),
          ),

          const SizedBox(height: 12),

          // ── Video Player ──────────────────────────────────────────────
          SignVideoPlayer(
            signVideo: state.signVideo,
            onDownload: () {
              context.read<TextToSignBloc>().add(
                DownloadVideoEvent(videoUrl: state.signVideo.videoUrl),
              );
              SnackbarHelper.showCustomSnackBar(
                context,
                'جارٍ تحميل الفيديو...',
              );
            },
          ),
        ],
      ),
    );
  }

  /// [_onConvert] — بتبعت الـ event للـ BLoC عشان يبدأ التحويل
  void _onConvert(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<TextToSignBloc>().add(ConvertTextEvent(text: text));
  }

  /// [_onReset] — بيمسح النص وبيرجع للحالة الأولية
  void _onReset(BuildContext context) {
    _textController.clear();
    context.read<TextToSignBloc>().add(ResetTextToSignEvent());
    setState(() {}); // لإعادة بناء الواجهة وتحديث حالة الزر
  }
}
