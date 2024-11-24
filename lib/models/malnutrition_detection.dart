// malnutrition_detection.dart
import 'child.dart'; // Importar la clase Child

class MalnutritionDetection {
  final int detectionId;
  final DateTime detectionDate;
  final String detectionResult;
  final String detectionImageUrl;
  final Child child; // Relación con la clase Child

  MalnutritionDetection({
    required this.detectionId,
    required this.detectionDate,
    required this.detectionResult,
    required this.detectionImageUrl,
    required this.child,
  });

  factory MalnutritionDetection.fromJson(Map<String, dynamic> json) {
    return MalnutritionDetection(
      detectionId: json['detectionId'],
      detectionDate: DateTime.parse(json['detectionDate']),
      detectionResult: json['detectionResult'],
      detectionImageUrl: json['detectionImageUrl'],
      child: Child.fromJson(json['child']), // Parseamos el objeto Child
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detectionId': detectionId,
      'detectionDate': detectionDate.toIso8601String(),
      'detectionResult': detectionResult,
      'detectionImageUrl': detectionImageUrl,
      'child': child.toJson(), // Convertimos el objeto Child a JSON
    };
  }
}
