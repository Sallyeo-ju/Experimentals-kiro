import 'package:flutter_test/flutter_test.dart';
import 'package:sectors_bob_app/services/mock/mock_learn_service.dart';
import 'package:sectors_bob_app/services/models/learn_models.dart';

void main() {
  group('MockLearnService', () {
    final MockLearnService service = MockLearnService();

    test('returns videos including exactly one real, verified video', () async {
      final List<LearnVideo> videos = await service.videos();
      expect(videos, isNotEmpty);

      final List<LearnVideo> real =
          videos.where((LearnVideo v) => v.isReal).toList();
      expect(real, hasLength(1));

      // The single real video is the verified IDX one.
      expect(real.single.youtubeId, 'GbhUcCavPvo');
      expect(real.single.channel, contains('IDX'));
    });

    test('every video exposes a watch URL and a thumbnail URL', () async {
      final List<LearnVideo> videos = await service.videos();
      for (final LearnVideo v in videos) {
        expect(v.watchUrl, contains(v.youtubeId));
        expect(v.thumbnailUrl, contains(v.youtubeId));
      }
    });

    test('returns market news articles', () async {
      final List<LearnArticle> articles = await service.articles();
      expect(articles, isNotEmpty);
      for (final LearnArticle a in articles) {
        expect(a.title, isNotEmpty);
        expect(a.source, isNotEmpty);
      }
    });
  });
}
