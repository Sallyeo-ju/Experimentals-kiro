import '../models/stock_models.dart';

/// Stock data contract, covering lists and full detail with chart, technicals,
/// fundamentals, and news.
abstract class StockService {
  Future<List<Stock>> localStocks();

  Future<List<Stock>> favorites();

  Future<List<Stock>> recentlySearched();

  Future<StockDetail> detail(String ticker);
}
