// models/nutritional_term.dart

class NutritionalTerm {
  final String name;
  final String description;
  final String examples;
  final String imageUrl;

  NutritionalTerm({
    required this.name,
    required this.description,
    required this.examples,
    required this.imageUrl,
  });

  factory NutritionalTerm.fromJson(Map<String, dynamic> json) {
    return NutritionalTerm(
      name: json['name'],
      description: json['description'],
      examples: json['examples'],
      imageUrl: json['image_url'],
    );
  }
}
