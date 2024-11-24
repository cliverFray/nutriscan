import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
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
            subtitle: Text('soporte@tuapp.com'),
            onTap: () {
              // Lógica para enviar un correo
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Preguntas Frecuentes'),
            onTap: () {
              // Navegar a una página de preguntas frecuentes
            },
          ),
        ],
      ),
    );
  }
}
