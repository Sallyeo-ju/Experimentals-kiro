import '../models/learn_models.dart';

/// Content contract for the Belajar tab: educational videos and market news.
/// The mock implementation lives under services/mock; a real backend can
/// replace it without touching the UI.
abstract class LearnService {
  Future<List<LearnVideo>> videos();

  Future<List<LearnArticle>> articles();
}
