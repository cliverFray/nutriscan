import 'package:flutter/material.dart';
import '../services/child_service.dart';
import 'detection_history_screen.dart';
import 'register_child_screen.dart';
import 'take_or_pick_photo_screen.dart';

class DeteccionScreen extends StatefulWidget {
  @override
  _DeteccionScreenState createState() => _DeteccionScreenState();
}

class _DeteccionScreenState extends State<DeteccionScreen> {
  List<Map<String, dynamic>> children = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchChildrenNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Detecta la desnutrición',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Imagen de un padre tomando foto al niño
            Center(
              child: Image.asset(
                'assets/images/foto_padre_niño.jpg',
                height: 200,
              ),
            ),
            SizedBox(height: 16),

            // Subtítulo y descripción
            Text(
              'Detecta y actúa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Utiliza la inteligencia artificial para analizar la foto facial de tu hijo y detectar posibles signos de desnutrición, basándose en los datos que conoces como el nombre, edad y género. Si no cuentas con el peso y la talla actuales, la precisión puede ser menor, pero al proporcionar estos datos, la detección será más precisa.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Subtítulo y descripción
            Text(
              'Consideraciones para tomar la foto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Consideraciones con íconos
            _buildConsiderationItem(Icons.lightbulb_outline,
                'Asegúrate de que el rostro del niño esté bien iluminado.'),
            _buildConsiderationItem(
                Icons.brightness_2, 'Evita sombras en la cara.'),
            _buildConsiderationItem(Icons.camera_alt_outlined,
                'Mantén la cámara a la altura de los ojos del niño.'),
            _buildConsiderationItem(Icons.visibility,
                'Asegúrate de que el niño mire directamente a la cámara.'),
            _buildConsiderationItem(Icons.no_accounts_outlined,
                'Evita accesorios como gorros o gafas.'),
            _buildConsiderationItem(Icons.hide_image_outlined,
                'Asegúrate de que la foto no pese demasiado.'),
            _buildConsiderationItem(
                Icons.tune, 'Evite usar filtros para tomar la foto.'),

            SizedBox(height: 16),

            // Botón "Tomar o subir foto"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showSelectChildDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF83B56A),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tomar o subir foto',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Texto para ver el historial
            Center(
              child: TextButton(
                onPressed: () {
                  // Acción para ver el historial
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetectionHistoryScreen()),
                  );
                },
                child: Text(
                  'Ver historial',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF83B56A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir las consideraciones
  Widget _buildConsiderationItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF83B56A), size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo para seleccionar al niño
  // Diálogo para seleccionar al niño
  void _showSelectChildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchChildrenNames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: Text('Seleccione al niño'),
                content: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error al cargar los niños. Intenta nuevamente.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cerrar"),
                  ),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AlertDialog(
                title: Text('Sin niños registrados'),
                content: Text(
                    'No hay niños registrados. Registra un niño antes de continuar.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterChildScreen()),
                      );
                    },
                    child: Text("Registrar"),
                  ),
                ],
              );
            } else {
              List<Map<String, dynamic>> children = snapshot.data!;
              Map<String, dynamic>? selectedChild;

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Seleccione al niño'),
                    content: DropdownButtonFormField<Map<String, dynamic>>(
                      hint: Text("Selecciona un niño"),
                      value: selectedChild,
                      isExpanded: true,
                      items: children.map((child) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: child,
                          child: Text(child['childName']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedChild = value;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (selectedChild != null) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TakeOrPickPhotoScreen(
                                  childId: selectedChild?['childId'],
                                ),
                              ),
                            );
                          }
                        },
                        child: Text("Continuar"),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchChildrenNames() async {
    try {
      final ChildService childService = ChildService();
      final names = await childService.getChildrenNames();
      return names;
    } catch (e) {
      print('Error al obtener los nombres: $e');
      return [];
    }
  }
}
