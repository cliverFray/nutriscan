import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../services/child_service.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_elevated_buton.dart';
import '../widgets/custom_text_input.dart';
import 'manage_child_profile_screen.dart';

class EditChildProfileScreen extends StatefulWidget {
  final int childId; // Solo el ID del niño para editar

  const EditChildProfileScreen({Key? key, required this.childId})
      : super(key: key);

  // Método para obtener datos desde `arguments`
  static EditChildProfileScreen fromArguments(Map<String, dynamic> args) {
    return EditChildProfileScreen(
      childId: args['childId'] as int,
    );
  }

  @override
  _EditChildProfileScreenState createState() => _EditChildProfileScreenState();
}

class _EditChildProfileScreenState extends State<EditChildProfileScreen> {
  final TextEditingController namesController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _selectedGender;
  String? nameError;
  String? lastNameError;
  String? birthDateError;
  String? weightError;
  String? heightError;
  String? genderError;

  final ChildService _childService = ChildService();
  Child? child;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  // Cargar la información del niño desde el backend
  Future<void> _loadChildData() async {
    try {
      final fetchedChild = await _childService.getChildById(widget.childId);
      if (fetchedChild != null) {
        setState(() {
          child = fetchedChild;
          namesController.text = fetchedChild.childName;
          lastNameController.text = fetchedChild.childLastName;
          birthDateController.text = DateFormat('dd/MM/yyyy', 'es_PE')
              .format(fetchedChild.childBirthDate);
          weightController.text =
              fetchedChild.childCurrentWeight?.toString() ?? '';
          heightController.text =
              fetchedChild.childCurrentHeight?.toString() ?? '';
          _selectedGender = fetchedChild.childGender ? 'Masculino' : 'Femenino';
        });
      }
    } catch (e) {}
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

  // Función para validar y actualizar la información del niño
  // Validar y actualizar la información del niño

  bool _containsOnlyLetters(String input) {
    final regex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");
    return regex.hasMatch(input);
  }

  void _validateAndUpdate() async {
    String names = namesController.text;
    String lastName = lastNameController.text;
    String birthDate = birthDateController.text;
    String weight = weightController.text;
    String height = heightController.text;

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

    if (nameError == null && lastNameError == null && birthDateError == null) {
      DateTime parsedBirthDate =
          DateFormat('dd/MM/yyyy', 'es_PE').parse(birthDate);
      int ageInMonths = _calculateAgeInMonths(parsedBirthDate);

      // Crear nueva instancia del niño con los valores actualizados
      Child updatedChild = Child(
          childId: child!.childId,
          childName: names,
          childLastName: lastName,
          childBirthDate: parsedBirthDate,
          childAgeMonth: ageInMonths,
          childGender: _selectedGender == 'Masculino',
          childCurrentWeight: weight.isEmpty ? null : double.parse(weight),
          childCurrentHeight: height.isEmpty ? null : double.parse(height));

      // Llamar al servicio para actualizar la información
      String? responseMessage = await _childService.updateChild(updatedChild);

      if (responseMessage == null) {
        Navigator.pop(context, true); // Cerramos el diálogo y notificamos éxito
        _showSuccess();
      } else {
        _showError(responseMessage);
      }
    }
  }

  int _calculateAgeInMonths(DateTime birthDate) {
    DateTime today = DateTime.now();
    return (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
  }

  // Mostrar mensaje de éxito
  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text('El perfil del niño se ha actualizado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el AlertDialog
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar mensaje de error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil del niño (a)'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: child == null
          ? Center(child: CircularProgressIndicator()) // Cargando
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Información de ${child!.childName}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    CustomTextInput(
                      hintText: 'Nombres',
                      controller: namesController,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        setState(() {
                          nameError = null;
                        });
                      },
                    ),
                    if (nameError != null) ...[
                      Text(nameError!, style: TextStyle(color: Colors.red)),
                    ],
                    SizedBox(height: 16),
                    CustomTextInput(
                      hintText: 'Apellidos',
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        setState(() {
                          lastNameError = null;
                        });
                      },
                    ),
                    if (lastNameError != null) ...[
                      Text(lastNameError!, style: TextStyle(color: Colors.red)),
                    ],
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextInput(
                          hintText: 'Fecha de nacimiento',
                          controller: birthDateController,
                          keyboardType: TextInputType.datetime,
                          suffixIcon: Icon(Icons.calendar_today,
                              color: Color(0xFF83B56A)),
                        ),
                      ),
                    ),
                    if (birthDateError != null) ...[
                      Text(birthDateError!,
                          style: TextStyle(color: Colors.red)),
                    ],
                    SizedBox(height: 16),
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
                    if (genderError != null) ...[
                      Text(genderError!, style: TextStyle(color: Colors.red)),
                    ],
                    SizedBox(height: 16),
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
                    SizedBox(height: 24),
                    CustomElevatedButton(
                      onPressed: _validateAndUpdate,
                      text: 'Actualizar',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: child?.childBirthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'PE'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF83B56A),
            colorScheme: ColorScheme.light(primary: Color(0xFF83B56A)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        birthDateController.text =
            DateFormat('dd/MM/yyyy', 'es_PE').format(picked);
      });
    }
  }
}
