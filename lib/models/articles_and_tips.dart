// articles_and_tips.dart
class ArticleTip {
  final int articleTipId;
  final String articleTipTitle;
  final String articleTipContent;
  final String articleTipType;
  final DateTime articleTipPublicationDate;

  ArticleTip({
    required this.articleTipId,
    required this.articleTipTitle,
    required this.articleTipContent,
    required this.articleTipType,
    required this.articleTipPublicationDate,
  });

  factory ArticleTip.fromJson(Map<String, dynamic> json) {
    return ArticleTip(
      articleTipId: json['articleTipId'],
      articleTipTitle: json['articleTipTitle'],
      articleTipContent: json['articleTipContent'],
      articleTipType: json['articleTipType'],
      articleTipPublicationDate:
          DateTime.parse(json['articleTipPublicationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articleTipId': articleTipId,
      'articleTipTitle': articleTipTitle,
      'articleTipContent': articleTipContent,
      'articleTipType': articleTipType,
      'articleTipPublicationDate': articleTipPublicationDate.toIso8601String(),
    };
  }
}
