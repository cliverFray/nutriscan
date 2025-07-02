import 'package:flutter/material.dart';
import '../models/detectionHistory.dart';

class DetectionDetailScreen extends StatelessWidget {
  final DetectionHistory detection;

  const DetectionDetailScreen({Key? key, required this.detection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? diagnostico = detection.detectionResult;
    final String? recomendacion = detection.immediateRecommendation;
    final String? confidence = detection.confidence;

    final Map<String, Color> diagnosticoColors = {
      'Con desnutrición': Colors.red,
      'Normal': Colors.green,
      'Riesgo en desnutrición': Colors.orange,
    };

    final Color diagnosticoColor =
        diagnosticoColors[diagnostico] ?? Colors.grey;

    final String mensajeDiagnostico = diagnostico == 'Normal'
        ? 'El niño se encuentra en buen estado de salud.'
        : diagnostico ?? 'Diagnóstico desconocido';

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Resultado de la detección"),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Resultados de la detección',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image.network(
              detection.detectionImageUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              mensajeDiagnostico,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: diagnosticoColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            if (confidence != null)
              Column(
                children: [
                  Text(
                    'Precisión del modelo:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$confidence%',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  if (double.tryParse(confidence) != null &&
                      double.parse(confidence!) < 80)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'La precisión del modelo es baja. Se recomienda repetir la detección con una mejor imagen.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.orange),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            SizedBox(height: 20),
            Column(
              children: [
                CategoryLabel('Saludable', Colors.green),
                CategoryLabel('Riesgos en Desnutrición', Colors.orange),
                CategoryLabel('Con desnutrición', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Recomendación inmediata:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              recomendacion ?? 'No se pudo mostrar recomendaciones inmediatas.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Color(0xFFEAF6EC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                'Este resultado es preliminar y puede variar si no se ingresaron datos de peso y talla. '
                'Incluso si se ingresaron dichos datos, se recomienda acudir al centro de salud al menos una vez al mes para una evaluación médica completa.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryLabel extends StatelessWidget {
  final String label;
  final Color color;

  CategoryLabel(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
