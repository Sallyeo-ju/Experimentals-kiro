import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/favorites/favorites_controller.dart';
import '../theme/app_colors.dart';

/// A heart toggle that favorites or unfavorites a ticker.
///
/// Favoriting is an action, not a data signal, so the active heart uses the
/// gold accent rather than the green or red data colors. The inactive heart is
/// an outline in a muted tone that suits whichever canvas it sits on.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.ticker,
    this.onTeal = false,
    this.size = 22,
  });

  final String ticker;

  /// When true the inactive heart uses a light tone for the teal canvas,
  /// otherwise a muted tone for off-white surfaces.
  final bool onTeal;

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFavorite = ref.watch(
      favoritesProvider.select((s) => s.contains(ticker.toUpperCase())),
    );
    final Color inactive =
        onTeal ? AppColors.textOnTeal2 : AppColors.textSecondary;
    return IconButton(
      onPressed: () =>
          ref.read(favoritesProvider.notifier).toggle(ticker),
      visualDensity: VisualDensity.compact,
      tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? AppColors.accent : inactive,
        size: size,
      ),
    );
  }
}
