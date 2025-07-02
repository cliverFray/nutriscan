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
  String? genderError;
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
    final regex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    final match = regex.firstMatch(birthDate);

    if (match == null) {
      return false; // No coincide con el patrón dd/MM/yyyy
    }

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);

    if (day == null || month == null || year == null) {
      return false;
    }

    // Reglas de rangos válidos
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31)
      return false; // luego verificamos días reales por mes

    try {
      final parsedDate = DateTime(year, month, day);
      if (parsedDate.year != year ||
          parsedDate.month != month ||
          parsedDate.day != day) {
        return false; // No existe esta fecha
      }
      return parsedDate.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  bool _isUnderFiveYearsOld(String birthDate) {
    try {
      DateTime date = DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
      DateTime today = DateTime.now();
      int ageYears = today.year - date.year;
      if (today.month < date.month ||
          (today.month == date.month && today.day < date.day)) {
        ageYears--;
      }
      return ageYears <= 5;
    } catch (_) {
      return false;
    }
  }

  bool _containsOnlyLetters(String input) {
    final regex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");
    return regex.hasMatch(input);
  }

  // Función para validar y registrar
  void _validateAndRegister() async {
    String names = namesController.text.trim();
    String lastName = lastNameController.text.trim();
    String birthDate = birthDateController.text.trim();
    String weight = weightController.text.trim();
    String height = heightController.text.trim();

    setState(() {
      genderError =
          _selectedGender == null ? 'Debe seleccionar un género.' : null;

      nameError = names.isEmpty
          ? 'El campo Nombres es obligatorio.'
          : !_containsOnlyLetters(names)
              ? 'Solo se permiten letras en el campo Nombres.'
              : null;

      lastNameError = lastName.isEmpty
          ? 'El campo Apellidos es obligatorio.'
          : !_containsOnlyLetters(lastName)
              ? 'Solo se permiten letras en el campo Apellidos.'
              : null;

      birthDateError = birthDate.isEmpty
          ? 'El campo Fecha de nacimiento es obligatorio.'
          : !_isBirthDateValid(birthDate)
              ? 'Fecha de nacimiento no válida'
              : !_isUnderFiveYearsOld(birthDate)
                  ? 'El niño debe tener menor o igual a 5 años.'
                  : null;

      weightError = (weight.isNotEmpty &&
              (double.tryParse(weight) == null || double.parse(weight) <= 0))
          ? 'Peso no válido'
          : null;

      heightError = (height.isNotEmpty &&
              (double.tryParse(height) == null || double.parse(height) <= 0))
          ? 'Talla no válida'
          : null;
    });

    // Solo proceder si no hay errores visibles
    if (nameError == null &&
        lastNameError == null &&
        birthDateError == null &&
        weightError == null &&
        heightError == null &&
        _selectedGender != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        DateTime parsedDate =
            DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
        String formattedBirthDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        Child newChild = Child(
          childId: 0,
          childName: names,
          childLastName: lastName,
          childBirthDate: DateTime.parse(formattedBirthDate),
          childAgeMonth: _calculateAgeInMonths(birthDate),
          childGender: _selectedGender == 'Masculino',
          childCurrentWeight: weight.isEmpty ? null : double.parse(weight),
          childCurrentHeight: height.isEmpty ? null : double.parse(height),
        );

        String? responseMessage = await _childService.registerChild(newChild);
        setState(() {
          _isLoading = false;
        });

        if (responseMessage == null) {
          Navigator.pop(
              context, true); // Cerramos el diálogo y notificamos éxito
          _showSuccess();
        } else {
          _showError(responseMessage);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showError("Ocurrió un error inesperado.");
      }
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
                    genderError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (genderError != null) ...[
                Text(genderError!, style: TextStyle(color: Colors.red)),
              ],
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
                onTap: () {
                  setState(() {
                    weightError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (weightError != null) ...[
                Text(weightError!, style: TextStyle(color: Colors.red)),
              ],
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
                onTap: () {
                  setState(() {
                    heightError = null; // Eliminar error al enfocar
                  });
                },
              ),
              if (heightError != null) ...[
                Text(heightError!, style: TextStyle(color: Colors.red)),
              ],
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
