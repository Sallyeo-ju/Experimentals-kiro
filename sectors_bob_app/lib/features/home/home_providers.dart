import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/models/stock_models.dart';
import '../../services/providers.dart';

/// Local IDX stocks shown in the Saham Lokal list on Home.
final FutureProvider<List<Stock>> localStocksProvider =
    FutureProvider<List<Stock>>((ref) {
  return ref.watch(stockServiceProvider).localStocks();
});

/// The user's favorite stocks (also used as most searched on Home).
final FutureProvider<List<Stock>> favoritesProvider =
    FutureProvider<List<Stock>>((ref) {
  return ref.watch(stockServiceProvider).favorites();
});

/// Recently searched stocks shown in Riwayat Terakhir.
final FutureProvider<List<Stock>> recentlySearchedProvider =
    FutureProvider<List<Stock>>((ref) {
  return ref.watch(stockServiceProvider).recentlySearched();
});
