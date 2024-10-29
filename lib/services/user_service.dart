import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/users.dart';
import '../utils/base_url_back_ns.dart';

class UserService {
  final String baseUrl =
      BaseUrlBackNs.baseUrl; // Cambia esto por tu URL de la API

  // Método para registrar un usuario
  Future<String?> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/register'), // Cambia el endpoint según sea necesario
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return null; // Registro exitoso
      } else {
        // Devuelve el mensaje de error del backend
        return json.decode(response.body)['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      // Manejo de errores de conexión
      print(e);
      return 'Error de conexión: $e';
    }
  }

  // Método para iniciar sesión
  Future<String?> loginUser(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'), // Cambia el endpoint según sea necesario
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userPhone': phone,
          'userPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, puedes procesar la respuesta aquí
        return null; // Login exitoso
      } else {
        // Devuelve el mensaje de error del backend
        return json.decode(response.body)['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      // Manejo de errores de conexión
      return 'Error de conexión: $e';
    }
  }

  // Método para obtener los datos del usuario actual
  /* Future<User?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/user/current'), // Endpoint para obtener usuario logueado
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer YOUR_ACCESS_TOKEN', // Añade el token de acceso si es necesario
        },
      );

      if (response.statusCode == 200) {
        // Procesar y devolver el usuario actual
        return User.fromJson(json.decode(response.body));
      } else {
        return null; // No se pudo obtener el usuario
      }
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  } */
  Future<User?> getCurrentUser() async {
    try {
      // Simular un retraso de red
      await Future.delayed(Duration(seconds: 1));

      // JSON de prueba
      final fakeJsonResponse = {
        "userId": 12345,
        "userFirstName": "Carlos",
        "userLastName": "Perez",
        "userPassword": "password123",
        "userDNI": "12345678",
        "userPhone": "+51987654321",
        "userEmail": "carlos.perez@example.com",
        "userRegistrationDate": "2023-09-20T10:30:00Z",
        "userPlace": "Huancavelica"
      };

      // Convertir el JSON fake a un objeto User
      return User.fromJson(fakeJsonResponse);
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  //para cambiar contraseña
  Future<String?> sendPasswordResetOTP(String phone) async {
    try {
      // Simulación de llamada al backend
      await Future.delayed(Duration(seconds: 2)); // Simular espera
      return null; // Retorna null si es exitoso
    } catch (e) {
      return 'Error al enviar OTP. Inténtalo de nuevo.'; // Mensaje de error
    }
  }
}
