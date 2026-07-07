import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:eshara/Core/di/injection_container.dart';

import '../bloc/text_to_sign_bloc.dart';
import '../bloc/text_to_sign_state_event.dart';
import '../widgets/text_input_card.dart';
import '../widgets/text_to_sign_processing.dart';

/// [Page] — TextToSignPage
/// بتعرض 3 states: Idle | Processing | Result (WebView)
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
        body: BlocConsumer<TextToSignBloc, TextToSignState>(
          listener: (context, state) {
            if (state is TextToSignErrorState) {
              SnackbarHelper.showCustomSnackBar(context, state.message);
              context.read<TextToSignBloc>().add(ResetTextToSignEvent());
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildAppBar(context, tt, state),
                Expanded(
                  child: switch (state) {
                    TextToSignProcessingState() => _buildProcessingScreen(
                      context,
                      state,
                      tt,
                    ),
                    TextToSignResultState() => _buildResultBody(
                      context,
                      state,
                      tt,
                    ),
                    _ => _buildIdleBody(context, tt),
                  },
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
          TextInputCard(
            controller: _textController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _textController.text.trim().isEmpty
                ? null
                : () => _onConvert(context),
            child: const Text('تحويل إلى إشارة'),
          ),
          const SizedBox(height: 24),
          Text(
            'الترجمة الإشارية',
            style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary),
          ),
          const SizedBox(height: 12),
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
                    'سيظهر الأفاتار ثلاثي الأبعاد هنا',
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

  // ── State: Processing ──────────────────────────────────────────────────────
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

  // ── State: Result (WebView) ────────────────────────────────────────────────
  Widget _buildResultBody(
    BuildContext context,
    TextToSignResultState state,
    TextTheme tt,
  ) {
    final signVideo = state.signVideo;

    return Column(
      children: [
        // ── النص المكتوب ────────────────────────────────────────────
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: EsharaTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: EsharaTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (signVideo.simplifiedText != null &&
                  signVideo.simplifiedText != signVideo.originalText) ...[
                Text(
                  'النص المبسط:',
                  style: tt.bodySmall?.copyWith(color: EsharaTheme.textHint),
                ),
                const SizedBox(height: 4),
                Text(
                  signVideo.simplifiedText!,
                  style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary),
                  textDirection: TextDirection.rtl,
                ),
                const Divider(height: 16),
              ],
              Text(
                signVideo.inputText,
                style: tt.bodyMedium!.copyWith(color: EsharaTheme.textSecondary),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),

        // ── WebView للأفاتار ──────────────────────────────────────────
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EsharaTheme.border, width: 2),
            ),
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(signVideo.avatarPlayerUrl)),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Gloss Sequence ────────────────────────────────────────────
        if (signVideo.glossSequence != null &&
            signVideo.glossSequence!.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EsharaTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'كلمات الإشارة:',
                  style: tt.bodySmall?.copyWith(color: EsharaTheme.textHint),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: signVideo.glossSequence!.map((gloss) {
                    final color = gloss.matched
                        ? EsharaTheme.success
                        : EsharaTheme.error;
                    return Chip(
                      label: Text(
                        gloss.gloss,
                        style: tt.bodySmall?.copyWith(color: Colors.white),
                      ),
                      backgroundColor: color,
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  void _onConvert(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<TextToSignBloc>().add(ConvertTextEvent(text: text));
  }

  void _onReset(BuildContext context) {
    _textController.clear();
    context.read<TextToSignBloc>().add(ResetTextToSignEvent());
  }
}