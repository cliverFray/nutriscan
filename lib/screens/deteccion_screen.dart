import 'package:flutter/material.dart';
import 'detection_history_screen.dart';
import 'register_child_screen.dart';
import 'take_or_pick_photo_screen.dart';

class DeteccionScreen extends StatelessWidget {
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
  void _showSelectChildDialog(BuildContext context) {
    /* List<String> children = List.generate(
        2, (index) => "Niño ${index + 1}"); // Simulación de la lista de niños
 */
    List<String> children = [
      "Juan",
      "Joel",
      "Gabo",
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedChild;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Seleccione al niño'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lista desplegable con estilo y con límite de altura
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
                        border:
                            InputBorder.none, // Sin borde adicional en el campo
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
                  SizedBox(height: 10),
                  if (children.isEmpty)
                    Text(
                      'No hay ningún niño registrado, Haga click en Continuar para registrar',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: [
                // Botón "Cancelar"
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                // Botón "Continuar"
                TextButton(
                  onPressed: () {
                    if (selectedChild != null || children.isEmpty) {
                      Navigator.of(context).pop();
                      if (children.isNotEmpty) {
                        // Navegación a la pantalla de tomar o subir foto
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeOrPickPhotoScreen(),
                          ),
                        );
                      } else {
                        // Navegación a la pantalla de registrar niño
                        // Agrega aquí la navegación que prefieras
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterChildScreen(),
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
      },
    );
  }
}
