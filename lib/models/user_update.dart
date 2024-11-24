class UserUpdate {
  final String userFirstName;
  final String userLastName;
  final String? userPassword;
  final String userDNI;
  final String userPhone;
  final String userEmail;
  final String userPlace;

  // Constructor
  UserUpdate({
    required this.userFirstName,
    required this.userLastName,
    this.userPassword,
    required this.userDNI,
    required this.userPhone,
    required this.userEmail,
    required this.userPlace,
  });

  // Factory para crear un nuevo objeto desde JSON
  factory UserUpdate.fromJson(Map<String, dynamic> json) {
    return UserUpdate(
      userFirstName: json['user']['user']['first_name'],
      userLastName: json['user']['user']['last_name'],
      userPassword: json['user']['user'].containsKey('password')
          ? json['user']['user']['password']
          : null,
      userDNI: json['user']['userDNI'],
      userPhone: json['user']['userPhone'],
      userEmail: json['user']['user']['email'],
      userPlace: json['user']['userPlace'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'first_name': userFirstName,
        'last_name': userLastName,
        'password': userPassword,
        'email': userEmail,
      },
      'userDNI': userDNI,
      'userPhone': userPhone,
      'userPlace': userPlace,
    };
  }
}
