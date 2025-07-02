import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/custom_pass_input.dart';

class SecuritySettingsScreen extends StatefulWidget {
  @override
  _SecuritySettingsScreenState createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final UserService _userService = UserService();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  String? passwordError;

  bool showNewPassword = false;
  bool showCurrentPassword = false;

  @override
  void initState() {
    super.initState();

    newPasswordController.addListener(() {
      validatePassword();
    });
  }

  // Función de validación de contraseña
  void validatePassword() {
    final password = newPasswordController.text.trim();

    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasSpecialChar =
        password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    final hasNumber = password.contains(RegExp(r'\d'));

    setState(() {
      passwordError = (password.isNotEmpty && !hasMinLength)
          ? "La contraseña debe tener al menos 8 caracteres."
          : (password.isNotEmpty && !hasUppercase)
              ? "La contraseña debe tener al menos una letra mayúscula."
              : (password.isNotEmpty && !hasSpecialChar)
                  ? "La contraseña debe tener al menos un carácter especial."
                  : (password.isNotEmpty && !hasNumber)
                      ? "La contraseña debe tener al menos un número."
                      : null;
    });
  }

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
            PasswordInputWidget(
              hintText: 'Contraseña actual',
              controller: currentPasswordController,
              isPasswordVisible: showCurrentPassword,
              togglePasswordVisibility: () {
                setState(() {
                  showCurrentPassword = !showCurrentPassword;
                });
              },
              errorText: passwordError, // 👈 mostrar error si lo hay
              onTap: () {
                setState(() {
                  passwordError = null; // Eliminar error al enfocar
                });
              },
            ),
            SizedBox(height: 16),
            PasswordInputWidget(
              hintText: 'Nueva Contraseña',
              controller: newPasswordController,
              isPasswordVisible: showNewPassword,
              togglePasswordVisibility: () {
                setState(() {
                  showNewPassword = !showNewPassword;
                });
              },
              errorText: passwordError, // 👈 mostrar error si lo hay
              onTap: () {
                setState(() {
                  passwordError = null; // Eliminar error al enfocar
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;

                // Ejecuta la validación antes de enviar

                if (currentPassword.isNotEmpty &&
                    newPassword.isNotEmpty &&
                    passwordError == null) {
                  String? result = await _userService.resetPassword(
                    '', // Usa el teléfono almacenado localmente
                    '', // Usa un código si se requiere
                    newPassword,
                  );

                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Contraseña actualizada exitosamente.'),
                    ));
                    // Limpia los campos si quieres
                    currentPasswordController.clear();
                    newPasswordController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.red,
                    ));
                  }
                } else if (passwordError != null) {
                  // Muestra el error de validación si la contraseña no es segura
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(passwordError!),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  // Maneja el caso donde falta algún campo
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor, completa todos los campos.'),
                    backgroundColor: Colors.red,
                  ));
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
