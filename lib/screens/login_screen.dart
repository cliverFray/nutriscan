import 'package:flutter/material.dart';
import '../widgets/custom_pass_input.dart';
import 'bottom_nav_menu.dart';
import 'change_password/forgot_password_screen.dart';
import 'onboarding_screen.dart';
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
  bool showNewPassword = false;

  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _isLoading = false;

  // Método para iniciar sesión
  Future<void> loginUser(BuildContext context) async {
    String phone = phoneController.text;
    String password = passwordController.text;

    // Validaciones
    setState(() {
      phoneErrorMessage = null;
      passwordErrorMessage = null;
      _isLoading = true;
      _errorMessage = null;
    });

    if (phone.isEmpty || phone.length != 9) {
      setState(() {
        phoneErrorMessage = 'El número de teléfono debe tener 9 dígitos.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordErrorMessage = 'Ingrese la contraseña.';
      });
      return;
    }

    try {
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
        setState(() {
          _errorMessage =
              "Usuario o contraseña incorrecta. Inténtalo nuevamente.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al iniciar sesión. Verifica tu conexión.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Color de fondo
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(), // Efecto de desplazamiento suave
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight, // Asegura que ocupe toda la pantalla
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Ajusta con teclado
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrado inicial
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NameApp(),
                    SizedBox(height: 8),
                    CustomTitleText(text: 'Iniciar sesión'),
                    SizedBox(height: 40),

                    // Input de teléfono
                    CustomTextInput(
                      hintText: 'Número de teléfono',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    if (phoneErrorMessage != null)
                      Text(phoneErrorMessage!,
                          style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),

                    // Input de contraseña
                    PasswordInputWidget(
                      hintText: "Contraseña",
                      controller: passwordController,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      onTap: () {
                        setState(() {
                          passwordErrorMessage = null;
                        });
                      },
                    ),
                    if (passwordErrorMessage != null)
                      Text(passwordErrorMessage!,
                          style: TextStyle(color: Colors.red)),
                    SizedBox(height: 5),
                    if (_errorMessage != null)
                      Text(_errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14)),
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
                    SizedBox(height: 5),
                    // Botón "Iniciar sesión"
                    _isLoading
                        ? CircularProgressIndicator()
                        : CustomElevatedButton(
                            text: 'Iniciar sesión',
                            onPressed: () => loginUser(context),
                            width: 290,
                          ),
                    SizedBox(height: 5),

                    // Texto "¿No tienes cuenta? Regístrate"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('¿Aún no tienes cuenta? ',
                            style: TextStyle(
                                color: Color(0xFF7C7C7C), fontSize: 14)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()));
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
            ),
          );
        },
      ),
    );
  }
}
