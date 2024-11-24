import 'package:flutter/material.dart';
import '../services/user_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  @override
  _SecuritySettingsScreenState createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final UserService _userService = UserService();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
        backgroundColor: Color(0xFF83B56A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;

                if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
                  String? result = await _userService.resetPassword(
                    '', // Usa el teléfono almacenado localmente
                    '', // Usa un código si se requiere
                    newPassword,
                  );

                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Contraseña actualizada exitosamente.'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
              child: Text('Actualizar Contraseña'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF83B56A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
