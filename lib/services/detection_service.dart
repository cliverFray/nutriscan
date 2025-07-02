import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/compressImage.dart';
import '../models/detectionHistory.dart';
import '../utils/base_url_back_ns.dart';

import '../utils/dio_client.dart';

class DetectionService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  DetectionService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }
  final CompressImage _compressImage = CompressImage();
  // Método para subir imagen de detección
  // Método para subir imagen de detección
  Future<Map<String, String?>?> uploadDetectionImage({
    required int childId,
    required File image,
  }) async {
    try {
      // Obtiene la extensión de la imagen
      final extension = image.path.split('.').last.toLowerCase();

      File fileToUpload;

      if (extension == 'heic') {
        // NO intentes comprimir si es HEIC
        fileToUpload = image;
      } else {
        // Comprime la imagen si NO es HEIC
        final compressed =
            await _compressImage.compressImage(image, maxWidth: 800);
        fileToUpload = compressed;
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(fileToUpload.path),
      });

      // Realiza la solicitud POST al endpoint correspondiente
      final response = await dioClient.post(
        '/detections/upload/$childId/',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 201) {
        print("Rcoemndacionnnnnn: ${response.data['immediateRecommendation']}");
        return {
          "detectionResult": response.data['detectionResult'],
          "confidence": response.data['confidence']?.toString(), // ← agregado
          "immediateRecommendation": response.data['immediateRecommendation'],
          "imc": response.data['imc'] != null
              ? response.data['imc'].toString()
              : "0.0",
          "imcCategory": response.data['imcCategory'],
        };
      } else {
        print(
            'Error al subir la imagen. Código de estado: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return {"error": _parseUpdateError(e.response?.data)};
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.badCertificate ||
          e.type == DioExceptionType.cancel) {
        // Error de conexión o tiempo de espera agotado
        return {
          "error": "El servidor tardó demasiado tiempo (>30s) en responder."
        };
      }
      return {
        "conexionerror":
            "Hubo error al cargar y procesar la imagen, conectate a internet"
      };
    } catch (e) {
      print("Errorrrrrr: $e");
      return {
        "unknowerror":
            'Error desconocido intentalo nuevamente o conctate con el soporte tecnico en la seccion de perfil'
      };
    }
  }

  String _parseUpdateError(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('error')) return data['error'];
      if (data.containsKey('user_errors')) {
        return data['user_errors'].values.first[0];
      }
    }
    return 'Error desconocido al procesar la imagen.';
  }

  // Método para obtener historial de detección
  Future<List<DetectionHistory>> fetchDetectionHistory() async {
    try {
      final response = await dioClient.get('/detections/history/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => DetectionHistory.fromJson(json)).toList();
      } else {
        // Error HTTP
        throw Exception(
            'Error al cargar el historial. Código de estado: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.badCertificate ||
          e.type == DioExceptionType.cancel) {
        // Error de conexión o tiempo de espera agotado
        print('No hay conexión a internet o timeout: ${e.message}');
      } else if (e.type == DioExceptionType.badResponse) {
        // El servidor respondió con un error
        print(
            'Error del servidor: ${e.response?.statusCode}, ${e.response?.data}');
      } else {
        // Otros errores relacionados con la solicitud
        print('Error desconocido de Dio: ${e.message}');
      }
      return []; // Devuelve una lista vacía como fallback
    } catch (e) {
      // Errores inesperados
      print('Error inesperado: $e');
      return [];
    }
  }

  // Método para verificar si ya se hizo una detección hoy para el niño
  Future<Map<String, dynamic>> checkDailyDetection(int childId) async {
    try {
      final response =
          await dioClient.get('/verification/check-detection-today/$childId/');

      if (response.statusCode == 200) {
        return {
          "exists": response.data["exists"],
          "message": response.data["message"],
        };
      } else {
        return {
          "error":
              "No se pudo verificar la detección. Código: ${response.statusCode}"
        };
      }
    } on DioException catch (e) {
      return {
        "error": e.response?.data['error'] ??
            "Error de conexión o servidor al verificar la detección."
      };
    } catch (e) {
      return {
        "error":
            "Error desconocido al verificar detección. Intenta nuevamente más tarde."
      };
    }
  }
}
