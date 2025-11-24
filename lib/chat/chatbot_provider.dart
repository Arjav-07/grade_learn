// lib/chat/chatbot_provider.dart

import 'package:flutter/material.dart';
import 'package:grade_learn/chat/chatbot_models.dart'; // Import the models

class ChatbotProvider extends ChangeNotifier {
  // --- State Variables ---
  UserProfile _userProfile = UserProfile();
  bool _isLoading = false;
  CareerGuidance? _guidance;

  // --- Getters ---
  UserProfile get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  CareerGuidance? get guidance => _guidance;

  // --- Logic ---

  Future<void> getCareerGuidance() async {
    // 1. Start loading state
    _isLoading = true;
    _guidance = null;
    notifyListeners();

    // 2. Simulate an API call to the AI service
    print('Sending profile to AI: ${_userProfile.toString()}');
    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay

    // --- 3. GENERATE DYNAMIC GUIDANCE BASED ON INPUTS ---
    
    final stream = _userProfile.stream.toLowerCase().trim();
    final hobbies = _userProfile.hobbies.trim();
    
    List<Career> suggestedCareers = [];
    List<Skill> recommendedSkills = [];
    String summary = '';

    if (stream.contains('science') || stream.contains('math') || stream.contains('engineering')) {
      // --- Science/Math/Engineering ---
      summary = 'Your **Technical Science** background (Subjects: ${_userProfile.subjects}) combined with your interest in **$hobbies** points toward high-growth, analytical careers.';
      
      suggestedCareers = [
        Career(
          careerTitle: 'Aerospace/Data Engineer',
          description: 'Leverages mathematical thinking for systems design or complex data analysis. Highly suitable if you enjoy Maths/Coding and problem-solving.',
        ),
        Career(
          careerTitle: 'Product Manager (Tech)',
          description: 'Translates technical capabilities into market-driven products. Excellent combination of technical knowledge and strategic thinking.',
        ),
      ];
      
      recommendedSkills = [
        Skill(skillName: 'Python and SQL', reasoning: 'The foundation for data analysis and full-stack development in engineering fields.'),
        Skill(skillName: 'Design Thinking', reasoning: 'Crucial for innovating and designing user-centric solutions, especially linking $hobbies to technology.'),
      ];
      
    } else if (stream.contains('bio') || stream.contains('medical')) {
      // --- Biology/Medical ---
      summary = 'Your focus on **Life Sciences** and **Healthcare** is complemented by your hobbies in **$hobbies**. This aligns well with careers focused on research and human well-being.';
      
      suggestedCareers = [
        Career(
          careerTitle: 'Biotechnologist/Pharmacist',
          description: 'Working in research and development to create new drugs or agricultural technologies, utilizing chemistry and biology.',
        ),
        Career(
          careerTitle: 'Public Health Consultant',
          description: 'Designs community programs to improve health outcomes. Great if your $hobbies involve helping people or advocacy.',
        ),
      ];
      
      recommendedSkills = [
        Skill(skillName: 'Statistical Analysis (R/SPSS)', reasoning: 'Essential for interpreting lab results, clinical trials, and epidemiological data.'),
        Skill(skillName: 'Interpersonal Communication', reasoning: 'Crucial for patient education, team collaboration, and public health outreach.'),
      ];
      
    } else if (stream.contains('commerce') || stream.contains('business')) {
      // --- Commerce/Business ---
      summary = 'Your **Commerce/Business** specialization combined with **$hobbies** prepares you for roles requiring financial acumen and market strategy.';
      
      suggestedCareers = [
        Career(
          careerTitle: 'Investment Banker / Portfolio Manager',
          description: 'Advises companies on mergers and acquisitions or manages client wealth. The finance path for those who enjoy high-stakes strategy.',
        ),
        Career(
          careerTitle: 'Digital Marketing Analyst',
          description: 'Analyzes consumer data and trends to drive sales. Perfect if your $hobbies involve social media or photography/visuals.',
        ),
      ];
      
      recommendedSkills = [
        Skill(skillName: 'Advanced Excel & Financial Modeling', reasoning: 'Core skill for accurate financial forecasting and valuation.'),
        Skill(skillName: 'Risk Management', reasoning: 'Key for making sound investment and business decisions in a volatile market.'),
      ];
      
    } else if (stream.contains('arts') || stream.contains('humanities')) {
      // --- Arts/Humanities ---
      summary = 'Your strong foundation in **Arts/Humanities** and your passion for **$hobbies** makes you an ideal candidate for creative, communication, and social-science driven professions.';
      
      suggestedCareers = [
        Career(
          careerTitle: 'Content Strategist / Copywriter',
          description: 'Uses narrative skills to define a brand\'s voice and marketing direction. Directly applicable if $hobbies involves writing, blogging, or journalism.',
        ),
        Career(
          careerTitle: 'Civil Services / Policy Analyst',
          description: 'Works in public administration, law, or policy-making. Requires strong critical thinking, history, and analytical skills.',
        ),
      ];
      
      recommendedSkills = [
        Skill(skillName: 'Public Speaking & Debate', reasoning: 'Crucial for roles in law, teaching, political science, and corporate communication.'),
        Skill(skillName: 'Media Production/Editing', reasoning: 'If $hobbies is visual (e.g., photography), this skill is vital for modern creative careers.'),
      ];
      
    } else {
      // Default/Catch-all logic
      summary = 'We need a clearer stream, but based on your interest in **$hobbies**, we recommend exploring interdisciplinary fields that value flexibility and passion.';
      
      suggestedCareers = [
        Career(
          careerTitle: 'Entrepreneur / Startup Founder',
          description: 'Building a new venture based on your unique combination of skills and passion for $hobbies.',
        ),
      ];
      
      recommendedSkills = [
        Skill(skillName: 'Project Management', reasoning: 'The foundational skill needed to organize and execute any complex goal, personal or professional.'),
      ];
    }
    
    // Final assignment of the generated guidance
    _guidance = CareerGuidance(
      personalizedSummary: summary,
      suggestedCareers: suggestedCareers,
      recommendedSkills: recommendedSkills,
    );

    // 4. End loading state
    _isLoading = false;
    notifyListeners();
  }

  void resetProfile() {
    _userProfile = UserProfile();
    _guidance = null;
    notifyListeners();
  }
}