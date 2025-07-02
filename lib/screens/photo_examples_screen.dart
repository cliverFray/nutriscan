// Nueva pantalla para mostrar ejemplos de fotos
import 'package:flutter/material.dart';

class PhotoExamplesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ejemplosValidos = [
      {
        'imagen': 'assets/images/egimgfordetec/imagen_valida-boy.png',
        'descripcion':
            'Buena iluminación, sin sombras, rostro del niño centrado.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_valida_boy_3.png',
        'descripcion':
            'Foto sin accesorios ni filtros, sin camisa para mejor analisis.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_valida_boy_2.png',
        'descripcion': 'Foto del niño enfocado en el rostro.'
      },
    ];

    final ejemplosNoValidos = [
      {
        'imagen': 'assets/images/egimgfordetec/imagen_no_valida_boy_1.png',
        'descripcion': 'Sombras en el rostro, difícil de analizar.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_no_valida_boy_2.png',
        'descripcion': 'Niño con gorro, obstrucción del rostro.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_no_valida__boy_3.png',
        'descripcion': 'Uso de filtros que distorsionan la foto.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_no_valida_girl1.png',
        'descripcion': 'El rostro del niño o niña está de perfil.'
      },
      {
        'imagen': 'assets/images/egimgfordetec/imagen_no_valida_5.png',
        'descripcion': 'En la imagen sale dos o mas rostros.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejemplos de Fotos'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ejemplos de fotos válidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildEjemplosList(ejemplosValidos),
            SizedBox(height: 24),
            Text(
              'Ejemplos de fotos no válidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            _buildEjemplosList(ejemplosNoValidos),
          ],
        ),
      ),
    );
  }

  Widget _buildEjemplosList(List<Map<String, String>> ejemplos) {
    return Column(
      children: ejemplos.map((ejemplo) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    ejemplo['imagen']!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ejemplo['descripcion']!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
