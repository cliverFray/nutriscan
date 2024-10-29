import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
import '../../widgets/custom_text_input.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  String? phoneError;
  final UserService _userService = UserService(); // Instancia del servicio

  // Función para validar y continuar con la recuperación de contraseña
  void _validateAndRegister() async {
    String phone = phoneController.text;

    setState(() {
      // Limpiar errores previos
      phoneError = null;

      if (phone.isEmpty || phone.length != 9) {
        phoneError = 'Por favor, introduce un número de teléfono válido.';
      }
    });

    // Si no hay errores, proceder a enviar OTP
    if (phoneError == null) {
      String? responseMessage = await _userService.sendPasswordResetOTP(phone);

      if (responseMessage == null) {
        // OTP enviado exitosamente, navegar a la pantalla de OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(),
          ),
        );
      } else {
        // Mostrar error si falla el envío de OTP
        _showError(responseMessage);
      }
    }
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
                'Introduce tu número de teléfono',
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
                    phoneError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (phoneError != null) ...[
                Text(
                  phoneError!,
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
