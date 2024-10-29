import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Icon? suffixIcon; // Parámetro opcional para el ícono
  final VoidCallback? onTap; // Parámetro opcional para el evento onTap

  const CustomTextInput({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon, // Se agrega el parámetro
    this.onTap, // Se agrega el parámetro onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      onTap: onTap, // Se agrega el evento onTap
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF666666)),
        fillColor: const Color(0xFFF4F4F4),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        suffixIcon: suffixIcon, // Se añade el ícono a la decoración
      ),
    );
  }
}
