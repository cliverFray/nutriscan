import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  final String text;

  const CustomTitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        color: Color(0xFF000000),
      ),
    );
  }
}
