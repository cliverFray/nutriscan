// pregnancy_tip.dart
class PregnancyTip {
  final int pregnancyTipId;
  final String pregnancyTipContent;
  final String pregnancyTipStage;
  final DateTime pregnancyTipDate;
  final String pregnancyTipCategory;

  PregnancyTip({
    required this.pregnancyTipId,
    required this.pregnancyTipContent,
    required this.pregnancyTipStage,
    required this.pregnancyTipDate,
    required this.pregnancyTipCategory,
  });

  factory PregnancyTip.fromJson(Map<String, dynamic> json) {
    return PregnancyTip(
      pregnancyTipId: json['pregnancyTipId'],
      pregnancyTipContent: json['pregnancyTipContent'],
      pregnancyTipStage: json['pregnancyTipStage'],
      pregnancyTipDate: DateTime.parse(json['pregnancyTipDate']),
      pregnancyTipCategory: json['pregnancyTipCategory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pregnancyTipId': pregnancyTipId,
      'pregnancyTipContent': pregnancyTipContent,
      'pregnancyTipStage': pregnancyTipStage,
      'pregnancyTipDate': pregnancyTipDate.toIso8601String(),
      'pregnancyTipCategory': pregnancyTipCategory,
    };
  }
}
