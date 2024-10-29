// malnutrition_detection.dart
import 'child.dart'; // Importar la clase Child
import 'health_center.dart'; // Importar la clase HealthCenter

class MalnutritionDetection {
  final int detectionId;
  final DateTime detectionDate;
  final String detectionResult;
  final String detectionImageUrl;
  final Child child; // Relación con la clase Child
  final HealthCenter healthCenter; // Relación con la clase HealthCenter

  MalnutritionDetection({
    required this.detectionId,
    required this.detectionDate,
    required this.detectionResult,
    required this.detectionImageUrl,
    required this.child,
    required this.healthCenter,
  });

  factory MalnutritionDetection.fromJson(Map<String, dynamic> json) {
    return MalnutritionDetection(
      detectionId: json['detectionId'],
      detectionDate: DateTime.parse(json['detectionDate']),
      detectionResult: json['detectionResult'],
      detectionImageUrl: json['detectionImageUrl'],
      child: Child.fromJson(json['child']), // Parseamos el objeto Child
      healthCenter: HealthCenter.fromJson(
          json['healthCenter']), // Parseamos el objeto HealthCenter
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detectionId': detectionId,
      'detectionDate': detectionDate.toIso8601String(),
      'detectionResult': detectionResult,
      'detectionImageUrl': detectionImageUrl,
      'child': child.toJson(), // Convertimos el objeto Child a JSON
      'healthCenter':
          healthCenter.toJson(), // Convertimos el objeto HealthCenter a JSON
    };
  }
}
