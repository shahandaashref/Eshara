import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/app_bottom_nav.dart';
import '../../../../../core/di/injection_container.dart';
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
  int _navIndex = 2;

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
                _buildAppBar(context, tt),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: state is TextToSignResultState
                        ? _buildResultBody(context, state, tt)
                        : _buildIdleBody(context, tt),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<TextToSignBloc, TextToSignState>(
          builder: (context, state) {
            // بنخبي الـ bottom nav في حالة الـ processing
            if (state is TextToSignProcessingState) return const SizedBox();
            return AppBottomNav(
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            );
          },
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
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
          // زرار رجوع
          GestureDetector(
            onTap: () {
              final state = context.read<TextToSignBloc>().state;
              if (state is TextToSignResultState) {
                context.read<TextToSignBloc>().add(ResetTextToSignEvent());
              } else {
                Navigator.maybePop(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: EsharaTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: EsharaTheme.textPrimary),
                  const SizedBox(width: 4),
                  Text('رجوع',
                      style: tt.bodyMedium!
                          .copyWith(color: EsharaTheme.textPrimary)),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text('ترجمة النص', style: tt.headlineLarge),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: EsharaTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.refresh_rounded,
                size: 18, color: EsharaTheme.textSecondary),
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
          Text('الترجمة الإشارية',
              style: tt.headlineMedium!
                  .copyWith(color: EsharaTheme.textPrimary)),

          const SizedBox(height: 12),

          // ── AI Avatar Placeholder ─────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A0E27), Color(0xFF1A2050)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(Icons.smart_toy_rounded,
                    size: 80, color: Colors.white12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── State: Processing (full screen) ───────────────────────────────────────
  Widget _buildProcessingScreen(
      BuildContext context, TextToSignProcessingState state, TextTheme tt) {
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
      BuildContext context, TextToSignResultState state, TextTheme tt) {
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
                      style: tt.bodyLarge!
                          .copyWith(color: EsharaTheme.textPrimary),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        '${state.signVideo.inputText.length} / 200',
                        style: tt.bodySmall,
                      ),
                      const Spacer(),
                      const Icon(Icons.copy_rounded,
                          size: 18, color: EsharaTheme.textHint),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── label ─────────────────────────────────────────────────────
          Text('الترجمة الإشارية',
              style: tt.headlineMedium!
                  .copyWith(color: EsharaTheme.textPrimary)),

          const SizedBox(height: 12),

          // ── Video Player ──────────────────────────────────────────────
          SignVideoPlayer(
            signVideo: state.signVideo,
            isPlaying: state.isPlaying,
            onPlayPause: () {
              // TODO: toggle video playback
            },
            onDownload: () {
              context
                  .read<TextToSignBloc>()
                  .add(DownloadVideoEvent(videoUrl: state.signVideo.videoUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جارٍ تحميل الفيديو...')),
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
}
