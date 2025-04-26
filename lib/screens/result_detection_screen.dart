import 'package:flutter/material.dart';
import 'dart:io';

import '../widgets/custom_elevated_button_2.dart';
import 'detection_history_screen.dart';
import 'nutri_recom.dart';

class ResultDetectionScreen extends StatelessWidget {
  final File imagenAnalizada;
  final Map<String, String?> detectionData;

  const ResultDetectionScreen({
    Key? key,
    required this.imagenAnalizada,
    required this.detectionData,
  }) : super(key: key);

  static ResultDetectionScreen fromArguments(Map<String, dynamic> args) {
    return ResultDetectionScreen(
      imagenAnalizada: args['imagenAnalizada'] as File,
      detectionData: args['detectionData'] as Map<String, String?>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? diagnostico = detectionData['detectionResult'];
    final String? recomendacion = detectionData['immediateRecommendation'];

    // Manejo de error si no hay datos válidos
    if (diagnostico == null || diagnostico == 'Error') {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error en la detección"),
          backgroundColor: Color(0xFF83B56A),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 60),
                SizedBox(height: 20),
                Text(
                  'Ocurrió un error al analizar la imagen.\nPor favor, intenta nuevamente con otra foto o contacta con soporte si el problema persiste.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButton2(
                  buttonText: "Volver a intentar",
                  onPressed: () {
                    Navigator.pop(context); // Vuelve a la pantalla anterior
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Colores para diagnóstico
    final Map<String, Color> diagnosticoColors = {
      'Con desnutrición': Colors.red,
      'Normal': Colors.green,
      'Riesgo en desnutricion': Colors.orange,
    };

    final Color diagnosticoColor =
        diagnosticoColors[diagnostico] ?? Colors.grey;

    // Texto personalizado si el niño está saludable
    final String mensajeDiagnostico = diagnostico == 'Normal'
        ? 'El niño se encuentra en buen estado de salud.'
        : diagnostico;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Resultados de la detección"),
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
            Image.file(
              imagenAnalizada,
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
            SizedBox(height: 20),
            Center(
              child: CustomButton2(
                buttonText: "Ver recomendaciones",
                onPressed: () {
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
                Navigator.pop(context); // Volver para una nueva detección
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
