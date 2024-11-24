import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CompressImage {
  // Función para redimensionar y comprimir la imagen
  Future<File> compressImage(File file, {int maxWidth = 800}) async {
    // Lee la imagen original
    final image = img.decodeImage(await file.readAsBytes());

    // Redimensiona la imagen manteniendo la relación de aspecto
    final resizedImage = img.copyResize(image!, width: maxWidth);

    // Guarda la imagen redimensionada en el directorio temporal
    final tempDir = await getTemporaryDirectory();
    final compressedFile = File('${tempDir.path}/compressed_image.jpg')
      ..writeAsBytesSync(
          img.encodeJpg(resizedImage, quality: 85)); // Calidad del 85%

    return compressedFile;
  }
}
