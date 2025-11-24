// lib/gemini_service.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'models.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env['API_KEY']!,
        );

  Future<CareerGuidance?> getCareerGuidance(UserProfile profile) async {
    final prompt = _buildPrompt(profile);
    final content = [Content.text(prompt)];
    
    final response = await _model.generateContent(content);
    final text = response.text;

    if (text == null) {
      return null;
    }

    // Clean the response and decode it
    final cleanedJsonString = text.replaceAll('```json', '').replaceAll('```', '').trim();
    final decodedJson = jsonDecode(cleanedJsonString) as Map<String, dynamic>;

    return CareerGuidance.fromJson(decodedJson);
  }

  String _buildPrompt(UserProfile profile) {
    // This is the "brain" of your app.
    // The JSON structure here must match the models.dart file.
    return """
      You are "Career Compass," an expert career counselor AI. 
      Analyze the user profile:
      - Academic Stream: ${profile.stream}
      - Subjects: ${profile.subjects}
      - Hobbies & Passions: ${profile.hobbies}

      Provide guidance in a strict JSON format. Do not include any text outside the JSON object.
      The JSON object must have this structure:
      {
        "suggested_careers": [
          {
            "career_title": "string",
            "description": "string (Why this fits the user)"
          }
        ],
        "recommended_skills": [
          {
            "skill_name": "string",
            "reasoning": "string (Why this skill is important)"
          }
        ],
        "personalized_summary": "string (An encouraging summary)"
      }
    """;
  }
}