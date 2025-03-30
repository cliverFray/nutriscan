import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_elevated_buton.dart';
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

  // Función para validar y guardar la nueva contraseña
  void _verifyAndSavePassword() async {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    setState(() {
      passwordError = null; // Limpiar errores previos

      if (newPassword != confirmPassword) {
        passwordError = 'Las contraseñas no coinciden.';
      }
    });

    if (passwordError == null) {
      String? result = await _userService.resetPassword(
          widget.phone, widget.code, newPassword);

      if (result == null) {
        // Contraseña guardada exitosamente, regresar o mostrar mensaje de éxito

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actualizada correctamente')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(), // Pasar teléfono y código
          ),
        );
      } else {
        // Mostrar error si falla el cambio de contraseña
        setState(() {
          passwordError = result;
        });
      }
    }
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
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text('Nueva contraseña'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
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
              _buildPasswordInput(
                hintText: 'Nueva contraseña',
                controller: newPasswordController,
                isPasswordVisible: showNewPassword,
                togglePasswordVisibility: () {
                  setState(() {
                    showNewPassword = !showNewPassword;
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
              _buildPasswordInput(
                hintText: 'Confirmar contraseña',
                controller: confirmPasswordController,
                isPasswordVisible: showConfirmPassword,
                togglePasswordVisibility: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
              ),

              // Mostrar error si las contraseñas no coinciden
              if (passwordError != null) ...[
                SizedBox(height: 8),
                Text(
                  passwordError!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(height: 24),

              // Botón "Guardar Contraseña"
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _verifyAndSavePassword,
                  text: 'Guardar contraseña',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
