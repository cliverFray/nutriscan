// notification.dart
import 'users.dart';

class Notification {
  final int notificationId;
  final String notificationTitle;
  final String notificationDescription;
  final DateTime notificationDate;
  final User user; // Relación con User

  Notification({
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationDescription,
    required this.notificationDate,
    required this.user, // Cambiado a User
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationId'],
      notificationTitle: json['notificationTitle'],
      notificationDescription: json['notificationDescription'],
      notificationDate: DateTime.parse(json['notificationDate']),
      user:
          User.fromJson(json['user']), // Crear un objeto User a partir del JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'notificationTitle': notificationTitle,
      'notificationDescription': notificationDescription,
      'notificationDate': notificationDate.toIso8601String(),
      'user': user.toJson(), // Convertir el objeto User a JSON
    };
  }
}
