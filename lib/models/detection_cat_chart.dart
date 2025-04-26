// detection_result.dart
class DetectionResult {
  final String category;
  final int count;

  DetectionResult({
    required this.category,
    required this.count,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      category: json['category'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'count': count,
    };
  }
}
