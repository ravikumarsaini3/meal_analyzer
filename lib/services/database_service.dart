import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal_model.dart';
import '../models/meal_plan_model.dart';
import '../models/nutrition_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _mealsTable = 'meals';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meals.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_mealsTable(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            ingredients TEXT,
            nutrition TEXT,
            imagePath TEXT,
            analyzedAt TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveMeal(Meal meal) async {
    final db = await database;
    await db.insert(
      _mealsTable,
      {
        'id': meal.id,
        'name': meal.name,
        'description': meal.description,
        'ingredients': jsonEncode(meal.ingredients),
        'nutrition': jsonEncode(meal.nutrition),
        'imagePath': meal.imagePath,
        'analyzedAt': meal.analyzedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _mealsTable,
      orderBy: 'analyzedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Meal(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'] ?? '',
        ingredients: List<String>.from(jsonDecode(maps[i]['ingredients'])),
        nutrition: Nutrition.fromJson(jsonDecode(maps[i]['nutrition'])),
        imagePath: maps[i]['imagePath'],
        analyzedAt: DateTime.parse(maps[i]['analyzedAt']),
      );
    });
  }

  static Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete(
      _mealsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}





class MealPlanDatabaseService {
  static Database? _database;
  static const String _tableName = 'meal_plans';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meal_plans.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            planData TEXT,
            savedAt TEXT
          )
        ''');
      },
    );
  }

  static Future<int> savePlan(MealPlan plan) async {
    final db = await database;
    int id = await db.insert(
      _tableName,
      {
        'planData': jsonEncode(plan.toJson()),
        'savedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }


  // static Future<List<MealPlan>> getPlans() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     _tableName,
  //     orderBy: 'savedAt DESC',
  //   );
  //
  //   return List.generate(maps.length, (i) {
  //     return MealPlan.fromJson(jsonDecode(maps[i]['planData']));
  //   });
  // }

  static Future<List<MealPlan>> getPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'savedAt DESC',
    );

    return List.generate(maps.length, (i) {
      final plan = MealPlan.fromJson(jsonDecode(maps[i]['planData']));
      plan.dbId = maps[i]['id']; // assign DB id
      return plan;
    });
  }

  static Future<void> deletePlan(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
