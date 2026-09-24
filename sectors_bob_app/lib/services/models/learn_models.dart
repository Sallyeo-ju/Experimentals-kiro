/// Models for the Belajar tab: educational videos and general market news.
library;

/// A learning video. [youtubeId] is the 11-character YouTube video id used to
/// build the watch URL and the thumbnail. [isReal] flags whether this points at
/// a genuine, verified public video (opens YouTube) or is an illustrative mock
/// entry, so the UI can be honest about placeholders instead of showing dead
/// links.
class LearnVideo {
  const LearnVideo({
    required this.title,
    required this.channel,
    required this.youtubeId,
    required this.durationLabel,
    this.isReal = false,
  });

  final String title;
  final String channel;
  final String youtubeId;
  final String durationLabel;
  final bool isReal;

  /// The canonical watch URL for this video.
  String get watchUrl => 'https://www.youtube.com/watch?v=$youtubeId';

  /// The high-quality thumbnail URL served by YouTube for this video id.
  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';

  factory LearnVideo.fromJson(Map<String, dynamic> json) {
    return LearnVideo(
      title: json['title'] as String,
      channel: json['channel'] as String,
      youtubeId: json['youtubeId'] as String,
      durationLabel: json['durationLabel'] as String,
      isReal: json['isReal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'channel': channel,
      'youtubeId': youtubeId,
      'durationLabel': durationLabel,
      'isReal': isReal,
    };
  }
}

/// A market news article for the Berita segment of the Belajar tab.
class LearnArticle {
  const LearnArticle({
    required this.title,
    required this.source,
    required this.timeAgo,
    required this.summary,
  });

  final String title;
  final String source;
  final String timeAgo;
  final String summary;

  factory LearnArticle.fromJson(Map<String, dynamic> json) {
    return LearnArticle(
      title: json['title'] as String,
      source: json['source'] as String,
      timeAgo: json['timeAgo'] as String,
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'source': source,
      'timeAgo': timeAgo,
      'summary': summary,
    };
  }
}
