import 'package:flutter/material.dart';
import '../models/user_update.dart';
import '../models/users.dart';
import '../services/user_service.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/password_input_widget.dart';

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

  void validateFields() {
    setState(() {
      nameError = namesController.text.isEmpty ? "Ingrese su nombre." : null;
      lastNameError =
          lastNameController.text.isEmpty ? "Ingrese su apellido." : null;
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

      // Validación de la contraseña si está ingresada
      passwordError = (passwordController.text.isNotEmpty &&
              passwordController.text.length < 8)
          ? "La contraseña debe tener al menos 8 caracteres."
          : null;
    });
  }

  void updateUserProfile() {
    validateFields();

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

  void _saveChanges(UserUpdate updatedUser) {
    us.updateUserProfile(updatedUser).then((success) {
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Perfil actualizado correctamente.'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context, updatedUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar el perfil.'),
          backgroundColor: Colors.red,
        ));
      }
    });
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
                    CustomTextInput(
                        hintText: 'Nombres', controller: namesController),
                    if (nameError != null)
                      Text(nameError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
                    CustomTextInput(
                        hintText: 'Apellidos', controller: lastNameController),
                    if (lastNameError != null)
                      Text(lastNameError!, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 16),
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
                          passwordError = value.length < 8 && value.isNotEmpty
                              ? "La contraseña debe tener al menos 8 caracteres."
                              : null;
                        });
                      },
                    ),
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
