import 'package:flutter/material.dart';

import '../data/posting_enums.dart';

class StageChip extends StatelessWidget {
  const StageChip(this.stage, {super.key});

  final ApplicationStage stage;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground) = switch (stage) {
      ApplicationStage.finalPassed => (colors.primary, colors.onPrimary),
      ApplicationStage.rejected => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
      ),
      ApplicationStage.onHold => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      ApplicationStage.interested => (
        colors.surfaceContainerHigh,
        colors.onSurface,
      ),
      _ => (colors.primaryContainer, colors.onPrimaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        stage.label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: foreground),
      ),
    );
  }
}
