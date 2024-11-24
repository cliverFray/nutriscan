import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Política de Privacidad'),
        backgroundColor: Color(0xFF83B56A), // Color principal de tu app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Política de Privacidad',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Tu privacidad es importante para nosotros. Esta Política de Privacidad explica cómo recopilamos, usamos, compartimos y protegemos tu información personal.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Recopilación de Datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Recopilamos información personal de los padres/cuidadores, incluyendo nombres, números de teléfono, direcciones, y datos de identificación como DNI.\n'
                '- También recopilamos información de los niños registrados, como nombre, género, edad, peso, altura, y datos relacionados con su historial de crecimiento.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Uso de Datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Los datos de los padres/cuidadores se utilizan para personalizar la experiencia dentro de la aplicación y facilitar el acceso a las funcionalidades.\n'
                '- Los datos de los niños se utilizan exclusivamente para realizar análisis de detección de desnutrición, generar recomendaciones nutricionales, y realizar un seguimiento del crecimiento.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Protección de Datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Tomamos medidas de seguridad técnicas y organizativas para proteger tus datos contra accesos no autorizados, alteraciones, divulgaciones o destrucciones.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Compartición de Datos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- No compartimos los datos personales con terceros sin tu consentimiento previo, excepto cuando sea requerido por ley.\n'
                '- Tus datos nunca serán utilizados para fines comerciales sin tu aprobación explícita.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Tus Derechos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Puedes acceder, corregir o eliminar tus datos personales en cualquier momento desde la configuración de la aplicación o contactándonos directamente.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
