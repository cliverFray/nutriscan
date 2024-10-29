import 'package:flutter/material.dart';

class IconButtonWithText extends StatelessWidget {
  final Icon icon;
  final String labelText;
  final VoidCallback onPressed;

  IconButtonWithText({
    required this.icon,
    required this.labelText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(labelText),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF83B56A), // Color de fondo
        foregroundColor: Color(0xFFFFFFFF), // Color del texto e ícono
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
