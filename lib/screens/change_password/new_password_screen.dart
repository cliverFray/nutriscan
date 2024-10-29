import 'package:flutter/material.dart';
import '../../widgets/custom_elevated_buton.dart';
import '../../widgets/custom_text_input.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  String? passwordError;

  // Función para validar y guardar la nueva contraseña
  void _verifyAndSavePassword() {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    setState(() {
      passwordError = null; // Limpiar errores previos

      if (newPassword != confirmPassword) {
        passwordError = 'Las contraseñas no coinciden.';
      }
    });

    if (passwordError == null) {
      // Guardar la nueva contraseña y navegar
      Navigator.pop(context); // O puedes implementar lógica adicional aquí
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
