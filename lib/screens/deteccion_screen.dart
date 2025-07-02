import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/child_service.dart';
import '../services/detection_service.dart';
import 'detection_history_screen.dart';
import 'photo_examples_screen.dart';
import 'register_child_screen.dart';
import 'take_or_pick_photo_screen.dart';

class DeteccionScreen extends StatefulWidget {
  @override
  _DeteccionScreenState createState() => _DeteccionScreenState();
}

class _DeteccionScreenState extends State<DeteccionScreen> {
  List<Map<String, dynamic>> children = [];
  bool isLoading = true;

  bool _hasAcceptedRequirements = false;

  final detectionService = DetectionService();

  final ChildService _childService = ChildService();

  @override
  void initState() {
    super.initState();
    _checkAcceptedRequirements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchChildrenNames();
  }

  Future<void> _checkAcceptedRequirements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool accepted = prefs.getBool('acceptedRequirements') ?? false;
    setState(() {
      _hasAcceptedRequirements = accepted;
    });
  }

  Future<void> _setAcceptedRequirements(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceptedRequirements', value);
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

            // Imagen
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
              'Utiliza la inteligencia artificial para analizar la foto facial de tu hijo y detectar posibles signos de desnutrición. Solo se permiten fotos de niños de hasta 5 años.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),

            // Consideraciones
            Text(
              'Consideraciones para tomar la foto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

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

            // En la parte inferior del Column principal, justo antes del "Ver historial":
            SizedBox(height: 16),

// Botón para mostrar ejemplos de fotos válidas y no válidas
            Center(
              child: OutlinedButton.icon(
                icon: Icon(Icons.image_search, color: Color(0xFF83B56A)),
                label: Text(
                  'Ver ejemplos de fotos válidas y no válidas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF83B56A),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF83B56A)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoExamplesScreen(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Checkbox de aceptación
            Row(
              children: [
                Checkbox(
                  value: _hasAcceptedRequirements,
                  onChanged: (value) async {
                    setState(() {
                      _hasAcceptedRequirements = value!;
                    });
                    if (value!) {
                      await _setAcceptedRequirements(true);
                    }
                  },
                  activeColor: Color(0xFF83B56A),
                ),
                Expanded(
                  child: Text(
                    'He leído los requisitos para subir la foto',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      decoration: TextDecoration.underline, // <--- subrayado
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Botón "Tomar o subir foto"
            Center(
              child: ElevatedButton(
                onPressed: _hasAcceptedRequirements
                    ? () {
                        _showSelectChildDialog(context);
                      }
                    : null, // Deshabilitado si no está aceptado
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasAcceptedRequirements
                      ? Color(0xFF83B56A)
                      : Colors.grey,
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

            // Ver historial
            Center(
              child: TextButton(
                onPressed: () {
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
                        onPressed: () async {
                          if (selectedChild != null) {
                            final fetchedChild = await _childService
                                .getChildById(selectedChild!['childId']);

                            final String? peso =
                                fetchedChild!.childCurrentWeight.toString();
                            final String? talla =
                                fetchedChild.childCurrentHeight?.toString();

                            if (peso == null ||
                                talla == null ||
                                peso.isEmpty ||
                                talla.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Datos incompletos"),
                                  content: Text(
                                    "Debes ingresar el peso y la talla del niño para continuar con la detección.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Aceptar"),
                                    ),
                                  ],
                                ),
                              );
                              return; // No continuar
                            }

                            final result = await detectionService
                                .checkDailyDetection(selectedChild!['childId']);

                            if (result.containsKey('exists') &&
                                result['exists'] == true) {
                              // Mostrar mensaje si ya se detectó hoy
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      Text("Ya se realizó una detección hoy"),
                                  content: Text(
                                      "Este niño ya tiene una detección registrada hoy. Por favor, selecciona otro niño o espera hasta mañana para realizar una nueva detección con el mismo."),
                                  actions: [
                                    TextButton(
                                      child: Text("Aceptar"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TakeOrPickPhotoScreen(
                                      childId: selectedChild!['childId']),
                                ),
                              );
                            }
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
