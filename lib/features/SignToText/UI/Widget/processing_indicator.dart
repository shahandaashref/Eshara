import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

import '../bloc/sign_state.dart';

class ProcessingIndicator extends StatelessWidget {
  final double progress;
  final List<ProcessingStep> steps;

  const ProcessingIndicator({
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
        // Circular progress
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: EsharaTheme.border,
                valueColor: const AlwaysStoppedAnimation(EsharaTheme.primaryBlue),
              ),
              Center(
                child: Text(
                  '$percent%',
                  style: tt.displaySmall!.copyWith(
                    color: EsharaTheme.primaryBlue,
                  ),
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

        const SizedBox(height: 24),

        // Steps list
        ...steps.map((step) => _StepRow(step: step)),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final ProcessingStep step;

  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    Widget icon;
    Color color;

    switch (step.status) {
      case StepStatus.done:
        icon = const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF10B981));
        color = const Color(0xFF10B981);
        break;
      case StepStatus.inProgress:
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
      case StepStatus.pending:
        icon = Icon(Icons.radio_button_unchecked_rounded,
            size: 18, color: EsharaTheme.border);
        color = EsharaTheme.textHint;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            step.label,
            style: tt.bodyMedium!.copyWith(color: color),
          ),
          const SizedBox(width: 10),
          icon,
        ],
      ),
    );
  }
}
