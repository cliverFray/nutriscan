import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
import '../../widgets/custom_text_input.dart';
import 'new_password_screen.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Nuevo controlador
  String? phoneError;
  String? emailError;
  final UserService _userService = UserService(); // Instancia del servicio

  // Función para validar y continuar con la recuperación de contraseña
  void _validateAndRegister() async {
    String phone = phoneController.text;
    String email = emailController.text;

    setState(() {
      phoneError = null;
      emailError = null;
      if (phone.isEmpty || phone.length != 9) {
        phoneError = 'Por favor, introduce un número de teléfono válido.';
      }
      if (email.isEmpty || !email.contains('@')) {
        emailError = 'Por favor, introduce un correo electrónico válido.';
      }
    });

    if (phoneError == null && emailError == null) {
      String? responseMessage =
          await _userService.requestPasswordResetCode(phone, email);

      if (responseMessage == null) {
        // Mostrar snackbar de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado exitosamente al correo ingresado.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phone: phone,
              email: email, // Pasa también el email
              onOtpVerified: () => _navigateToNewPasswordScreen(phone),
              otpType: "password_reset",
            ),
          ),
        );
      } else {
        _showError(responseMessage);
      }
    }
  }

  // Función para navegar a la pantalla de cambio de contraseña después de verificar OTP
  void _navigateToNewPasswordScreen(String phone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPasswordScreen(
          phone: phone,
          code: "", // Puedes ajustar aquí si quieres pasar el OTP
        ),
      ),
    );
  }

  // Mostrar error en un diálogo
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                'Introduce tu número de teléfono y correo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),

              // Input para número de teléfono
              CustomTextInput(
                hintText: 'Número de Teléfono',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                suffixIcon: Icon(
                  Icons.phone,
                  color: Color(0xFF83B56A),
                ),
                onTap: () {
                  setState(() {
                    phoneError = null;
                  });
                },
              ),
              if (phoneError != null) ...[
                Text(
                  phoneError!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 16),

              // Input para correo electrónico
              CustomTextInput(
                hintText: 'Correo Electrónico',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF83B56A),
                ),
                onTap: () {
                  setState(() {
                    emailError = null;
                  });
                },
              ),
              if (emailError != null) ...[
                Text(
                  emailError!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 24),

              // Botón "Continuar"
              CustomElevatedButton(
                onPressed: _validateAndRegister,
                text: 'Continuar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
