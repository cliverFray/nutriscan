// nutritional_recommendation.dart
import 'child.dart';

class NutritionalRecommendation {
  final int recommendationId;
  final String recommendationTitle;
  final String recommendationDescription;
  final String recommendationType;
  final Child child; // Relación con Child

  NutritionalRecommendation({
    required this.recommendationId,
    required this.recommendationTitle,
    required this.recommendationDescription,
    required this.recommendationType,
    required this.child, // Cambiado a Child
  });

  factory NutritionalRecommendation.fromJson(Map<String, dynamic> json) {
    return NutritionalRecommendation(
      recommendationId: json['recommendationId'],
      recommendationTitle: json['recommendationTitle'],
      recommendationDescription: json['recommendationDescription'],
      recommendationType: json['recommendationType'],
      child: Child.fromJson(
          json['child']), // Crear un objeto Child a partir del JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendationId': recommendationId,
      'recommendationTitle': recommendationTitle,
      'recommendationDescription': recommendationDescription,
      'recommendationType': recommendationType,
      'child': child.toJson(), // Convertir el objeto Child a JSON
    };
  }
}
