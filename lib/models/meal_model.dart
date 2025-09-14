import 'nutrition_model.dart';

class Meal {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final Nutrition nutrition;
  final String imagePath;
  final DateTime analyzedAt;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.nutrition,
    required this.imagePath,
    required this.analyzedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      imagePath: json['imagePath'] ?? '',
      analyzedAt: DateTime.parse(json['analyzedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'nutrition': nutrition,
      'imagePath': imagePath,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }
}