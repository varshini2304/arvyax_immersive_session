import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool filledGradient;
  final bool outlined;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const TagChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.filledGradient = false,
    this.outlined = true,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    final chipPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);

    final foreground = selected
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.88);

    final decoration = BoxDecoration(
      borderRadius: radius,
      gradient: selected && filledGradient
          ? const LinearGradient(
              colors: [AppColors.deepIndigo, AppColors.calmBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: selected && !filledGradient
          ? AppColors.deepIndigo.withOpacity(0.85)
          : Colors.white.withOpacity(0.12),
      border: outlined && !selected
          ? Border.all(color: Colors.white.withOpacity(0.22))
          : null,
      boxShadow: selected
          ? [
              BoxShadow(
                color: AppColors.accentGlow.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          decoration: decoration,
          child: Padding(
            padding: chipPadding,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
