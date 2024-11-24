import 'package:flutter/material.dart';
import 'dart:io';

import '../widgets/custom_elevated_button_2.dart';
import 'detection_history_screen.dart';
import 'nutri_recom.dart';

class ResultDetectionScreen extends StatelessWidget {
  final File imagenAnalizada;
  final Map<String, String?> detectionData;

  ResultDetectionScreen({
    required this.imagenAnalizada,
    required this.detectionData,
  });

  @override
  Widget build(BuildContext context) {
    // Extrae los valores de diagnóstico y recomendación desde detectionData
    final String diagnostico =
        detectionData['detectionResult'] ?? 'Diagnóstico desconocido';
    final String recomendacionInmediata =
        detectionData['immediateRecommendation'] ??
            'No se encontró una recomendación.';
    // Define el color y el estado de salud en base al diagnóstico
    final Map<String, Color> diagnosticoColors = {
      'Con desnutrición': Colors.red,
      'Normal': Colors.green,
      'Riesgo en desnutricion': Colors.orange,
    };

    final Color diagnosticoColor =
        diagnosticoColors[diagnostico] ?? Colors.grey;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Resultados de la detección"),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Color(
            0xFFFFFFFF), // Puedes cambiar el color del AppBar si lo deseas
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
            // Muestra la imagen analizada
            Image.file(
              imagenAnalizada,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              diagnostico,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: diagnosticoColor,
              ),
              textAlign: TextAlign.center,
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
              recomendacionInmediata,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Center(
              child: CustomButton2(
                buttonText: "Ver recomendaciones",
                onPressed: () {
                  // Acción para ver historial
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NutritionalRecommendationsScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Acción para ver historial
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetectionHistoryScreen()),
                );
              },
              child: Text(
                'Ver historial',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Acción para realizar una nueva detección
              },
              child: Text(
                'Nueva detección',
                style: TextStyle(color: Colors.blue),
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
