import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meal_analyzer_app/screen/meal_planinig_screen.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/meal_provider.dart';

import '../models/meal_model.dart';
import '../models/meal_plan_model.dart';
import '../providers/meals_plan_providers.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).loadMeals();
      Provider.of<MealPlanProvider>(context, listen: false).loadSavedPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History & Analytics'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Meals'),
            Tab(text: 'Plans'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(),
          _buildPlansTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  // ----------- MEAL HISTORY TAB -----------
  Widget _buildHistoryTab() {
    return Consumer<MealProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (provider.meals.isEmpty) {
          return Center(child: Text('No meals analyzed yet'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: provider.meals.length,
          itemBuilder: (context, index) {
            final meal = provider.meals[index];
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => MealDetailScreen(meal: meal),
                //   ),
                // );
              },
              child: _buildMealHistoryCard(meal, provider),
            );
          },
        );
      },
    );
  }

  Widget _buildMealHistoryCard(Meal meal, MealProvider provider) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(meal.imagePath),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.name, style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 4),
                  Text('${meal.nutrition.calories.toInt()} kcal',
                      style: TextStyle(color: Colors.orange)),
                  SizedBox(height: 4),
                  Text(_formatDate(meal.analyzedAt),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showDeleteDialog(meal, provider),
              icon: Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  // ----------- SAVED PLANS TAB -----------
  Widget _buildPlansTab() {
    return Consumer<MealPlanProvider>(
      builder: (context, provider, child) {
        if (provider.savedPlans.isEmpty) {
          return Center(child: Text('No saved meal plans yet'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: provider.savedPlans.length,
          itemBuilder: (context, index) {
            final plan = provider.savedPlans[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealPlanningScreen()
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Meal Plan - ${plan.totalCalories} kcal',
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 8),
                      Text(
                        'Protein: ${plan.totalProtein}g | Carbs: ${plan.totalCarbs}g | Fat: ${plan.totalFat}g',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      IconButton(
                        onPressed: () =>     provider.deletePlan(plan),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ----------- ANALYTICS TAB -----------
  Widget _buildAnalyticsTab() {
    return Consumer<MealProvider>(
      builder: (context, provider, child) {
        if (provider.meals.isEmpty) {
          return Center(child: Text('No data available for analytics'));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildWeeklyCaloriesChart(provider.meals),
              SizedBox(height: 24),
              _buildNutritionSummary(provider.meals),
              SizedBox(height: 24),
              _buildMacroDistributionChart(provider.meals),
            ],
          ),
        );
      },
    );
  }


  Widget _buildWeeklyCaloriesChart(List<Meal> meals) {
    final weeklyData = _getWeeklyCaloriesData(meals);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Calories', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(days[value.toInt() % 7]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyData,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNutritionSummary(List<Meal> meals) {
    final totalCalories = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.calories);
    final avgCalories = totalCalories / meals.length;
    final totalProtein = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.protein);
    final totalCarbs = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.carbs);
    final totalFat = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.fat);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nutrition Summary', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Meals', '${meals.length}', ''),
                _buildSummaryItem('Avg Calories', '${avgCalories.toInt()}', 'kcal'),
                _buildSummaryItem('Total Protein', '${totalProtein.toInt()}g', ''),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Carbs', '${totalCarbs.toInt()}g', ''),
                _buildSummaryItem('Total Fat', '${totalFat.toInt()}g', ''),
                _buildSummaryItem('Total Calories', '${totalCalories.toInt()}', 'kcal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }


  Widget _buildMacroDistributionChart(List<Meal> meals) {
    final totalProtein = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.protein);
    final totalCarbs = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.carbs);
    final totalFat = meals.fold<double>(0, (sum, meal) => sum + meal.nutrition.fat);
    final total = totalProtein + totalCarbs + totalFat;

    if (total == 0) return Container();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macro Distribution', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: totalProtein,
                      title: 'Protein\n${(totalProtein / total * 100).toInt()}%',
                      color: Colors.red,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: totalCarbs,
                      title: 'Carbs\n${(totalCarbs / total * 100).toInt()}%',
                      color: Colors.blue,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: totalFat,
                      title: 'Fat\n${(totalFat / total * 100).toInt()}%',
                      color: Colors.yellow,
                      radius: 60,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<FlSpot> _getWeeklyCaloriesData(List<Meal> meals) {
    Map<int, double> dailyCalories = {for (int i = 0; i < 7; i++) i: 0};

    for (final meal in meals) {
      final dayOfWeek = meal.analyzedAt.weekday - 1;
      if (dayOfWeek >= 0 && dayOfWeek < 7) {
        dailyCalories[dayOfWeek] = (dailyCalories[dayOfWeek] ?? 0) + meal.nutrition.calories;
      }
    }

    return dailyCalories.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }


  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  void _showDeleteDialog(Meal meal, MealProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.deleteMeal(meal.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}
