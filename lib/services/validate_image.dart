import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/compressImage.dart';
import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';

class ImageValidationService {
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late final DioClient dioClient;
  ImageValidationService() {
    dioClient = DioClient(baseUrl); // Aquí puedes usar baseUrl
  }
  final CompressImage _compressImage = CompressImage();

  Future<Map<String, dynamic>> validateImage(File image) async {
    try {
      // Redimensionar y comprimir la imagen
      final compressedImage =
          await _compressImage.compressImage(image, maxWidth: 800);

      // Prepara los datos para la solicitud multipart
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(compressedImage.path),
      });

      // Realiza la solicitud POST al endpoint para validar la imagen
      final response = await dioClient.dio.post(
        '/validate-image/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        // Procesa la respuesta si es exitosa
        return response.data as Map<String, dynamic>;
      } else {
        // Maneja errores de respuesta
        return {
          'valid': false,
          'message':
              'Error al validar la imagen. Código de estado: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Maneja errores de conexión u otros
      return {'valid': false, 'message': 'Error de conexión: $e'};
    }
  }
}
