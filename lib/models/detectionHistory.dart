// detection.dart
class DetectionHistory {
  final int detectionId;
  final String detectionDate;
  final String detectionResult;
  final String detectionImageUrl;
  final int childId;
  final String childName;

  DetectionHistory({
    required this.detectionId,
    required this.detectionDate,
    required this.detectionResult,
    required this.detectionImageUrl,
    required this.childId,
    required this.childName,
  });

  factory DetectionHistory.fromJson(Map<String, dynamic> json) {
    return DetectionHistory(
      detectionId: json['detectionId'],
      detectionDate: json['detectionDate'],
      detectionResult: json['detectionResult'],
      detectionImageUrl: json['detectionImageUrl'],
      childId: json['childId'],
      childName: json['childName'],
    );
  }
}
