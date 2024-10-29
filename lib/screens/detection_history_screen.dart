import 'package:flutter/material.dart';

class DetectionHistoryScreen extends StatefulWidget {
  @override
  _HistorialDeteccionesScreenState createState() =>
      _HistorialDeteccionesScreenState();
}

class _HistorialDeteccionesScreenState extends State<DetectionHistoryScreen> {
  String? selectedChild;
  List<String> children = [
    "Juan",
    "Joel",
    "Gabo",
  ]; // Simulación de la lista de niños
  List<Map<String, dynamic>> detections = [
    {
      "name": "Juan",
      "date": "2024-09-25",
      "result": "Saludable",
      "photo": "assets/images/sanjuan.jpg",
    },
    {
      "name": "Joel",
      "date": "2024-09-17",
      "result": "Desnutrido",
      "photo": "assets/images/desnjoe.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonFormField<String>(
                hint: Text("Selecciona un niño"),
                value: selectedChild,
                isExpanded: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                items: children.map((String child) {
                  return DropdownMenuItem<String>(
                    value: child,
                    child: Text(child),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChild = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: detections.length,
                itemBuilder: (context, index) {
                  final detection = detections[index];

                  Color cardColor;
                  if (detection['result'] == 'Desnutrido') {
                    cardColor = Colors.red[300]!;
                  } else {
                    cardColor = Colors.green[300]!;
                  }

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
                                child: Image.asset(
                                  detection['photo'],
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
                                      detection['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Fecha: ${detection['date']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      'Resultado: ${detection['result']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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
                              onPressed: () {
                                _showDetailsDialog(context, detection);
                              },
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
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF),
                                ),
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

  void _showDetailsDialog(
      BuildContext context, Map<String, dynamic> detection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la detección'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen del niño
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  detection['photo'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              // Información adicional
              Text('Nombre: ${detection['name']}'),
              Text('Fecha: ${detection['date']}'),
              Text('Resultado: ${detection['result']}'),
              SizedBox(height: 16),
              // Recomendaciones basadas en el resultado
              if (detection['result'] == 'Desnutrido')
                Text(
                  'Recomendaciones: Consulte a su médico y mejore la dieta del niño.',
                  style: TextStyle(color: Colors.red),
                )
              else
                Text(
                  'Recomendaciones: El niño está saludable. Continúe con los buenos hábitos alimenticios.',
                  style: TextStyle(color: Colors.green),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
