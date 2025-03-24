// Modelo en Flutter
class Feedback {
  final int id;
  final String message;
  final DateTime dateCreated;
  final DateTime dateModified;

  Feedback({
    required this.id,
    required this.message,
    required this.dateCreated,
    required this.dateModified,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      message: json['message'],
      dateCreated: DateTime.parse(json['date_created']),
      dateModified: DateTime.parse(json['date_modified']),
    );
  }
}
