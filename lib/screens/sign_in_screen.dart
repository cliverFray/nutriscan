import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../widgets/custom_pass_input.dart';
import 'bottom_nav_menu.dart';
import '../models/users.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_title_text.dart';
import '../widgets/name_app.dart';

import 'change_password/otp_verification_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_and_conditions_screen.dart'; // Importar pantalla OTP

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controladores para los inputs
  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  // Variables para almacenar mensajes de error
  String? nameError;
  String? lastNameError;
  String? passwordError;
  String? dniError;
  String? phoneError;
  String? emailError;
  String? placeError;
  bool acceptedTerms = false; // Estado para términos y condiciones
  bool? isLoading;
  String? termsError; // Mensaje de error para términos y condiciones
  final UserService _userService = UserService(); // Instancia del servicio

  bool _isPasswordVisible = false;

  //funcion para validar el formato del correo electronico

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  // Función para validar campos
  void validateFields() {
    setState(() {
      nameError =
          namesController.text.isEmpty ? "Por favor, ingrese su nombre." : null;
      lastNameError = lastNameController.text.isEmpty
          ? "Por favor, ingrese su apellido."
          : null;
      passwordError = passwordController.text.isEmpty
          ? "Por favor, ingrese una contraseña."
          : null;
      dniError = dniController.text.isEmpty || dniController.text.length != 8
          ? "El DNI debe tener 8 dígitos."
          : null;
      phoneError =
          phoneController.text.isEmpty || phoneController.text.length != 9
              ? "El número de teléfono debe tener 9 dígitos."
              : null;
      emailError = emailController.text.isEmpty
          ? "Por favor, ingrese su correo."
          : (!isValidEmail(emailController.text)
              ? "Dirección de correo no válida."
              : null);
      placeError = placeController.text.isEmpty
          ? "Por favor, ingrese su lugar de residencia."
          : null;

      // Validación de términos y condiciones
      termsError =
          !acceptedTerms ? "Debe aceptar los términos y condiciones." : null;

      isLoading = false;
    });
  }

  // Nueva función para enviar el código de verificación de identidad
  Future<void> _sendVerificationCode() async {
    validateFields();

    if (nameError == null &&
        lastNameError == null &&
        passwordError == null &&
        dniError == null &&
        phoneError == null &&
        emailError == null &&
        placeError == null &&
        termsError == null) {
      setState(() {
        isLoading = true;
      });
      _showLoadingDialog();
      // Enviar código de verificación
      String? responseMessage = await _userService.sendVerificationCode(
          phoneController.text.trim(),
          dniController.text.trim(),
          emailController.text.trim());

      if (responseMessage == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phone: phoneController.text,
              email: emailController.text.trim(),
              onOtpVerified: _registerAfterOtpVerification,
              otpType: "identity_verification",
            ),
          ),
        );
      } else {
        _showError(responseMessage);
      }
    }
  }

  // Función que se ejecuta cuando se verifica el OTP exitosamente
  Future<void> _registerAfterOtpVerification() async {
    setState(() {
      isLoading = true;
    });
    _showLoadingDialog();

    User newUser = User(
      userId: 0,
      userFirstName: namesController.text,
      userLastName: lastNameController.text,
      userPassword: passwordController.text,
      userDNI: dniController.text,
      userPhone: phoneController.text,
      userEmail: emailController.text,
      userRegistrationDate: DateTime.now(),
      userPlace: placeController.text,
    );

    String? registrationErrorMessage = await _userService.registerUser(newUser);
    if (registrationErrorMessage == null) {
      final String? loginError =
          await _userService.loginUser(newUser.userPhone, newUser.userPassword);
      if (loginError == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Cuenta creada exitosamente!'),
            duration: Duration(seconds: 2),
          ),
        );
        // Espera un momento para que el usuario vea el mensaje
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavMenu(),
          ),
        );
      } else {
        // Si el inicio de sesión falla, redirigimos al Login o mostramos un mensaje de error
        _showError(loginError);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } else {
      _showError(registrationErrorMessage);
    }
  }

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

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que se cierre al tocar fuera
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Color(0xFF83B56A)),
              SizedBox(width: 20),
              Text("Cargando..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Color de fondo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NameApp(),
              SizedBox(height: 8),
              CustomTitleText(text: 'Regístrate'),
              SizedBox(height: 40),

              // Input para nombres
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'Nombres',
                    controller: namesController,
                    keyboardType: TextInputType.text,
                  ),
                  if (nameError != null)
                    Text(
                      nameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Input para apellidos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'Apellidos',
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                  ),
                  if (lastNameError != null)
                    Text(
                      lastNameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Input para contraseña
              PasswordInputWidget(
                hintText: "Contraseña",
                controller: passwordController,
                isPasswordVisible: _isPasswordVisible,
                togglePasswordVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16),

              // Input para DNI
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'DNI',
                    controller: dniController,
                    keyboardType: TextInputType.number,
                  ),
                  if (dniError != null)
                    Text(
                      dniError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Input para teléfono
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'Número de teléfono',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  if (phoneError != null)
                    Text(
                      phoneError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Input para correo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'Correo',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (emailError != null)
                    Text(
                      emailError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Input para lugar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextInput(
                    hintText: 'Lugar de residencia',
                    controller: placeController,
                    keyboardType: TextInputType.text,
                  ),
                  if (placeError != null)
                    Text(
                      placeError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              SizedBox(height: 24),

              // Opción para aceptar términos y condiciones
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        acceptedTerms = value ?? false;
                        termsError = null; // Limpiar el error al aceptar
                      });
                    },
                    activeColor: Color(
                        0xFF83B56A), // Cambiar color del checkbox al marcar
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Acepto ',
                              style: TextStyle(
                                color: Colors
                                    .black, // Color normal para la parte introductoria
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'términos y condiciones ',
                              style: TextStyle(
                                color: Color(0xFF83B56A),
                                fontSize: 14,
                                decoration:
                                    TextDecoration.underline, // Subrayado
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navegar a los términos y condiciones
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TermsAndConditionsScreen(),
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text: 'y la ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'política de privacidad',
                              style: TextStyle(
                                color: Color(0xFF83B56A),
                                fontSize: 14,
                                decoration:
                                    TextDecoration.underline, // Subrayado
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navegar a la política de privacidad
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacyPolicyScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                        maxLines: 2, // Permitir hasta 2 líneas
                        softWrap: true, // Habilitar el salto de línea
                        overflow: TextOverflow
                            .visible, // Mostrar todo el texto sin cortar
                      ),
                    ),
                  ),
                ],
              ),
              if (termsError != null)
                Text(
                  termsError!,
                  style: TextStyle(color: Colors.red),
                ),

              SizedBox(height: 24),

              // Botón "Regístrate"
              CustomElevatedButton(
                text: 'Registrar',
                onPressed: _sendVerificationCode,
                width: 290,
              ),
              SizedBox(height: 5),

              // Texto "Aún no tienes cuenta? Regístrate"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ya tengo una cuenta ',
                    style: TextStyle(
                      color: Color(0xFF7C7C7C),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Inicia sesión',
                      style: TextStyle(color: Color(0xFF83B56A)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
