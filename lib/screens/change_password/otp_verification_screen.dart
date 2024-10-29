import 'package:flutter/material.dart';
import '../../widgets/custom_elevated_buton.dart';
import 'new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  String? otpError;

  // Función para validar y verificar el OTP
  void _validateAndVerifyOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();

    setState(() {
      otpError = null; // Limpiar errores previos

      if (otp.length != 5) {
        otpError = 'El código debe tener 5 dígitos.';
      }
    });

    if (otpError == null) {
      // Navegar a la pantalla de nueva contraseña si el OTP es válido
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(),
        ),
      );
    }
  }

  // Widget para crear un campo individual del OTP
  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: otpControllers[index],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1, // Limitar a 1 dígito por campo
        onChanged: (value) {
          if (value.isNotEmpty && index < 4) {
            FocusScope.of(context).nextFocus(); // Ir al siguiente campo
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text('Verificar Código OTP'),
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
                'Hemos enviado el código de 5 dígitos por SMS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Cuadros de entrada para OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => _buildOtpField(index)),
              ),
              if (otpError != null) ...[
                SizedBox(height: 8),
                Text(
                  otpError!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 24),

              // Botón "Verificar"

              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _validateAndVerifyOtp,
                  text: 'Verificar',
                ),
              ),
              TextButton(
                onPressed: () {
                  // Acción para reenviar OTP
                  // Implementa la lógica de reenvío aquí
                },
                child: Text('Reenviar Código'),
                style: ButtonStyle(
                  foregroundColor:
                      WidgetStatePropertyAll(Color(0xFF83B56A)), // Color verde
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
