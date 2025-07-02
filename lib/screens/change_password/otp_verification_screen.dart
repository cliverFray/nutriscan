import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
import '../login_screen.dart';
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
  bool _isVerifying = false;

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
      setState(() {
        _isVerifying = true; // 🔥 MIENTRAS ESPERA, ACTIVAR CARGA
      });
      final verificationMethod = widget.otpType == "identity_verification"
          ? _userService.verifyIdentityCode
          : _userService.verifyPasswordResetCode;

      setState(() {
        _isVerifying = false; // 🔥 DETENER CARGA
      });

      verificationMethod(widget.phone, otp).then((result) {
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Codigo verificado correctamente"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
    return PopScope(
      canPop: false, // false para bloquear el retroceso
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text('Verificar Código OTP'),
          centerTitle: true,
          backgroundColor: Color(0xFF83B56A),
          foregroundColor: Colors.white,
          automaticallyImplyLeading:
              false, // 2️⃣ QUITA EL BOTÓN ATRÁS EN EL APPBAR
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
                  'Hemos enviado el código de 6 dígitos por SMS y correo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
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
                // Botón "Verificar"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _validateAndVerifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF83B56A),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isVerifying
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Verificar'),
                  ),
                ),

                // Botón "Reenviar Código"
                TextButton(
                  onPressed: _resendOtp,
                  child: Text('Reenviar Código'),
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Color(0xFF83B56A)),
                  ),
                ),

                // 1️⃣ BOTÓN "CANCELAR"
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Usamos pushAndRemoveUntil para borrar el historial de navegación
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(), // Tu pantalla destino
                        ),
                        (Route<dynamic> route) =>
                            false, // Esto borra TODA la pila de navegación
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.grey),
                      side: WidgetStatePropertyAll(
                          BorderSide(color: Colors.grey)),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.grey.withOpacity(0.5);
                          }
                          return null;
                        },
                      ),
                    ),
                    child: Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
