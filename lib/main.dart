import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meal_analyzer_app/providers/meals_plan_providers.dart';
import 'package:meal_analyzer_app/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/meal_provider.dart';

import 'services/camera_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize camera
  await CameraService.initializeCameras();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      child: MaterialApp(
        title: 'AI Meal Analyzer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        home:dotenv.env['GEMINI_API_KEY'] != null
            ? HomeScreen()
            : ApiKeySetupScreen(),
      ),
    );
  }
}

class ApiKeySetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.key,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 24),
              Text(
                'API Key Required',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              Text(
                'Please configure your Google Gemini API key to use this app.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Open settings or documentation
                },
                child: Text('Setup Instructions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}