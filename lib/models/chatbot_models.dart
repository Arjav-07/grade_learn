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
      suggestedCareers: (json['suggested_careers'] as List)
          .map((career) => SuggestedCareer.fromJson(career))
          .toList(),
      recommendedSkills: (json['recommended_skills'] as List)
          .map((skill) => RecommendedSkill.fromJson(skill))
          .toList(),
      personalizedSummary: json['personalized_summary'],
    );
  }
}

class SuggestedCareer {
  final String careerTitle;
  final String description;

  SuggestedCareer({required this.careerTitle, required this.description});

  factory SuggestedCareer.fromJson(Map<String, dynamic> json) {
    return SuggestedCareer(
      careerTitle: json['career_title'],
      description: json['description'],
    );
  }
}

class RecommendedSkill {
  final String skillName;
  final String reasoning;

  RecommendedSkill({required this.skillName, required this.reasoning});

  factory RecommendedSkill.fromJson(Map<String, dynamic> json) {
    return RecommendedSkill(
      skillName: json['skill_name'],
      reasoning: json['reasoning'],
    );
  }
}