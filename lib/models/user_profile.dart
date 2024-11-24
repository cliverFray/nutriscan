class UserProfile {
  final String userFirstName;
  final String userLastName;
  final String userDNI;
  final String userPhone;
  final String userPlace;

  // Constructor
  UserProfile({
    required this.userFirstName,
    required this.userLastName,
    required this.userDNI,
    required this.userPhone,
    required this.userPlace,
  });

  // Factory para crear un nuevo objeto desde JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userFirstName: json['first_name'],
      userLastName: json['last_name'],
      userDNI: json['userDNI'],
      userPhone: json['userPhone'],
      userPlace: json['userPlace'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': userFirstName,
      'last_name': userLastName,
      'userDNI': userDNI,
      'userPhone': userPhone,
      'userPlace': userPlace,
    };
  }
}
