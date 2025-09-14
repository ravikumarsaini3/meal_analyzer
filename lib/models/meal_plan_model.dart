class PlannedMeal {
  final String name;
  final int calories;
  final List<String> ingredients;

  PlannedMeal({
    required this.name,
    required this.calories,
    required this.ingredients,
  });

  factory PlannedMeal.fromJson(Map<String, dynamic> json) {
    int parseCalories(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(cleaned) ?? 0;
      }
      return 0;
    }

    return PlannedMeal(
      name: json['name'] ?? '',
      calories: parseCalories(json['calories']),
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'ingredients': ingredients,
    };
  }
}

class MealPlan {
  int? dbId;
  final PlannedMeal? breakfast;
  final PlannedMeal? lunch;
  final PlannedMeal? dinner;
  final List<PlannedMeal> snacks;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final DateTime createdAt;

  MealPlan({
   required this.dbId,
    this.breakfast,
    this.lunch,
    this.dinner,
    required this.snacks,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast?.toJson(),
      'lunch': lunch?.toJson(),
      'dinner': dinner?.toJson(),
      'snacks': snacks.map((s) => s.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json, {int? dbId}) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(cleaned) ?? 0;
      }
      return 0;
    }

    return MealPlan(
      dbId: dbId,
      breakfast: json['breakfast'] != null
          ? PlannedMeal.fromJson(json['breakfast'])
          : null,
      lunch: json['lunch'] != null
          ? PlannedMeal.fromJson(json['lunch'])
          : null,
      dinner: json['dinner'] != null
          ? PlannedMeal.fromJson(json['dinner'])
          : null,
      snacks: (json['snacks'] as List<dynamic>? ?? [])
          .map((snack) => PlannedMeal.fromJson(snack))
          .toList(),
      totalCalories: parseInt(json['totalCalories']),
      totalProtein: parseInt(json['totalProtein']),
      totalCarbs: parseInt(json['totalCarbs']),
      totalFat: parseInt(json['totalFat']),
      createdAt: DateTime.now(),
    );
  }
}

