import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
import 'new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone; // Añadir el campo de teléfono
  final String email; // Añadir el campo de teléfono
  final void Function() onOtpVerified;
  final String otpType; // Puede ser "identity_verification" o "password_reset"

  const OtpVerificationScreen({
    Key? key,
    required this.phone,
    required this.email,
    required this.onOtpVerified,
    required this.otpType,
  }) : super(key: key);

  // Método para crear la pantalla desde argumentos
  static OtpVerificationScreen fromArguments(Map<String, dynamic> args) {
    return OtpVerificationScreen(
      phone: args['phone'] as String,
      email: args['email'] as String,
      onOtpVerified: args['onOtpVerified'] as void Function(),
      otpType: args['otpType'] as String,
    );
  }

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Función para validar y verificar el OTP
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final UserService _userService = UserService();
  String? otpError;

  // Función para validar y verificar el OTP
  void _validateAndVerifyOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();

    setState(() {
      otpError = null;

      if (otp.length != 6) {
        otpError = 'El código debe tener 6 dígitos.';
      }
    });

    if (otpError == null) {
      final verificationMethod = widget.otpType == "identity_verification"
          ? _userService.verifyIdentityCode
          : _userService.verifyPasswordResetCode;

      verificationMethod(widget.phone, otp).then((result) {
        if (result == null) {
          if (widget.otpType == "password_reset") {
            // Navegar a la pantalla de cambio de contraseña en caso de restablecimiento de contraseña
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPasswordScreen(
                  phone: widget.phone,
                  code: otp, // Pasar el OTP verificado a la pantalla
                ),
              ),
            );
          } else {
            // Ejecutar la función onOtpVerified para otros casos
            widget.onOtpVerified();
          }
        } else {
          setState(() {
            otpError = result;
          });
        }
      });
    }
  }

  // Función para reenviar el OTP según el tipo
  void _resendOtp() {
    final resendMethod = widget.otpType == "identity_verification"
        ? _userService.resendIdentityVerificationCode
        : _userService.resendPasswordResetCode;

    resendMethod(widget.phone, widget.email).then((result) {
      if (result != null) {
        setState(() {
          otpError = result;
        });
      } else {
        setState(() {
          otpError = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nuevo código OTP enviado exitosamente.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  // Widget para crear un campo individual del OTP
  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 4),
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
          if (value.isNotEmpty && index < 5) {
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
                'Hemos enviado el código de 6 dígitos por SMS',
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
                children: List.generate(6, (index) => _buildOtpField(index)),
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
                onPressed: _resendOtp, // Llama al método de reenvío,
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
