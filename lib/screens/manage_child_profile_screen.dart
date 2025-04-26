import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../services/child_service.dart';
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
  final ChildService _childService = ChildService();
  List<Child> children = [];
  Child? selectedChild;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'es');

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final List<Child> fetchedChildren = await _childService.getChildren();
      setState(() {
        children = fetchedChildren;
      });
    } catch (e) {
      print('Error loading children: $e');
    }
  }

  void _onSelectChild(Child? value) {
    setState(() {
      selectedChild = value;
    });
  }

  List<Child> get _filteredChildren {
    if (selectedChild == null) {
      return children;
    } else {
      return children
          .where((child) => child.childId == selectedChild!.childId)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Niño'),
        backgroundColor: Color(0xFF83B56A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
            DropdownButtonFormField2<Child>(
              isExpanded: true,
              hint: Text(
                'Selecciona un niño',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              items: [
                DropdownMenuItem<Child>(
                  value: null,
                  child: Text(
                    'Todos los niños',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                ...children.map((child) {
                  return DropdownMenuItem<Child>(
                    value: child,
                    child: Text(
                      child.childName,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ],
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
              child: children.isEmpty
                  ? Center(child: Text('No hay niños registrados.'))
                  : ListView.builder(
                      itemCount: _filteredChildren.length,
                      itemBuilder: (context, index) {
                        return _buildChildCard(_filteredChildren[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterChildScreen()),
          ).then((_) => _loadChildren());
        },
        backgroundColor: Color(0xFF83B56A),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildChildCard(Child child) {
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
                    child.childName, // Validación
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Edad: ${child.childAgeMonth ~/ 12} años y ${child.childAgeMonth % 12} meses',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    'Género: ${child.childGender ? 'Masculino' : 'Femenino'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  if (child.childCurrentWeight != null)
                    Text(
                      'Peso: ${child.childCurrentWeight} kg',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  if (child.childCurrentHeight != null)
                    Text(
                      'Altura: ${child.childCurrentHeight} cm',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  Text(
                    'Fecha de Nacimiento: ${dateFormat.format(child.childBirthDate)}',
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
                onPressed: () async {
                  if (child.childId != null) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditChildProfileScreen(childId: child.childId),
                      ),
                    );

                    if (result == true) {
                      // Recargar datos solo si hubo cambios
                      await _loadChildren();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Error: No se pudo encontrar el ID del niño'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
