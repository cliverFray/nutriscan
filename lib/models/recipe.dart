// recipe.dart
class Recipe {
  final int recipeId;
  final String recipeName;
  final String recipeDescription;
  final String recipeIngredients;
  final String recipeInstructions;
  final double recipeEstimatedPrice;

  Recipe({
    required this.recipeId,
    required this.recipeName,
    required this.recipeDescription,
    required this.recipeIngredients,
    required this.recipeInstructions,
    required this.recipeEstimatedPrice,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipeId'],
      recipeName: json['recipeName'],
      recipeDescription: json['recipeDescription'],
      recipeIngredients: json['recipeIngredients'],
      recipeInstructions: json['recipeInstructions'],
      recipeEstimatedPrice: json['recipeEstimatedPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'recipeDescription': recipeDescription,
      'recipeIngredients': recipeIngredients,
      'recipeInstructions': recipeInstructions,
      'recipeEstimatedPrice': recipeEstimatedPrice,
    };
  }
}
