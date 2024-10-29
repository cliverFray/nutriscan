// recommendation_recipe.dart
import 'nutritional_recommendation.dart';
import 'recipe.dart';

class RecommendationRecipe {
  final Recipe recipe; // Clase Recipe
  final NutritionalRecommendation
      nutrRecommendation; // Clase NutritionalRecommendation

  RecommendationRecipe({
    required this.recipe,
    required this.nutrRecommendation,
  });

  factory RecommendationRecipe.fromJson(Map<String, dynamic> json) {
    return RecommendationRecipe(
      recipe: Recipe.fromJson(json['recipe']),
      nutrRecommendation:
          NutritionalRecommendation.fromJson(json['nutrrecommendation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe': recipe.toJson(),
      'nutrrecommendation': nutrRecommendation.toJson(),
    };
  }
}
