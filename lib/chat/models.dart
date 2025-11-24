// lib/models.dart
import 'dart:convert'; // Import for JSON encoding/decoding

// Holds the data we collect from the user
class UserProfile {
  String stream;
  String subjects;
  String hobbies;

  UserProfile({
    this.stream = '',
    this.subjects = '',
    this.hobbies = '',
  });
  
  // --- Enhanced: For Debugging ---
  @override
  String toString() {
    return 'Stream: $stream, Subjects: $subjects, Hobbies: $hobbies';
  }
  
  // --- Enhanced: For API/Storage ---
  Map<String, dynamic> toJson() {
    return {
      'stream': stream,
      'subjects': subjects,
      'hobbies': hobbies,
    };
  }
}

// The main structure for the AI's response
class CareerGuidance {
  final List<SuggestedCareer> suggestedCareers;
  final List<RecommendedSkill> recommendedSkills;
  final String personalizedSummary;

  CareerGuidance({
    required this.suggestedCareers,
    required this.recommendedSkills,
    required this.personalizedSummary,
  });

  factory CareerGuidance.fromJson(Map<String, dynamic> json) {
    return CareerGuidance(
      // Ensure key names match the AI's output exactly (using lowercase snake_case here)
      suggestedCareers: (json['suggested_careers'] as List)
          .map((career) => SuggestedCareer.fromJson(career as Map<String, dynamic>))
          .toList(),
      recommendedSkills: (json['recommended_skills'] as List)
          .map((skill) => RecommendedSkill.fromJson(skill as Map<String, dynamic>))
          .toList(),
      personalizedSummary: json['personalized_summary'] as String,
    );
  }
  
  // --- Enhanced: For Debugging ---
  @override
  String toString() {
    return jsonEncode(toJson());
  }
  
  // --- Enhanced: For Debugging/Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'personalized_summary': personalizedSummary,
      'suggested_careers': suggestedCareers.map((c) => c.toJson()).toList(),
      'recommended_skills': recommendedSkills.map((s) => s.toJson()).toList(),
    };
  }
}

class SuggestedCareer {
  final String careerTitle;
  final String description;

  SuggestedCareer({required this.careerTitle, required this.description});

  factory SuggestedCareer.fromJson(Map<String, dynamic> json) {
    return SuggestedCareer(
      careerTitle: json['career_title'] as String,
      description: json['description'] as String,
    );
  }
  
  // --- Enhanced: For Debugging/Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'career_title': careerTitle,
      'description': description,
    };
  }
}

class RecommendedSkill {
  final String skillName;
  final String reasoning;

  RecommendedSkill({required this.skillName, required this.reasoning});

  factory RecommendedSkill.fromJson(Map<String, dynamic> json) {
    return RecommendedSkill(
      skillName: json['skill_name'] as String,
      reasoning: json['reasoning'] as String,
    );
  }
  
  // --- Enhanced: For Debugging/Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'skill_name': skillName,
      'reasoning': reasoning,
    };
  }
}