import 'package:flutter/material.dart';

class NameApp extends StatelessWidget {
  const NameApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'NutriScan',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Color(0xFF83B56A),
      ),
    );
  }
}
