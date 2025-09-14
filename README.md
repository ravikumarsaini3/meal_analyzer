Meal Analyzer & Planner


An AI-powered Flutter application that analyzes meal photos, generates personalized meal plans, and tracks nutritional analytics using Google Gemini AI.

</div>
📱 Features
🍽️ Meal Photo Analysis: AI-powered food recognition and nutritional breakdown

📋 Personalized Meal Planning: Generate daily meal plans based on dietary goals

📊 Nutrition Tracking: History and analytics with visual charts

📷 Camera Integration: Direct photo capture for meal analysis

🔍 Barcode Scanning: QR/barcode support for packaged foods

🌙 Dark/Light Theme: Automatic theme switching with system synchronization

💾 Offline Storage: Local data persistence for analyzed meals and plans

🚀 Getting Started
Prerequisites
Flutter SDK (3.19.0 or higher)

Dart (3.3.0 or higher)

Android device/emulator (API 21+)

Google Gemini API key

Installation
Clone the repository

bash
git clone https://github.com/your-username/meal-analyzer-planner.git
cd meal-analyzer-planner
Install dependencies

bash
flutter pub get
Set up API key

Get your Google Gemini API key from Google AI Studio

Create a .env file in the root directory:

env
GEMINI_API_KEY=your_actual_api_key_here
Run the application

bash
flutter run
📸 Screenshots
Analysis Screen	Meal Planner	History & Analytics
https://screenshots/analysis.jpg	https://screenshots/planner.jpg	https://screenshots/history.jpg
🏗️ Project Structure
text
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
├── providers/                # State management
│   ├── meal_provider.dart
│   ├── meal_plan_provider.dart
│   └── theme_provider.dart
├── services/                 # External services
│   ├── gemini_service.dart
│   ├── database_service.dart
│   └── camera_service.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── analysis_screen.dart
│   ├── planner_screen.dart
│   └── history_screen.dart
├── widgets/                  # Reusable components
└── utils/                    # Helper utilities
🛠️ Technologies Used
Flutter: Cross-platform framework

Dart: Programming language

Google Gemini AI: Meal analysis and planning

Provider: State management

SQLite: Local database storage

Camera: Image capture functionality

HTTP: API communications

🔧 Configuration
Android Permissions
Ensure your android/app/src/main/AndroidManifest.xml includes:

xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
Environment Variables
Create a .env file with your API key:

env
GEMINI_API_KEY=your_gemini_api_key_here
📖 Usage Guide
Analyzing a Meal
Open the app and navigate to the "Analyze" tab

Tap the camera button to capture a meal photo

View the AI-generated nutritional analysis

Save the analysis to your history

Generating a Meal Plan
Go to the "Plan" tab

Set your dietary preferences and goals

Tap "Generate Meal Plan"

Review your personalized daily plan

Viewing History
Navigate to the "History" tab

Browse analyzed meals and generated plans

View nutritional trends and analytics

Scanning Barcodes
From the Analysis screen, tap the barcode icon

Scan a product barcode using your camera

View nutritional information for packaged foods

🎨 Theming
The app supports both light and dark themes with automatic system synchronization. Users can manually toggle themes via the settings icon.

📊 API Integration
The app uses Google Gemini AI for:

Meal image analysis and nutritional breakdown

Personalized meal plan generation

Food recognition and ingredient detection

🤝 Contributing
Fork the project

Create your feature branch (git checkout -b feature/AmazingFeature)

Commit your changes (git commit -m 'Add some AmazingFeature')

Push to the branch (git push origin feature/AmazingFeature)

Open a Pull Request

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

🆘 Support
If you encounter any issues or have questions:

Check the FAQ

Search existing issues

Create a new issue with detailed information

🙏 Acknowledgments
Google Gemini AI for nutritional analysis capabilities

Flutter team for the excellent framework

Open Food Facts for barcode database

<div align="center">
Made with ❤️ using Flutter

</div>
