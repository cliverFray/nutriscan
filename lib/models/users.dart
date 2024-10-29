class User {
  final int userId;
  final String userFirstName;
  final String userLastName;
  final String userPassword;
  final String userDNI;
  final String userPhone;
  final String userEmail;
  final DateTime userRegistrationDate;
  final String userPlace;

  // Constructor
  User({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userPassword,
    required this.userDNI,
    required this.userPhone,
    required this.userEmail,
    required this.userRegistrationDate,
    required this.userPlace,
  });

  // Factory para crear un nuevo objeto desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userFirstName: json['userFirstName'],
      userLastName: json['userLastName'],
      userPassword: json['userPassword'],
      userDNI: json['userDNI'],
      userPhone: json['userPhone'],
      userEmail: json['userEmail'],
      userRegistrationDate: DateTime.parse(json['userRegistrationDate']),
      userPlace: json['userPlace'],
    );
  }
  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userPassword': userPassword,
      'userDNI': userDNI,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'userRegistrationDate': userRegistrationDate.toIso8601String(),
      'userPlace': userPlace,
    };
  }
}
