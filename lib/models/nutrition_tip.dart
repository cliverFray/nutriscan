class NutritionTip {
  final int id;
  final String title;
  final String description;
  final int? calories;
  final String portionSize;
  final String imageUrl;

  NutritionTip({
    required this.id,
    required this.title,
    required this.description,
    this.calories,
    required this.portionSize,
    required this.imageUrl,
  });

  factory NutritionTip.fromJson(Map<String, dynamic> json) {
    return NutritionTip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      calories: json['calories'],
      portionSize: json['portion_size'],
      imageUrl: json['image_url'],
    );
  }
}
