import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A labelled progress bar for one macronutrient. Shared by the home
/// summary card and the Nutrition history screen so both use the same
/// visual language for "grams out of a rough daily reference".
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.label,
    required this.grams,
    required this.maxGrams,
  });

  final String label;
  final double? grams;
  final double maxGrams;

  @override
  Widget build(BuildContext context) {
    final double fraction = grams == null
        ? 0.0
        : (grams! / maxGrams).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            Text(
              '${grams != null ? grams!.round() : '—'}/${maxGrams.round()}g',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
          ),
        ),
      ],
    );
  }
}
