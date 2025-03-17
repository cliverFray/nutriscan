import 'package:dio/dio.dart';

import '../utils/base_url_back_ns.dart';
import '../utils/dio_client.dart';

class ImageService {
  // URL base de tu API, puedes cambiarlo según tu configuración
  final String baseUrl = BaseUrlBackNs.baseUrl; // URL base de la API
  late Dio dioClient;
  ImageService() {
    dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors.add(AuthInterceptor(dioClient, baseUrl));
  }

  // Método para obtener la URL firmada de la imagen
  // Método para obtener la URL firmada de la imagen
  // Método para obtener la URL firmada de la imagen
  Future<void> getImageUrl(
    int detectionId,
    Function(String) onImageUrlReceived,
  ) async {
    try {
      // Realiza la solicitud GET al endpoint para obtener la URL firmada
      final response =
          await dioClient.get('/generate_presigned_url/$detectionId/');

      if (response.statusCode == 200) {
        // Extrae la URL de la respuesta
        final String imageUrl = response.data['imageUrl'];

        // Llama al callback con la URL de la imagen
        onImageUrlReceived(imageUrl);
      } else {
        // Si hubo un error, muestra un mensaje
        print(
            "Error al obtener la URL firmada. Código: ${response.statusCode}");
      }
    } catch (e) {
      // Manejo de excepciones en caso de problemas con la solicitud
      print("Error al hacer la solicitud: $e");
    }
  }
}
