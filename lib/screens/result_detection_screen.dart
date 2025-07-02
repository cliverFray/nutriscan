import 'package:flutter/material.dart';
import 'dart:io';

import '../widgets/custom_elevated_button_2.dart';
import 'detection_history_screen.dart';
import 'nutri_recom.dart';

import 'bottom_nav_menu.dart';
import 'support_screen.dart';

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

    // Extraer el valor de confidence
    final String? confidence = detectionData['confidence'];

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
                  buttonText: "Ir a soporte",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SupportScreen()),
                    );
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
      'Riesgo en desnutrición': Colors.orange,
    };

    final Color diagnosticoColor =
        diagnosticoColors[diagnostico] ?? Colors.grey;

    // Texto personalizado si el niño está saludable
    final String mensajeDiagnostico = diagnostico == 'Normal'
        ? 'El niño se encuentra en buen estado de salud.'
        : diagnostico;

    return PopScope(
      canPop: false, // false para bloquear el retroceso
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Resultados de la detección"),
          backgroundColor: Color(0xFF83B56A),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false, //
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
              SizedBox(height: 16),

// Precisión del modelo (si está disponible)
              if (detectionData['confidence'] != null)
                Column(
                  children: [
                    Text(
                      'Precisión del modelo:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${detectionData['confidence']}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),

                    // Indicador visual si la precisión es baja (< 80%)
                    if (double.tryParse(confidence ?? '100') != null &&
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
                recomendacion ??
                    'No se pudo mostrar recomendaciones inmediatas.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),

              // Mensaje final
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
              SizedBox(height: 20),
              Center(
                child: CustomButton2(
                  buttonText: "Ver recomendaciones",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NutritionalRecommendationsScreen(
                                  showAppBar: true)),
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  'Nueva detección',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Center(
                child: CustomButton2(
                  buttonText: "Ir a home",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavMenu(initialIndex: 0),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
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
