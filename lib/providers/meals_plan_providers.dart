import 'package:flutter/material.dart';

import '../models/meal_plan_model.dart';
import '../services/database_service.dart';
import '../services/gemini_service.dart';

class MealPlanProvider with ChangeNotifier {
  MealPlan? _currentMealPlan;
  List<MealPlan> _savedPlans = [];
  bool _isLoading = false;
  String? _error;

  MealPlan? get currentMealPlan => _currentMealPlan;

  List<MealPlan> get savedPlans => _savedPlans;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> generateMealPlan({
    required int targetCalories,
    required List<String> dietaryRestrictions,
    required List<String> preferredMeals,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final geminiService = GeminiService();
      final planData = await geminiService.generateMealPlan(
        targetCalories: targetCalories,
        dietaryRestrictions: dietaryRestrictions,
        preferredMeals: preferredMeals,
      );

      _currentMealPlan = MealPlan.fromJson(planData);

      //  await MealPlanDatabaseService.savePlan(_currentMealPlan!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMealPlan(MealPlan plan) async {
    final dbId = await MealPlanDatabaseService.savePlan(plan);
    plan.dbId = dbId; // save DB id
    _savedPlans.insert(0, plan);
    notifyListeners();
  }


  Future<void> loadSavedPlans() async {
    _savedPlans = await MealPlanDatabaseService.getPlans();
    notifyListeners();
  }

  void clearCurrentPlan() {
    _currentMealPlan = null;
    notifyListeners();
  }

  Future<void> deletePlan(MealPlan plan) async {
    if (plan.dbId == null) return;
    await MealPlanDatabaseService.deletePlan(plan.dbId!);
    _savedPlans.removeWhere((p) => p.dbId == plan.dbId);
    if (_currentMealPlan?.dbId == plan.dbId) {
      _currentMealPlan = null;
    }
    notifyListeners();
  }

}
