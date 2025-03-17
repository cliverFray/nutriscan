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
      // Comprime la imagen antes de enviarla
      final compressedImage =
          await _compressImage.compressImage(image, maxWidth: 800);

      // Configura el FormData para enviar la imagen
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(compressedImage.path),
      });

      // Realiza la solicitud POST al endpoint correspondiente
      final response = await dioClient.post(
        '/detections/upload/$childId/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 201) {
        return {
          "detectionResult": response.data['detectionResult'],
          "immediateRecommendation": response.data['immediateRecommendation'],
        };
      } else {
        print(
            'Error al subir la imagen. Código de estado: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }

  // Método para obtener historial de detección
  Future<List<DetectionHistory>> fetchDetectionHistory() async {
    try {
      // Realiza la solicitud GET al endpoint del historial
      final response = await dioClient.get('/detections/history/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => DetectionHistory.fromJson(json)).toList();
      } else {
        throw Exception(
            'Error al cargar el historial de detecciones. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión: $e');
      return [];
    }
  }
}
