import 'dart:io';
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../models/nutrition_model.dart';
import '../services/gemini_service.dart';
import '../services/database_service.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _error;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMeals() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _meals = await DatabaseService.getAllMeals();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Meal?> analyzeMeal(File imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final geminiService = GeminiService();
      final analysisResult = await geminiService.analyzeMealImage(imageFile);

      final meal = Meal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: analysisResult['name'] ?? 'Unknown Meal',
        description: analysisResult['description'] ?? '',
        ingredients: List<String>.from(analysisResult['ingredients'] ?? []),
        nutrition: Nutrition.fromJson(analysisResult['nutrition'] ?? {}),
        imagePath: imageFile.path,
        analyzedAt: DateTime.now(),
      );

      await DatabaseService.saveMeal(meal);
      _meals.insert(0, meal);

      _isLoading = false;
      notifyListeners();

      return meal;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await DatabaseService.deleteMeal(id);
      _meals.removeWhere((meal) => meal.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}