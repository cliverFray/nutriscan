import 'package:flutter/material.dart';
import 'app_info_screen.dart';
import 'feedback_screen.dart';
import 'notifications_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'security_settings_screen.dart';
import 'support_screen.dart';
import 'terms_and_conditions_screen.dart';

import 'login_screen.dart';
import '../services/user_service.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final UserService _userService = UserService();

  void _showDeleteAccountDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final Color primaryColor = Color(0xFF83B56A);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cuenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Por favor, ingresa tu contraseña para confirmar la eliminación de tu cuenta. Esta acción no se puede deshacer.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () async {
                final password = passwordController.text;

                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('La contraseña no puede estar vacía.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.of(context)
                    .pop(); // Cierra el diálogo de confirmación

                // Mostrar diálogo de carga
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(color: primaryColor),
                        SizedBox(width: 16),
                        Text("Eliminando cuenta..."),
                      ],
                    ),
                  ),
                );

                String? result = await _userService.deleteAccount(password);

                Navigator.of(context).pop(); // Cierra el diálogo de carga

                if (result == null) {
                  // Mostrar diálogo de éxito antes de redirigir
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Cuenta eliminada"),
                      content: Text(
                          "Tu cuenta ha sido eliminada exitosamente. Gracias por haber usado NutriScan."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: Text("Aceptar"),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mostrar error en SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Confirmar'),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Color(0xFF83B56A), // Color principal de tu app
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.black),
            title:
                Text('Política de Privacidad', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Política de Privacidad
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.gavel, color: Colors.black),
            title:
                Text('Términos y Condiciones', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Términos y Condiciones
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.black),
            title: Text('Notificaciones', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de configuración de Notificaciones
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationsSettingsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.support, color: Colors.black),
            title: Text('Soporte y Ayuda', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Soporte y Ayuda
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('Información de la Aplicación',
                style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Información de la Aplicación
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppInfoScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.feedback, color: Colors.black),
            title: Text('Enviar Retroalimentación',
                style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Retroalimentación
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security, color: Colors.black),
            title: Text('Seguridad', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // Navegar a la pantalla de Seguridad
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecuritySettingsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.black),
            title: Text('Eliminar Cuenta', style: TextStyle(fontSize: 18)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
