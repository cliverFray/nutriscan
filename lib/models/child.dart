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
  final User user; // Relación con la clase User

  Child({
    required this.childId,
    required this.childName,
    required this.childLastName,
    required this.childBirthDate, // Nuevo parámetro requerido
    required this.childAgeMonth,
    required this.childGender,
    this.childCurrentWeight,
    this.childCurrentHeight,
    required this.user,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      childId: json['childId'],
      childName: json['childName'],
      childLastName: json['childLastName'],
      childBirthDate:
          DateTime.parse(json['birthDate']), // Convertir fecha de JSON
      childAgeMonth: json['childAgeMonth'],
      childGender: json['childGender'] == 1,
      childCurrentWeight: json['childCurrentWeight'],
      childCurrentHeight: json['childCurrentHeight'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'childName': childName,
      'childLastName': childLastName,
      'birthDate':
          childBirthDate.toIso8601String(), // Almacenar fecha en formato ISO
      'childAgeMonth': childAgeMonth,
      'childGender': childGender ? 1 : 0,
      'childCurrentWeight': childCurrentWeight,
      'childCurrentHeight': childCurrentHeight,
      'user': user.toJson(),
    };
  }
}
