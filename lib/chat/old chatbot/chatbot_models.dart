// lib/chat/chatbot_models.dart

class UserProfile {
  String stream = '';
  String subjects = '';
  String hobbies = '';

  @override
  String toString() {
    return 'Stream: $stream, Subjects: $subjects, Hobbies: $hobbies';
  }
}

class Career {
  final String careerTitle;
  final String description;

  Career({required this.careerTitle, required this.description});
}

class Skill {
  final String skillName;
  final String reasoning;

  Skill({required this.skillName, required this.reasoning});
}

class CareerGuidance {
  final String personalizedSummary;
  final List<Career> suggestedCareers;
  final List<Skill> recommendedSkills;

  CareerGuidance({
    required this.personalizedSummary,
    required this.suggestedCareers,
    required this.recommendedSkills,
  });
}