import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
import '../../widgets/custom_pass_input.dart';
import '../../widgets/custom_text_input.dart';
import '../login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String phone;
  final String code;

  const NewPasswordScreen({
    Key? key,
    required this.phone,
    required this.code,
  }) : super(key: key);

  // Método para crear la pantalla desde argumentos
  static NewPasswordScreen fromArguments(Map<String, dynamic> args) {
    return NewPasswordScreen(
      phone: args['phone'] as String,
      code: args['code'] as String,
    );
  }

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final UserService _userService =
      UserService(); // Instancia del servicio de usuario
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  String? passwordError;
  String? confirmPasswordError;
  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();

    newPasswordController.addListener(() {
      validatePassword();
    });
  }

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

  // Función para validar y guardar la nueva contraseña
  void _verifyAndSavePassword() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    setState(() {
      passwordError = null; // Limpiar errores previos
      //para la robustes de las contraseñas
      /* if (newPassword.length < 6) {
        passwordError = 'La contraseña debe tener al menos 6 caracteres.';
      } */
      confirmPasswordError = null;
      validatePassword();

      if (newPassword != confirmPassword) {
        confirmPasswordError = 'Las contraseñas no coinciden.';
      }
    });

    if (passwordError == null && confirmPasswordError == null) {
      String? result = await _userService.resetPassword(
          widget.phone, widget.code, newPassword);

      if (result == null) {
        // Contraseña guardada exitosamente, regresar o mostrar mensaje de éxito

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contraseña actualizada correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(), // Tu pantalla destino
          ),
          (Route<dynamic> route) =>
              false, // Esto borra TODA la pila de navegación
        );
      } else {
        // Mostrar error si falla el cambio de contraseña
        setState(() {
          passwordError = result;
        });
      }
    }
    setState(() => isSubmitting = false);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Widget de Input con Icono de Ojo para Mostrar/Ocultar Contraseña
  Widget _buildPasswordInput({
    required String hintText,
    required TextEditingController controller,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: !isPasswordVisible, // Mostrar/ocultar contraseña
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF83B56A),
          ),
          onPressed: togglePasswordVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: () {
        setState(() {
          passwordError = null; // Eliminar error al enfocar
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false para bloquear el retroceso
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text('Nueva contraseña'),
          centerTitle: true,
          backgroundColor: Color(0xFF83B56A),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false, //
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Ingrese la nueva contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Input para Nueva Contraseña
                // Input para Nueva Contraseña
                PasswordInputWidget(
                  hintText: 'Nueva contraseña',
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
                      confirmPasswordError = null;
                    });
                  },
                ),
                SizedBox(height: 16),

                Text(
                  'Confirme la nueva contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                // Input para Confirmar Contraseña
                PasswordInputWidget(
                  hintText: 'Confirmar contraseña',
                  controller: confirmPasswordController,
                  isPasswordVisible: showConfirmPassword,
                  togglePasswordVisibility: () {
                    setState(() {
                      showConfirmPassword = !showConfirmPassword;
                    });
                  },
                  errorText:
                      confirmPasswordError, // 👈 mostrar el mismo error si lo hay
                  onTap: () {
                    setState(() {
                      confirmPasswordError = null; // Eliminar error al enfocar
                    });
                  },
                ),

                // Mostrar error si las contraseñas no coinciden
                /* if (passwordError != null) ...[
                  SizedBox(height: 8),
                  Text(
                    passwordError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ], */
                SizedBox(height: 24),

                // Botón "Guardar Contraseña"
                SizedBox(
                  width: double.infinity,
                  child: isSubmitting
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF83B56A),
                          ),
                        )
                      : CustomElevatedButton(
                          onPressed: _verifyAndSavePassword,
                          text: 'Guardar contraseña',
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
