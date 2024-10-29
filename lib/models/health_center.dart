// health_center.dart
class HealthCenter {
  final int healthCenterId;
  final String healthCenterName;
  final String healthCenterAddress;
  final String healthCenterEmail;
  final String healthCenterPhone;
  final String healthCenterContactPerson;

  HealthCenter({
    required this.healthCenterId,
    required this.healthCenterName,
    required this.healthCenterAddress,
    required this.healthCenterEmail,
    required this.healthCenterPhone,
    required this.healthCenterContactPerson,
  });

  factory HealthCenter.fromJson(Map<String, dynamic> json) {
    return HealthCenter(
      healthCenterId: json['healthCenterId'],
      healthCenterName: json['healthCenterName'],
      healthCenterAddress: json['healthCenterAddress'],
      healthCenterEmail: json['healthCenterEmail'],
      healthCenterPhone: json['healthCenterPhone'],
      healthCenterContactPerson: json['healthCenterContactPerson'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthCenterId': healthCenterId,
      'healthCenterName': healthCenterName,
      'healthCenterAddress': healthCenterAddress,
      'healthCenterEmail': healthCenterEmail,
      'healthCenterPhone': healthCenterPhone,
      'healthCenterContactPerson': healthCenterContactPerson,
    };
  }
}
