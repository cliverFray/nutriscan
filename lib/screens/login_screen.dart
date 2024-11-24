import 'package:flutter/material.dart';
import 'bottom_nav_menu.dart';
import 'change_password/forgot_password_screen.dart';
import 'sign_in_screen.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_title_text.dart';
import '../widgets/name_app.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los inputs
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variables para mensajes de error
  String? phoneErrorMessage;
  String? passwordErrorMessage;

  // Método para iniciar sesión
  Future<void> loginUser(BuildContext context) async {
    String phone = phoneController.text;
    String password = passwordController.text;

    // Validaciones
    setState(() {
      phoneErrorMessage = null;
      passwordErrorMessage = null;
    });

    if (phone.isEmpty || phone.length != 9) {
      setState(() {
        phoneErrorMessage = 'El número de teléfono debe tener 9 dígitos.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordErrorMessage = 'La contraseña no puede estar vacía.';
      });
      return;
    }

    UserService us = UserService();
    String? errorMessage = await us.loginUser(phone, password);
    if (errorMessage == null) {
      //trampitar
      // Login exitoso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavMenu(),
        ),
      );
    } else {
      // Mostrar el mensaje de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Color de fondo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameApp(),
            SizedBox(height: 8),
            CustomTitleText(text: 'Iniciar sesión'),
            SizedBox(height: 40),

            // Input personalizado para teléfono
            CustomTextInput(
              hintText: 'Número de teléfono',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            if (phoneErrorMessage != null) // Mensaje de error
              Text(
                phoneErrorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16),

            // Input personalizado para contraseña
            CustomTextInput(
              hintText: 'Contraseña',
              isPassword: true, // Ocultar el texto
              controller: passwordController,
            ),
            if (passwordErrorMessage != null) // Mensaje de error
              Text(
                passwordErrorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 5),

            // Texto "¿Olvidaste tu contraseña?"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Acción para recuperar la contraseña
                  // Navegar a la pantalla de OTP
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Color(0xFFFF6F61),
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Botón "Iniciar sesión"
            CustomElevatedButton(
              text: 'Iniciar sesión',
              onPressed: () => loginUser(context), // Llamar a la función
              width: 290,
            ),
            SizedBox(height: 5),

            // Texto "Aún no tienes cuenta? Regístrate"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Aún no tienes cuenta? ',
                  style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Acción para registrarse
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    'Regístrate',
                    style: TextStyle(
                      color: Color(0xFF83B56A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
