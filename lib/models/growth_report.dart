// growth_report.dart
import 'child.dart'; // Importar la clase Child

class GrowthReport {
  final int reportId;
  final DateTime reportDate;
  final String reportDescription;
  final String reportUrl;
  final Child child; // Relación con la clase Child

  GrowthReport({
    required this.reportId,
    required this.reportDate,
    required this.reportDescription,
    required this.reportUrl,
    required this.child,
  });

  factory GrowthReport.fromJson(Map<String, dynamic> json) {
    return GrowthReport(
      reportId: json['reportId'],
      reportDate: DateTime.parse(json['reportDate']),
      reportDescription: json['reportDescription'],
      reportUrl: json['reportUrl'],
      child: Child.fromJson(json['child']), // Parseamos el objeto Child
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reportDate': reportDate.toIso8601String(),
      'reportDescription': reportDescription,
      'reportUrl': reportUrl,
      'child': child.toJson(), // Convertimos el objeto Child a JSON
    };
  }
}
