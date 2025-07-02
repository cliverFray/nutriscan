import 'package:intl/intl.dart';

import 'users.dart';

class Child {
  final int childId;
  final String childName;
  final String childLastName;
  final DateTime childBirthDate; // Nueva propiedad para la fecha de nacimiento
  final int childAgeMonth;
  final bool childGender; // true: Male, false: Female
  final double? childCurrentWeight;
  final double? childCurrentHeight;

  Child(
      {required this.childId,
      required this.childName,
      required this.childLastName,
      required this.childBirthDate, // Nuevo parámetro requerido
      required this.childAgeMonth,
      required this.childGender,
      this.childCurrentWeight,
      this.childCurrentHeight});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'],
      childName: json['childName'] ?? '',
      childLastName: json['childLastName'] ?? '',
      childBirthDate: DateTime.parse(json['childBirthDate']),
      childAgeMonth: json['childAgeMonth'] ?? 0,
      childGender: json['childGender'] == true,
      childCurrentWeight: json['childCurrentWeight'] != null
          ? double.parse(json['childCurrentWeight'].toString())
          : null,
      childCurrentHeight: json['childCurrentHeight'] != null
          ? double.parse(json['childCurrentHeight'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'childName': childName,
      'childLastName': childLastName,
      'childBirthDate': DateFormat('yyyy-MM-dd')
          .format(childBirthDate), // Almacenar fecha en formato ISO
      'childAgeMonth': childAgeMonth,
      'childGender': childGender ? 1 : 0,
      'childCurrentWeight': childCurrentWeight,
      'childCurrentHeight': childCurrentHeight
    };
  }
}
