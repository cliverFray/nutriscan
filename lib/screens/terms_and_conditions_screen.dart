import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
        backgroundColor: Color(0xFF83B56A), // Color principal de tu app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Condiciones',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Estos Términos y Condiciones rigen el uso de nuestra aplicación. Al utilizar la aplicación, aceptas estos términos en su totalidad.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Uso de la Aplicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Esta aplicación está diseñada para apoyar a los padres/cuidadores en el monitoreo de la nutrición infantil.\n'
                '- Debes proporcionar información precisa y veraz sobre ti y los niños registrados en la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Responsabilidad del Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Eres responsable de mantener la confidencialidad de tu cuenta y contraseña.\n'
                '- No debes usar la aplicación para ningún propósito ilegal o no autorizado.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Limitación de Responsabilidad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'La aplicación no sustituye el asesoramiento médico profesional. Siempre consulta a un médico o nutricionista para obtener diagnósticos y recomendaciones específicas.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Propiedad Intelectual',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Todos los derechos sobre el contenido de esta aplicación, incluyendo textos, gráficos, imágenes y código, son propiedad exclusiva de la empresa desarrolladora.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Modificaciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Nos reservamos el derecho de modificar estos Términos y Condiciones en cualquier momento. Las actualizaciones estarán disponibles en la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contacto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Si tienes preguntas sobre estos términos, contáctanos a través de la sección de soporte en la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
