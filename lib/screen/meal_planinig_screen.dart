import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal_plan_model.dart';
import '../providers/meals_plan_providers.dart';

class MealPlanningScreen extends StatefulWidget {
  @override
  _MealPlanningScreenState createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController(text: '2000');

  List<String> _selectedRestrictions = [];
  List<String> _selectedMealTypes = ['breakfast', 'lunch', 'dinner'];

  final List<String> _availableRestrictions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Low-Carb',
    'High-Protein',
    'Nut-Free'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planning'),
        centerTitle: true,
      ),
      body: Consumer<MealPlanProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating your meal plan...'),
                ],
              ),
            );
          }

          if (provider.currentMealPlan != null) {
            return _buildMealPlanView(provider.currentMealPlan!);
          }

          return _buildPlanningForm();
        },
      ),
    );
  }

  Widget _buildPlanningForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Calorie Target',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter target calories',
                        suffixText: 'kcal',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter target calories';
                        }
                        final calories = int.tryParse(value);
                        if (calories == null || calories < 1000 || calories > 4000) {
                          return 'Please enter a value between 1000-4000';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dietary Restrictions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableRestrictions.map((restriction) {
                        final isSelected = _selectedRestrictions.contains(restriction);
                        return FilterChip(
                          label: Text(restriction),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedRestrictions.add(restriction);
                              } else {
                                _selectedRestrictions.remove(restriction);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Types',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    ...['breakfast', 'lunch', 'dinner', 'snacks'].map((mealType) {
                      return CheckboxListTile(
                        title: Text(mealType.toUpperCase()),
                        value: _selectedMealTypes.contains(mealType),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedMealTypes.add(mealType);
                            } else {
                              _selectedMealTypes.remove(mealType);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateMealPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Generate Meal Plan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlanView(MealPlan mealPlan) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Daily Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Calories', '${mealPlan.totalCalories}', 'kcal'),
                      _buildSummaryItem('Protein', '${mealPlan.totalProtein}g', ''),
                      _buildSummaryItem('Carbs', '${mealPlan.totalCarbs}g', ''),
                      _buildSummaryItem('Fat', '${mealPlan.totalFat}g', ''),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          if (mealPlan.breakfast != null)
            _buildMealCard('Breakfast', mealPlan.breakfast!, Icons.wb_sunny),
          if (mealPlan.lunch != null)
            _buildMealCard('Lunch', mealPlan.lunch!, Icons.wb_cloudy),
          if (mealPlan.dinner != null)
            _buildMealCard('Dinner', mealPlan.dinner!, Icons.nightlight_round),
          if (mealPlan.snacks.isNotEmpty)
            ...mealPlan.snacks.asMap().entries.map((entry) =>
                _buildMealCard('Snack ${entry.key + 1}', entry.value, Icons.local_cafe)
            ),

          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Provider.of<MealPlanProvider>(context, listen: false).clearCurrentPlan();
                  },
                  child: Text('New Plan'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<MealPlanProvider>(context, listen: false).saveMealPlan(mealPlan);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Meal plan saved!')),
                    );
                  },
                  child: Text('Save Plan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildMealCard(String mealType, PlannedMeal meal, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  mealType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  '${meal.calories} kcal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              meal.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Ingredients: ${meal.ingredients.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _generateMealPlan() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<MealPlanProvider>(context, listen: false);

      await provider.generateMealPlan(
        targetCalories: int.parse(_caloriesController.text),
        dietaryRestrictions: _selectedRestrictions,
        preferredMeals: _selectedMealTypes,
      );

      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}