import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';
import '../bloc/text_to_sign_state_event.dart';

/// [Widget] — TextToSignProcessing
/// بيتعرض في حالة [TextToSignProcessingState]
/// بيظهر circular progress + خطوات التحويل
class TextToSignProcessing extends StatelessWidget {
  final double progress;
  final List<TextToSignStep> steps;

  const TextToSignProcessing({
    super.key,
    required this.progress,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final percent = (progress * 100).toInt();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        // ── Circular Progress ─────────────────────────────────────────
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 7,
                backgroundColor: EsharaTheme.border,
                valueColor:
                    const AlwaysStoppedAnimation(EsharaTheme.primaryBlue),
              ),
              Center(
                child: Text(
                  '$percent%',
                  style: tt.displaySmall!
                      .copyWith(color: EsharaTheme.primaryBlue),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'جارٍ تحليل بنية الإشارة...',
          style: tt.bodyMedium!.copyWith(color: EsharaTheme.textSecondary),
        ),

        const SizedBox(height: 8),

        // نقطة الـ animation
        _PulseDot(),

        const SizedBox(height: 24),

        // ── Steps ─────────────────────────────────────────────────────
        ...steps.map((step) => _StepRow(step: step)),

        const SizedBox(height: 16),

        Text(
          'جارٍ إجراء تحليل عميق .... يرجى الانتظار',
          style: tt.bodySmall!.copyWith(color: EsharaTheme.textHint),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Step Row ───────────────────────────────────────────────────────────────
class _StepRow extends StatelessWidget {
  final TextToSignStep step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Widget icon;
    Color color;

    switch (step.status) {
      case TextToSignStepStatus.done:
        icon = const Icon(Icons.check_box_rounded,
            size: 18, color: EsharaTheme.primaryBlue);
        color = EsharaTheme.primaryBlue;
        break;
      case TextToSignStepStatus.inProgress:
        icon = SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(EsharaTheme.primaryBlue),
          ),
        );
        color = EsharaTheme.primaryBlue;
        break;
      case TextToSignStepStatus.pending:
        icon = Icon(Icons.check_box_outline_blank_rounded,
            size: 18, color: EsharaTheme.border);
        color = EsharaTheme.textHint;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(step.label,
              style: tt.bodyMedium!.copyWith(color: color)),
          const SizedBox(width: 10),
          icon,
        ],
      ),
    );
  }
}

// ── Pulse Dot ──────────────────────────────────────────────────────────────
/// [Widget] — _PulseDot
/// النقطة الخضرا اللي بتـ pulse في حالة الـ processing
class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: EsharaTheme.success,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
