import 'package:flutter/material.dart';
import '../models/users.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/password_input_widget.dart'; // Importamos el nuevo widget

class EditUserProfileScreen extends StatefulWidget {
  final User user;

  EditUserProfileScreen({required this.user});

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

  @override
  void initState() {
    super.initState();
    namesController = TextEditingController(text: widget.user.userFirstName);
    lastNameController = TextEditingController(text: widget.user.userLastName);
    phoneController = TextEditingController(text: widget.user.userPhone);
    passwordController = TextEditingController(text: widget.user.userPassword);
    dniController = TextEditingController(text: widget.user.userDNI);
    emailController = TextEditingController(text: widget.user.userEmail);
    placeController = TextEditingController(text: widget.user.userPlace);
  }

  void validateFields() {
    setState(() {
      nameError = namesController.text.isEmpty ? "Ingrese su nombre." : null;
      lastNameError =
          lastNameController.text.isEmpty ? "Ingrese su apellido." : null;
      passwordError =
          passwordController.text.isEmpty ? "Ingrese su contraseña." : null;
      dniError = dniController.text.length != 8
          ? "El DNI debe tener 8 dígitos."
          : null;
      phoneError = phoneController.text.length != 9
          ? "El teléfono debe tener 9 dígitos."
          : null;
      emailError = emailController.text.isEmpty ? "Ingrese su correo." : null;
      placeError = placeController.text.isEmpty
          ? "Ingrese su lugar de residencia."
          : null;
    });
  }

  void updateUserProfile() {
    validateFields();

    if ([
      nameError,
      lastNameError,
      passwordError,
      dniError,
      phoneError,
      emailError,
      placeError
    ].every((e) => e == null)) {
      User updatedUser = User(
        userId: widget.user.userId,
        userFirstName: namesController.text,
        userLastName: lastNameController.text,
        userPassword: passwordController.text,
        userDNI: dniController.text,
        userPhone: phoneController.text,
        userEmail: emailController.text,
        userRegistrationDate: widget.user.userRegistrationDate,
        userPlace: placeController.text,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Éxito'),
          content: Text('Perfil actualizado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, updatedUser);
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Tus datos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              CustomTextInput(hintText: 'Nombres', controller: namesController),
              if (nameError != null)
                Text(nameError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              CustomTextInput(
                  hintText: 'Apellidos', controller: lastNameController),
              if (lastNameError != null)
                Text(lastNameError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              PasswordInputWidget(
                  hintText: 'Contraseña', controller: passwordController),
              if (passwordError != null)
                Text(passwordError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              CustomTextInput(
                  hintText: 'DNI',
                  controller: dniController,
                  keyboardType: TextInputType.number),
              if (dniError != null)
                Text(dniError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              CustomTextInput(
                  hintText: 'Teléfono',
                  controller: phoneController,
                  keyboardType: TextInputType.phone),
              if (phoneError != null)
                Text(phoneError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              CustomTextInput(
                  hintText: 'Correo',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress),
              if (emailError != null)
                Text(emailError!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 16),
              CustomTextInput(
                  hintText: 'Lugar de residencia', controller: placeController),
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
