import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width; // Parámetro opcional para el ancho
  final double? height; // Parámetro opcional para el alto
  final Color backcolor; // Parámetro opcional para color de fondo
  final Color forecolor; // Parámetro opcional para color del texto del boton

  CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width, // Inicializa los parámetros opcionales
    this.height,
    this.backcolor = const Color(0xFF83B56A),
    this.forecolor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Usa el ancho proporcionado
      height: height, // Usa el alto proporcionado
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backcolor, // Color de fondo del botón
          foregroundColor: forecolor, // Color del texto del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
