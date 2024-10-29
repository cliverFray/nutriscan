// daily_tips.dart
class DailyTip {
  final int dailyTipId;
  final String dailyTipContent;
  final DateTime dailyTipDate;
  final String dailyTipCategory;

  DailyTip({
    required this.dailyTipId,
    required this.dailyTipContent,
    required this.dailyTipDate,
    required this.dailyTipCategory,
  });

  factory DailyTip.fromJson(Map<String, dynamic> json) {
    return DailyTip(
      dailyTipId: json['dailyTipId'],
      dailyTipContent: json['dailyTipContent'],
      dailyTipDate: DateTime.parse(json['dailyTipDate']),
      dailyTipCategory: json['dailyTipCategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyTipId': dailyTipId,
      'dailyTipContent': dailyTipContent,
      'dailyTipDate': dailyTipDate.toIso8601String(),
      'dailyTipCategory': dailyTipCategory,
    };
  }
}
