import 'package:flutter/material.dart';
import '../models/nutrition_model.dart';

class NutritionCard extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionCard({Key? key, required this.nutrition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutritional Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            _buildNutritionRow('Calories', '${nutrition.calories.toInt()}', 'kcal', Colors.orange),
            _buildNutritionRow('Protein', '${nutrition.protein.toStringAsFixed(1)}', 'g', Colors.red),
            _buildNutritionRow('Carbs', '${nutrition.carbs.toStringAsFixed(1)}', 'g', Colors.blue),
            _buildNutritionRow('Fat', '${nutrition.fat.toStringAsFixed(1)}', 'g', Colors.yellow),
            _buildNutritionRow('Fiber', '${nutrition.fiber.toStringAsFixed(1)}', 'g', Colors.green),
            _buildNutritionRow('Sugar', '${nutrition.sugar.toStringAsFixed(1)}', 'g', Colors.pink),
            _buildNutritionRow('Sodium', '${nutrition.sodium.toStringAsFixed(1)}', 'mg', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$value $unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}