import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'register_child_screen.dart';

import '../models/child.dart';
import '../models/users.dart';
import 'edit_child_profile_screen.dart';

import 'package:intl/intl.dart';

class ManageChildProfileScreen extends StatefulWidget {
  @override
  _ManageChildProfileScreenState createState() =>
      _ManageChildProfileScreenState();
}

class _ManageChildProfileScreenState extends State<ManageChildProfileScreen> {
  Map<String, dynamic>? selectedChild;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'es');

  final List<Map<String, dynamic>> children = [
    {
      'childId': 1,
      'childName': 'Juan',
      'childLastName': 'Pérez',
      'childBirthDate': DateTime(2020, 5, 10),
      'childAgeMonth': 41,
      'childGender': true, // true: Male
      'childWeight': 16.5,
      'childHeight': 100.0,
    },
    {
      'childId': 2,
      'childName': 'Ana',
      'childLastName': 'Pérez',
      'childBirthDate': DateTime(2021, 8, 15),
      'childAgeMonth': 26,
      'childGender': false, // false: Female
      'childWeight': 12.3,
      'childHeight': 85.0,
    },
    {
      'childId': 3,
      'childName': 'Ana',
      'childLastName': 'Pérez',
      'childBirthDate': DateTime(2021, 8, 15),
      'childAgeMonth': 26,
      'childGender': false, // false: Female
      'childWeight': 12.3,
      'childHeight': 85.0,
    },
    {
      'childId': 4,
      'childName': 'López',
      'childLastName': 'Pérez',
      'childBirthDate': DateTime(2021, 8, 15),
      'childAgeMonth': 26,
      'childGender': false, // false: Female
      'childWeight': 12.3,
      'childHeight': 85.0,
    },
  ];

  final _formKey = GlobalKey<FormState>();

  void _onSelectChild(Map<String, dynamic>? value) {
    setState(() {
      selectedChild = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Niño'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar por niño',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),

              // Dropdown para selección de niño
              DropdownButtonFormField2<Map<String, dynamic>>(
                isExpanded: true,
                hint: Text(
                  'Selecciona un niño',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                items: children.map((child) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: child,
                    child: Text(
                      child['childName'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                value: selectedChild,
                onChanged: _onSelectChild,
                buttonStyleData: const ButtonStyleData(
                  height: 50,
                  padding: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.black),
                    ),
                    color: Colors.white,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              SizedBox(height: 16),

              // Listado de Cards con información del niño
              Expanded(
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return _buildChildCard(children[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterChildScreen()),
          );
        },
        backgroundColor: Color(0xFF83B56A),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildChildCard(Map<String, dynamic> child) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Columna con los datos del niño
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child['childName'] ?? 'Nombre no disponible', // Validación
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Edad: ${child['childAgeMonth'] ?? 0 ~/ 12} años y ${child['childAgeMonth'] ?? 0 % 12} meses',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    'Género: ${child['childGender'] != null && child['childGender'] ? 'Masculino' : 'Femenino'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  if (child['childWeight'] != null)
                    Text(
                      'Peso: ${child['childWeight']} kg',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  if (child['childHeight'] != null)
                    Text(
                      'Altura: ${child['childHeight']} cm',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  Text(
                    'Fecha de Nacimiento: ${child['childBirthDate'] != null ? "${child['childBirthDate'].day}/${child['childBirthDate'].month}/${child['childBirthDate'].year}" : 'No disponible'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Botón de edición
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xFF83B56A),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditChildProfileScreen(
                        child: Child(
                          childId: child['childId'] ?? 0,
                          childName: child['childName'] ?? '',
                          childLastName: child['childLastName'] ?? '',
                          childBirthDate:
                              child['childBirthDate'] ?? DateTime.now(),
                          childAgeMonth: child['childAgeMonth'] ?? 0,
                          childGender: child['childGender'] ?? true,
                          childCurrentWeight: child['childWeight'],
                          childCurrentHeight: child['childHeight'],
                          user: User(
                            userId: 1, // ID del usuario real
                            userFirstName: 'Carlos',
                            userLastName: 'Pérez',
                            userPassword: '123456',
                            userDNI: '12345678',
                            userPhone: '987654321',
                            userEmail: 'carlos.perez@example.com',
                            userRegistrationDate: DateTime.now(),
                            userPlace: 'Huancavelica',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
