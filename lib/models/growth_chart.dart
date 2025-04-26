// growth_chart_data.dart
class GrowthChartData {
  final List<String> dates;
  final List<double> weights;
  final List<double> heights;
  final String childName;

  GrowthChartData({
    required this.dates,
    required this.weights,
    required this.heights,
    required this.childName,
  });

  factory GrowthChartData.fromJson(Map<String, dynamic> json) {
    return GrowthChartData(
      dates: List<String>.from(json['dates']),
      weights: List<double>.from(json['weights'].map((x) => x.toDouble())),
      heights: List<double>.from(json['heights'].map((x) => x.toDouble())),
      childName: json['child_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dates': dates,
      'weights': weights,
      'heights': heights,
      'child_name': childName,
    };
  }
}
