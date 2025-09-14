📖 Meal Analyzer & Planner – Setup & Usage Guide

This document provides detailed setup and usage instructions for the Meal Analyzer & Planner application.

🚀 Quick Setup

Clone Repository & Install Dependencies

git clone https://github.com/your-username/meal-analyzer-planner.git
cd meal-analyzer-planner
flutter pub get


Get API Key

Visit Google AI Studio

Generate a Gemini API Key

Create Environment File
In the root directory, create a .env file and add:

GEMINI_API_KEY=your_key_here


Run the Application

flutter run

📱 App Overview

This Flutter app provides three core functionalities:

1️⃣ Meal Analysis (Camera & AI)

Capture food photos using the device camera

AI-powered nutritional analysis using Gemini API

Displays:

Meal identification

Calorie count

Macronutrients & ingredients

Automatically saves to History

2️⃣ Meal Planning

Set dietary preferences & calorie targets

Generate personalized meal plans using AI

Customize based on dietary restrictions

View complete daily nutrition summaries

3️⃣ History & Analytics

Browse previously analyzed meals

Track nutritional trends over time

Barcode Scanning support for packaged foods

🎯 Core Features

✅ Dual Theme Support – Light/dark mode with system synchronization
✅ Camera Integration – Capture meals directly in-app
✅ AI-Powered Meal Planning – Personalized daily plans based on goals
✅ Data Persistence – Local storage of meal history & preferences
✅ Responsive UI – Works seamlessly across devices and screen sizes

🔧 Technical Architecture

State Management: Provider
 for efficient data flow

API Integration: Secure Gemini API communication

Local Storage: SQLite database for offline functionality

Camera Handling: Optimized image capture and processing

Theme System: Persistent dynamic light/dark theme

📊 Outputs Generated

Nutrition Reports: Detailed breakdown of each analyzed meal

Meal Plans: AI-generated daily eating schedules

Historical Data: Timeline of all analyzed foods with trends

💡 Usage Flow
graph LR
A[📷 Capture] --> B[🔎 Analyze]
B --> C[📅 Plan]
C --> D[📊 Track]

A -->|Take photo or scan barcode| B
B -->|View AI-generated data| C
C -->|Generate meal plan| D
D -->|Monitor progress| A


Step-by-Step:

Capture → Take a meal photo or scan a barcode

Analyze → AI processes and returns nutritional data

Plan → Generate personalized daily meal plans

Track → Monitor progress with history and analytics
