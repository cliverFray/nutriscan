import 'package:flutter/material.dart';
import '../models/user_update.dart';
import '../models/users.dart';
import '../services/user_service.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/custom_text_input2.dart';
import '../widgets/password_input_widget.dart';
import 'bottom_nav_menu.dart';
import 'perfil_screen.dart';

class EditUserProfileScreen extends StatefulWidget {
  EditUserProfileScreen();

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late TextEditingController namesController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController dniController;
  late TextEditingController emailController;
  late TextEditingController placeController;

  String? nameError, lastNameError, passwordError, dniError;
  String? phoneError, emailError, placeError;
  bool showPassword = false;

  UserService us = UserService();
  UserUpdate? user;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() async {
    user = await us.getUserProfileForUpdate();
    setState(() {
      namesController = TextEditingController(text: user?.userFirstName ?? "");
      lastNameController =
          TextEditingController(text: user?.userLastName ?? "");
      phoneController = TextEditingController(text: user?.userPhone ?? "");
      passwordController =
          TextEditingController(text: ""); // No cargamos el password actual
      dniController = TextEditingController(text: user?.userDNI ?? "");
      emailController = TextEditingController(text: user?.userEmail ?? "");
      placeController = TextEditingController(text: user?.userPlace ?? "");
    });
  }

  /* void validateFields() {
    final nameRegex = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+$");
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    final dniRegex = RegExp(r"^\d{8}$");
    final placeRegex = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]{3,}$");

    setState(() {
      nameError = namesController.text.isEmpty
          ? "El campo nombres es obligatorio."
          : !nameRegex.hasMatch(namesController.text)
              ? "Nombre no válido"
              : null;

      lastNameError = lastNameController.text.isEmpty
          ? "El campo apellidos es obligatorio."
          : !nameRegex.hasMatch(lastNameController.text)
              ? "Apellidos no válidos"
              : null;

      dniError = dniController.text.isEmpty
          ? "El campo DNI es obligatorio."
          : !dniRegex.hasMatch(dniController.text)
              ? "DNI no válido"
              : null;

      phoneError = phoneController.text.length != 9
          ? "El teléfono debe tener 9 dígitos."
          : null;

      emailError = emailController.text.isEmpty
          ? "El campo correo es obligatorio."
          : !emailRegex.hasMatch(emailController.text)
              ? "Dirección de correo no válida"
              : null;

      placeError = placeController.text.isEmpty
          ? "El campo lugar de residencia es obligatorio."
          : !placeRegex.hasMatch(placeController.text) ||
                  placeController.text == "---"
              ? "Lugar de residencia no válido"
              : null;

      // Validación de contraseña
      passwordError = (passwordController.text.isNotEmpty &&
              passwordController.text.length < 8)
          ? "La contraseña debe tener al menos 8 caracteres."
          : null;
    });
  } */
  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  void validatePassword() {
    final password = passwordController.text.trim();

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

  void validateFields() {
    setState(() {
      // Nombres
      String names = namesController.text.trim();
      if (names.isEmpty) {
        nameError = "Por favor, ingrese su nombre.";
      } else if (!RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúñÑ ]{2,64}$").hasMatch(names)) {
        nameError = "El nombre debe tener solo letras (2–64 caracteres).";
      } else {
        nameError = null;
      }

      // Apellidos
      String lastNames = lastNameController.text.trim();
      if (lastNames.isEmpty) {
        lastNameError = "Por favor, ingrese su apellido.";
      } else if (!RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúñÑ ]{2,64}$")
          .hasMatch(lastNames)) {
        lastNameError = "El apellido debe tener solo letras (2–64 caracteres).";
      } else {
        lastNameError = null;
      }
      //contraseña
      validatePassword();

      // DNI
      String dni = dniController.text.trim();
      if (dni.isEmpty) {
        dniError = "Por favor, ingrese su DNI.";
      } else if (!RegExp(r"^\d{8}$").hasMatch(dni)) {
        dniError = "El DNI debe tener exactamente 8 dígitos.";
      } else {
        dniError = null;
      }

      // Teléfono
      String phone = phoneController.text.trim();
      if (phone.isEmpty) {
        phoneError = "Por favor, ingrese su número de teléfono.";
      } else if (!RegExp(r"^9\d{8}$").hasMatch(phone)) {
        phoneError =
            "El número debe tener 9 dígitos y comenzar con 9 (ej. 9XXXXXXXX).";
      } else {
        phoneError = null;
      }

      // Correo electrónico
      String email = emailController.text.trim();
      if (email.isEmpty) {
        emailError = "Por favor, ingrese su correo.";
      } else if (!isValidEmail(email)) {
        emailError = "Dirección de correo no válida.";
      } else {
        emailError = null;
      }

      // Lugar de residencia
      String place = placeController.text.trim();
      if (place.isEmpty) {
        placeError = "Por favor, ingrese su lugar de residencia.";
      } else if (place.length > 100) {
        placeError = "La longitud máxima es de 100 caracteres.";
      } else if (RegExp(r"^[^\w\sáéíóúÁÉÍÓÚñÑ]+$").hasMatch(place)) {
        // Solo símbolos
        placeError = "El lugar de residencia no puede contener solo símbolos.";
      } else {
        placeError = null;
      }
    });
  }

  bool _hasChanges() {
    return namesController.text != user?.userFirstName ||
        lastNameController.text != user?.userLastName ||
        dniController.text != user?.userDNI ||
        phoneController.text != user?.userPhone ||
        emailController.text != user?.userEmail ||
        placeController.text != user?.userPlace ||
        passwordController.text.isNotEmpty;
  }

  void updateUserProfile() {
    validateFields();
    if (!_hasChanges()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No has realizado ningún cambio.'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    if ([nameError, lastNameError, dniError, phoneError, emailError, placeError]
            .every((e) => e == null) &&
        (passwordError == null || passwordController.text.isEmpty)) {
      UserUpdate updatedUser = UserUpdate(
        userFirstName: namesController.text,
        userLastName: lastNameController.text,
        userPassword: passwordController.text.isEmpty
            ? user!.userPassword
            : passwordController.text,
        userDNI: dniController.text,
        userPhone: phoneController.text,
        userEmail: emailController.text,
        userPlace: placeController.text,
      );

      _confirmUpdate(updatedUser);
    }
  }

  void _confirmUpdate(UserUpdate updatedUser) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Actualización'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¿Confirma los siguientes cambios en su perfil?"),
            SizedBox(height: 10),
            _buildChangedFields(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveChanges(updatedUser);
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildChangedFields() {
    List<String> fields = [];
    if (namesController.text != user!.userFirstName) fields.add("Nombre");
    if (lastNameController.text != user!.userLastName) fields.add("Apellido");
    if (dniController.text != user!.userDNI) fields.add("DNI");
    if (phoneController.text != user!.userPhone) fields.add("Teléfono");
    if (emailController.text != user!.userEmail) fields.add("Correo");
    if (placeController.text != user!.userPlace) fields.add("Lugar");
    if (passwordController.text.isNotEmpty) fields.add("Contraseña");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((field) => Text("• $field")).toList(),
    );
  }

  void _showLoadingDialog(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // No permite cerrarlo tocando fuera
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text(msg),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(UserUpdate updatedUser) async {
    // ✅ Muestra el loader
    _showLoadingDialog("Actualizando datos...");
    final error = await us.updateUserProfile(updatedUser);
    Navigator.of(context, rootNavigator: true).pop();

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Perfil actualizado correctamente.'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
    } else {
      setState(() {
        // Reiniciamos todos los errores
        emailError = null;
        dniError = null;
        phoneError = null;

        // Verificamos el mensaje de error específico y lo asignamos
        if (error.contains('correo')) {
          emailError = error;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ));
        } else if (error.contains('DNI')) {
          dniError = error;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ));
        } else if (error.contains('teléfono')) {
          phoneError = error;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ));
        } else {
          // Si no encaja con ningún campo, mostrarlo como mensaje general
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Tus datos',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Nombres',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput(
                        hintText: 'Nombres', controller: namesController),
                    if (nameError != null)
                      Text(nameError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Apellidos',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput(
                        hintText: 'Apellidos', controller: lastNameController),
                    if (lastNameError != null)
                      Text(lastNameError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Nueva contraseña',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        errorText: passwordError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          validatePassword();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('DNI',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput(
                        hintText: 'DNI',
                        controller: dniController,
                        keyboardType: TextInputType.number),
                    if (dniError != null)
                      Text(dniError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Telefono (solo lectura)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput2(
                      hintText: 'Teléfono',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                    ),
                    if (phoneError != null)
                      Text(phoneError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Correo',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput(
                        hintText: 'Correo',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress),
                    if (emailError != null)
                      Text(emailError!, style: TextStyle(color: Colors.red)),
                    // Texto de verificación de correo
                    /* if (user != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          (user!.isemailverified ?? false)
                              ? 'Correo verificado'
                              : 'Correo no verificado',
                          style: TextStyle(
                            color: (user!.isemailverified ?? false)
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ), */

                    if (user != null && !user!.isemailverified!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tu correo aún no está verificado.",
                            style: TextStyle(color: Colors.orange),
                          ),
                          TextButton(
                            onPressed: () async {
                              final message =
                                  await us.resendCorreoVerificacion();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message ??
                                      'Error al reenviar verificación.'),
                                  backgroundColor: message != null &&
                                          message.contains('enviado')
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              );
                            },
                            child: Text(
                              "Reenviar correo de verificación",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Luegar de residencia',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CustomTextInput(
                        hintText: 'Lugar de residencia',
                        controller: placeController),
                    if (placeError != null)
                      Text(placeError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 24),
                    CustomElevatedButton(
                        text: 'Guardar cambios', onPressed: updateUserProfile),
                  ],
                ),
              ),
            ),
    );
  }
}
