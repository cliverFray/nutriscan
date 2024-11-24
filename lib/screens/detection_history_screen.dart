import 'dart:async';
import 'package:flutter/material.dart';
import '../models/detectionHistory.dart';
import '../services/detection_service.dart';
import 'dart:convert';

class DetectionHistoryScreen extends StatefulWidget {
  @override
  _DetectionHistoryScreenState createState() => _DetectionHistoryScreenState();
}

class _DetectionHistoryScreenState extends State<DetectionHistoryScreen> {
  final DetectionService _detectionService = DetectionService();
  List<DetectionHistory> detections = [];
  List<DetectionHistory> filteredDetections = [];
  String? selectedChild;

  // Mapa de colores basado en el resultado de la detección
  final Map<String, Color> diagnosticoColors = {
    'Con desnutrición': Colors.red[300]!,
    'Normal': Colors.green[300]!,
    'Riesgo en desnutricion': Colors.orange[300]!,
  };

  @override
  void initState() {
    super.initState();
    fetchDetections();
  }

  Future<void> fetchDetections() async {
    try {
      final fetchedDetections = await _detectionService.fetchDetectionHistory();
      setState(() {
        detections = fetchedDetections;
        filteredDetections = fetchedDetections;
      });
    } catch (e) {
      print('Error fetching detections: $e');
    }
  }

  void filterByChild(String? childName) {
    setState(() {
      if (childName == null || childName.isEmpty) {
        filteredDetections = detections;
      } else {
        filteredDetections =
            detections.where((d) => d.childName == childName).toList();
      }
      selectedChild = childName;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> childNames =
        detections.map((d) => d.childName).toSet().toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Historial de Detecciones'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por niño:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              hint: Text("Selecciona un niño"),
              value: selectedChild,
              isExpanded: true,
              items: childNames.map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: filterByChild,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDetections.length,
                itemBuilder: (context, index) {
                  final detection = filteredDetections[index];
                  final Color cardColor = diagnosticoColors[utf8
                          .decode(detection.detectionResult.runes.toList())] ??
                      Colors.grey;

                  return Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  detection.detectionImageUrl,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detection.childName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Fecha: ${detection.detectionDate}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white70),
                                    ),
                                    Text(
                                      'Resultado: ${utf8.decode(detection.detectionResult.runes.toList())}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _showDetailsDialog(context, detection),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Ver detalles',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, DetectionHistory detection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la detección'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  detection.detectionImageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text('Nombre: ${detection.childName}'),
              Text('Fecha: ${detection.detectionDate}'),
              Text(
                  'Resultado: ${utf8.decode(detection.detectionResult.runes.toList())}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
