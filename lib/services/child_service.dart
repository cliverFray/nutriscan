import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/child.dart';
import '../models/users.dart';
import '../utils/base_url_back_ns.dart';

class ChildService {
  final String baseUrl =
      BaseUrlBackNs.baseUrl; // Cambia esto por tu URL de la API

  // Método para registrar un niño
  Future<String?> registerChild(Child child) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/children'), // Cambia el endpoint según sea necesario
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(child.toJson()),
      );

      if (response.statusCode == 200) {
        return null; // Registro exitoso
      } else {
        // Devuelve el mensaje de error del backend
        return json.decode(response.body)['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      // Manejo de errores de conexión
      return 'Error de conexión: $e';
    }
  }

  // Método para obtener la lista de niños de un usuario
  Future<List<Child>> getChildren(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/children?userId=$userId'), // Cambia el endpoint según sea necesario
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((childJson) => Child.fromJson(childJson))
            .toList();
      } else {
        // Devuelve el mensaje de error del backend
        throw Exception('Error al obtener la lista de niños');
      }
    } catch (e) {
      // Manejo de errores de conexión
      throw Exception('Error al obtener la lista de niños');
    }
  }

  // Eliminar un niño
  Future<void> deleteChild(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el niño');
    }
  }

  // Actualizar un niño
  Future<String?> updateChild(Child child) async {
    // Aquí harías la llamada al backend para actualizar el perfil del niño
    // Simulación de una llamada exitosa
    await Future.delayed(Duration(seconds: 2));
    return null; // Retorna null si no hay errores
  }

  // Método simulado para obtener niños
  List<Child> _simulateGetChildren(int userId) {
    // Generamos datos ficticios para la simulación
    return [
      Child(
        childId: 1,
        childName: 'Juan',
        childLastName: 'Pérez',
        childBirthDate: DateTime(2019, 10, 1), // Fecha de nacimiento agregada
        childAgeMonth: 36,
        childGender: true, // true: Male
        childCurrentWeight: 16.5,
        childCurrentHeight: 100,
        user: User(
          userId: userId,
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
      Child(
        childId: 2,
        childName: 'María',
        childLastName: 'González',
        childBirthDate: DateTime(2021, 6, 15), // Fecha de nacimiento agregada
        childAgeMonth: 24,
        childGender: false, // false: Female
        childCurrentWeight: 14.0,
        childCurrentHeight: 90,
        user: User(
          userId: userId,
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
      // Agrega más niños según sea necesario
    ];
  }
}
