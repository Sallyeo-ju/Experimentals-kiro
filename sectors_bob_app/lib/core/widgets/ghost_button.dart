import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A low-emphasis button for teal backgrounds.
///
/// Transparent fill with a light border and light text, so it reads clearly on
/// the immersive teal canvas (splash, onboarding) without competing with the
/// gold primary action. It carries no data-signal color.
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;

  /// When true the button stretches to fill the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Widget button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textOnTeal,
        side: const BorderSide(color: AppColors.textOnTeal2),
        backgroundColor: Colors.transparent,
      ),
      child: Text(label, overflow: TextOverflow.ellipsis),
    );

    if (!expand) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }
}
