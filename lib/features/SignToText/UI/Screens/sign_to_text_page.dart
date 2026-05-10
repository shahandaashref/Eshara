import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/features/SignToText/UI/Widget/camera_preview_widget.dart';
import 'package:eshara/features/SignToText/UI/Widget/processing_indicator.dart';
import 'package:eshara/features/SignToText/UI/Widget/translation_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/app_bottom_nav.dart';
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
  int _navIndex = 1;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            _buildAppBar(context, tt),
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
        bottomNavigationBar: AppBottomNav(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
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
          // Back button
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
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
          Text(AppStrings.signToTextPageTitle, style: tt.headlineLarge),
          const Spacer(),
          // Refresh
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: EsharaTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              size: 18,
              color: EsharaTheme.textSecondary,
            ),
          ),
        ],
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
            child: CameraPreviewWidget(isRecording: isRecording),
          ),

          const SizedBox(height: 20),

          // Action buttons
          if (!isRecording)
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<SignBloc>().add(StartRecordingEvent()),
              icon: const Icon(Icons.videocam_rounded, size: 20),
              label: Text(AppStrings.startRecognition),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        context.read<SignBloc>().add(CancelRecordingEvent()),
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
                    onPressed: () => context.read<SignBloc>().add(
                          StopRecordingEvent(videoPath: 'mock_path'),
                        ),
                    child: Text(AppStrings.stopRecording),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Translation results placeholder
          _buildResultsPlaceholder(tt),
        ],
      ),
    );
  }

  // ── State: Processing ─────────────────────────────────────────────────────
  Widget _buildProcessingBody(
      BuildContext context, SignProcessingState state, TextTheme tt) {
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
              color: const Color(0xFF1A1A2E),
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
            onPressed: () =>
                context.read<SignBloc>().add(CancelRecordingEvent()),
            style: OutlinedButton.styleFrom(
              foregroundColor: EsharaTheme.error,
              side: const BorderSide(color: EsharaTheme.error),
            ),
            child: Text(AppStrings.cancel),
          ),

          const SizedBox(height: 24),
          _buildResultsPlaceholder(tt),
        ],
      ),
    );
  }

  // ── State: Result ─────────────────────────────────────────────────────────
  Widget _buildResultBody(
      BuildContext context, SignResultState state, TextTheme tt) {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.all(20),
      child: TranslationResultCard(
        translation: state.translation,
        onNewTranslation: () =>
            context.read<SignBloc>().add(ResetEvent()),
      ),
    );
  }

  // ── State: Error ──────────────────────────────────────────────────────────
  Widget _buildErrorBody(
      BuildContext context, SignErrorState state, TextTheme tt) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: EsharaTheme.error),
            const SizedBox(height: 16),
            Text(state.message,
                style: tt.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<SignBloc>().add(ResetEvent()),
              child: const Text('حاول مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Results placeholder (under camera) ───────────────────────────────────
  Widget _buildResultsPlaceholder(TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.translationResults,
          style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: EsharaTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: EsharaTheme.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppStrings.signLanguage,
                style: tt.bodySmall,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.translate_rounded,
                  size: 16, color: EsharaTheme.primaryBlue),
            ],
          ),
        ),
      ],
    );
  }
}