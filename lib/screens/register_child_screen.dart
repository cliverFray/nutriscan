import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/users.dart';
import '../services/child_service.dart';
import '../services/user_service.dart';
import 'bottom_nav_menu.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/custom_text_input.dart';
import '../widgets/custom_title_text.dart';
import '../widgets/name_app.dart';

class RegisterChildScreen extends StatefulWidget {
  @override
  _RegisterChildScreenState createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _selectedGender;
  final ChildService _childService = ChildService(); // Instancia del servicio
  final UserService _userService = UserService(); // Instancia del UserService

  // Variables de estado para los mensajes de error
  String? nameError;
  String? lastNameError;
  String? birthDateError;
  String? weightError;
  String? heightError;
  bool _isLoading = false;

  // Función para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'PE'), // Establece el locale en español (Perú)
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF83B56A), // Cambia el color del calendario
            colorScheme: ColorScheme.light(primary: Color(0xFF83B56A)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        birthDateController.text =
            DateFormat('dd/MM/yyyy', 'es_PE').format(picked);
        birthDateError = null; // Eliminar error al seleccionar fecha
      });
    }
  }

  bool _isBirthDateValid(String birthDate) {
    try {
      DateTime date = DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
      return date.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  // Función para validar y registrar
  void _validateAndRegister() async {
    String names = namesController.text;
    String lastName = lastNameController.text;
    String birthDate = birthDateController.text;
    String weight = weightController.text;
    String height = heightController.text;

    setState(() {
      // Limpiar errores previos
      nameError = null;
      lastNameError = null;
      birthDateError = null;
      weightError = null;
      heightError = null;

      if (names.isEmpty) {
        nameError = 'El campo Nombres es obligatorio.';
      }
      if (lastName.isEmpty) {
        lastNameError = 'El campo Apellidos es obligatorio.';
      }
      birthDateError = birthDate.isEmpty
          ? 'El campo Fecha de nacimiento es obligatorio.'
          : _isBirthDateValid(birthDate)
              ? null
              : 'Fecha de nacimiento no válida';

      weightError = (weight.isNotEmpty &&
              (double.tryParse(weight) == null || double.parse(weight) <= 0))
          ? 'Peso no válido'
          : null;

      heightError = (height.isNotEmpty &&
              (double.tryParse(height) == null || double.parse(height) <= 0))
          ? 'Talla no válida'
          : null;
    });

    // Si no hay errores en los campos obligatorios
    if (nameError == null && lastNameError == null && birthDateError == null) {
      try {
        DateTime parsedDate =
            DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
        String formattedBirthDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        // Convertir los datos en el modelo Child
        Child newChild = Child(
          childId: 0, // Dependerá del backend asignar un ID al nuevo registro
          childName: names,
          childLastName: lastName,
          childBirthDate:
              DateTime.parse(formattedBirthDate), // Almacena la fecha
          childAgeMonth: _calculateAgeInMonths(birthDate),
          childGender: _selectedGender == 'Masculino',
          childCurrentWeight: weight.isEmpty ? null : double.parse(weight),
          childCurrentHeight: height.isEmpty ? null : double.parse(height),
        );

        // Llamar al servicio para registrar al niño
        String? responseMessage = await _childService.registerChild(newChild);
        setState(() {
          _isLoading = false;
        });

        if (responseMessage == null) {
          // Registro exitoso, mostrar mensaje y navegar
          _showSuccess();
        } else {
          // Muestra el error si falla
          _showError(responseMessage);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showError("Ocurrió un error inesperado.");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para calcular la edad en meses a partir de la fecha de nacimiento
  int _calculateAgeInMonths(String birthDate) {
    DateTime birth = DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
    DateTime today = DateTime.now();
    int ageMonths =
        (today.year - birth.year) * 12 + (today.month - birth.month);
    return ageMonths;
  }

  // Mostrar error en un diálogo
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

                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar éxito en un diálogo
  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text('El niño se ha registrado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Registrar niñ@"),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Color(
            0xFFFFFFFF), // Puedes cambiar el color del AppBar si lo deseas
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              CustomTitleText(text: 'Registrar información del niño'),
              SizedBox(height: 40),

              // Nombres con asterisco
              Row(
                children: [
                  Text('Nombres *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CustomTextInput(
                hintText: 'Nombres',
                controller: namesController,
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {
                    nameError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (nameError != null) ...[
                Text(nameError!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 16),

              // Apellidos con asterisco
              Row(
                children: [
                  Text('Apellidos *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CustomTextInput(
                hintText: 'Apellidos',
                controller: lastNameController,
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {
                    lastNameError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (lastNameError != null) ...[
                Text(lastNameError!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 16),

              // Fecha de nacimiento con asterisco
              Row(
                children: [
                  Text('Fecha de nacimiento *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextInput(
                    hintText: 'Fecha de nacimiento',
                    controller: birthDateController,
                    keyboardType: TextInputType.datetime,
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF83B56A),
                    ),
                  ),
                ),
              ),
              if (birthDateError != null) ...[
                Text(birthDateError!, style: TextStyle(color: Colors.red)),
              ],
              SizedBox(height: 16),

              // Género
              Row(
                children: [
                  Text('Género', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CustomDropdown(
                hintText: 'Género',
                value: _selectedGender,
                items: ['Masculino', 'Femenino'],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Peso (opcional)
              Row(
                children: [
                  Text('Peso (opcional)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CustomTextInput(
                hintText: 'Peso en kg',
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Talla (opcional)
              Row(
                children: [
                  Text('Talla (opcional)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              CustomTextInput(
                hintText: 'Talla en cm',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Botón de registrar
              _isLoading
                  ? CircularProgressIndicator(color: Color(0xFF83B56A))
                  : CustomElevatedButton(
                      onPressed: _validateAndRegister,
                      text: 'Registrar niñ@',
                    ),
              SizedBox(height: 16),

              // Mensaje indicando que algunos campos son opcionales
              Text(
                '* Algunos campos son opcionales.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
