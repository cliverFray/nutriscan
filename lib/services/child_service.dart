import 'package:dio/dio.dart';

import '../models/child.dart';
import '../utils/base_url_back_ns.dart';

import '../utils/dio_client.dart';

class ChildService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  ChildService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }
  // Método para registrar un niño
  Future<String?> registerChild(Child child) async {
    try {
      final response = await dioClient.post(
        '/child/register/',
        data: child.toJson(),
      );

      if (response.statusCode == 201) {
        return null; // Registro exitoso
      } else {
        final errorResponse = response.data;
        return errorResponse['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }

  // Método para obtener la lista de niños de un usuario
  Future<List<Child>> getChildren() async {
    try {
      final response = await dioClient.get('/children/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        //print(response.data);
        return jsonResponse
            .map((childJson) => Child.fromJson(childJson))
            .toList();
      } else {
        throw Exception('Error al obtener la lista de niños');
      }
    } catch (e, stacktrace) {
      print("Stacktrace: $stacktrace");
      throw Exception("Error de conexión: ${e.toString()}");
    }
  }

  // Método para obtener los nombres de los niños
  Future<List<Map<String, dynamic>>> getChildrenNames() async {
    try {
      final response = await dioClient.get('/children/names/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        return jsonResponse
            .map((child) => {
                  'childId': child['childId'],
                  'childName': child['childName'],
                })
            .toList();
      } else {
        throw Exception('Error al obtener los nombres de los niños');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para eliminar un niño
  Future<void> deleteChild(int id) async {
    try {
      final response = await dioClient.delete('/children/$id/');

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar el niño');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener detalles de un niño por ID
  Future<Child?> getChildById(int childId) async {
    try {
      final response = await dioClient.get('/children/$childId/');

      if (response.statusCode == 200) {
        return Child.fromJson(response.data);
      } else {
        throw Exception('Error al obtener los datos del niño');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para actualizar información de un niño
  Future<String?> updateChild(Child child) async {
    try {
      final response = await dioClient.put(
        '/child/update/${child.childId}/',
        data: child.toJson(),
      );

      if (response.statusCode == 200) {
        return null; // Indica éxito
      } else {
        final errorResponse = response.data;
        return errorResponse['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
