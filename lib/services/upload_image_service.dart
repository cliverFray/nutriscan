import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/users.dart';

//package para convertir a PNG
import 'package:image/image.dart' as img;

FirebaseStorage storage = FirebaseStorage.instance;

// Método para subir la imagen a Firebase Storage organizada por el identificador de usuario
Future<String> uploadImage(File image, User user) async {
  String fileName = image.path.split("/").last;

  try {
    // Usar el userId como parte de la ruta en el Storage
    //Reference ref = storage.ref().child('child_images/$user.userId/$fileName');
    Reference ref = storage.ref().child('child_images/$fileName');
    UploadTask uploadTask = ref.putFile(image);

    // Esperar a que termine la subida y obtener la URL de descarga
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error al subir imagen: $e');
    return '';
  }
}

Future<String> uploadImageAsPng(File image, User user) async {
  // Obtener el nombre original del archivo
  String fileName = image.path.split("/").last;

  try {
    // Leer la imagen como bytes
    final imageBytes = await image.readAsBytes();

    // Convertir la imagen a formato PNG
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw Exception('No se pudo decodificar la imagen.');
    }
    final pngBytes = img.encodePng(decodedImage);

    // Crear un archivo temporal con la imagen en formato PNG
    final tempDir = Directory.systemTemp;
    final pngFile = File('${tempDir.path}/$fileName.png');
    await pngFile.writeAsBytes(pngBytes);

    // Usar el userId como parte de la ruta en el Storage
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('child_images/${user.userId}/${fileName}.png');
    UploadTask uploadTask = ref.putFile(pngFile);

    // Esperar a que termine la subida y obtener la URL de descarga
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error al subir imagen: $e');
    return '';
  }
}

Future<String> uploadImageAsPng2(File image, User user) async {
  String fileName = image.path
      .split("/")
      .last
      .replaceAll(RegExp(r'\.[^.]+$'), '.png'); // Cambiar la extensión a .png

  try {
    // Convertir a PNG
    final img.Image originalImage =
        img.decodeImage(image.readAsBytesSync())!; // Usar paquete 'image'
    final List<int> pngBytes = img.encodePng(originalImage);

    // Crear un nuevo archivo temporal para la imagen PNG
    final tempDir = Directory.systemTemp;
    final File tempFile = File('${tempDir.path}/$fileName')
      ..writeAsBytesSync(pngBytes);

    // Subir la imagen PNG
    Reference ref = storage.ref().child('child_images/$user.userId/$fileName');
    UploadTask uploadTask = ref.putFile(tempFile);

    // Esperar a que termine la subida y obtener la URL de descarga
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error al subir imagen: $e');
    return '';
  }
}
