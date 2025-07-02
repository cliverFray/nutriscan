import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 👈 Importa url_launcher

class SupportScreen extends StatelessWidget {
  final String _email = 'nutriscanappcorreos@gmail.com';

  void _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _email,
      query: Uri.encodeFull(
          'subject=Soporte NutriScan&body=Hola, necesito ayuda con la app...'),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir la aplicación de correo.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soporte y Ayuda'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Contacto por Correo'),
            subtitle: Text(_email),
            onTap: () =>
                _launchEmail(context), // 👈 Llama a la función al hacer click
          ),
          ExpansionTile(
            leading: Icon(Icons.help_outline),
            title: Text('Preguntas Frecuentes'),
            children: [
              ListTile(
                title: Text('¿Qué hacer si hay errores en la app?'),
                subtitle: Text(
                  'Si encuentras errores o problemas, por favor contáctanos al correo: $_email para que podamos ayudarte. No olvides incluir tu nombre, DNI y capturas o screenshots del error o problema',
                ),
              ),
              ListTile(
                title: Text('¿Cómo contactar soporte técnico?'),
                subtitle: Text(
                  'Puedes escribirnos directamente al correo electrónico proporcionado arriba. Nuestro equipo de soporte responderá lo antes posible.',
                ),
              ),
              ListTile(
                title: Text('¿Cómo funciona la aplicación?'),
                subtitle: Text(
                  'Nuestra app utiliza redes neuronales para analizar fotos y detectar posibles casos de desnutrición en niños menores de 5 años. Sigue las instrucciones de la app para capturar las fotos correctamente.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
