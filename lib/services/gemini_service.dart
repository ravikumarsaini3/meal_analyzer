import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Analyze a meal image using Gemini 2.0 Flash Vision
  Future<Map<String, dynamic>> analyzeMealImage(File imageFile) async {
    if (_apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in .env file');
    }

    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(
            '$_baseUrl/models/gemini-2.0-flash:generateContent'), // ✅ New endpoint
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': '''
Analyze this food image and respond ONLY with valid JSON in the following format.
IMPORTANT: Return only numbers (no units, no text, just numbers) for all nutrition values.

{
  "name": "meal name",
  "description": "brief description",
  "ingredients": ["ingredient1", "ingredient2"],
  "nutrition": {
    "calories": 0,
    "protein": 0,
    "carbs": 0,
    "fat": 0,
    "fiber": 0,
    "sugar": 0,
    "sodium": 0
  }
}
'''

                },
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = _safeJsonDecode(response.body);

        if (data['candidates'] == null || data['candidates'].isEmpty) {
          throw Exception('No candidates returned from Gemini API');
        }

        final content = data['candidates'][0]['content']['parts'][0]['text'];

        try {
          return _safeJsonDecode(content);
        } catch (_) {
          throw Exception('Gemini did not return valid JSON. Response: $content');
        }
      } else {
        throw Exception(
            'Failed to analyze image. Status: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing meal: $e');
    }
  }


  Future<Map<String, dynamic>> generateMealPlan({
    required int targetCalories,
    required List<String> dietaryRestrictions,
    required List<String> preferredMeals,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in .env file');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-2.0-flash:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': '''Generate a daily meal plan with the following requirements:
- Target calories: $targetCalories
- Dietary restrictions: ${dietaryRestrictions.join(', ')}
- Preferred meals: ${preferredMeals.join(', ')}

Return ONLY valid JSON in this exact format (no extra text):
{
  "breakfast": {"name": "", "calories": 0, "ingredients": []},
  "lunch": {"name": "", "calories": 0, "ingredients": []},
  "dinner": {"name": "", "calories": 0, "ingredients": []},
  "snacks": [{"name": "", "calories": 0, "ingredients": []}],
  "totalCalories": 0,
  "totalProtein": 0,
  "totalCarbs": 0,
  "totalFat": 0
}'''
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to generate meal plan. Status: ${response.statusCode}. Body: ${response.body}',
        );
      }

      final data = _safeJsonDecode(response.body);

      if (data['candidates'] == null || data['candidates'].isEmpty) {
        throw Exception('No candidates returned from Gemini API');
      }

      final content = data['candidates'][0]['content']['parts'][0]['text'];
      print('🔍 Gemini raw response: $content');

      // ✅ Safely extract JSON from content
      final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (match == null) {
        throw Exception('Gemini did not return valid JSON. Response: $content');
      }

      final jsonString = match.group(0)!;
      print('✅ Extracted JSON: $jsonString');

      try {
        return jsonDecode(jsonString);
      } catch (e) {
        throw Exception('Gemini JSON parse failed: $e. Raw: $jsonString');
      }
    } catch (e) {
      throw Exception('Error generating meal plan: $e');
    }
  }

}
Map<String, dynamic> _safeJsonDecode(String text) {
  try {
    // Try decoding directly first
    return jsonDecode(text);
  } catch (_) {
    // Extract first JSON block using RegExp
    final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
    if (match != null) {
      final jsonString = match.group(0);
      try {
        return jsonDecode(jsonString!);
      } catch (e) {
        throw Exception('Gemini response could not be parsed: $jsonString');
      }
    }
    throw Exception('Gemini did not return valid JSON. Raw response: $text');
  }
}
