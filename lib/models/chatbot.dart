// lib/models/chatbot.dart (Super Simplified UI – flat & minimal)

import 'package:flutter/material.dart';
import 'package:grade_learn/chat/chatbot_models.dart';
import 'package:grade_learn/chat/chatbot_provider.dart';
import 'package:provider/provider.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  static const double _radius = 26.0;
  static final Color _primaryColor = Color(0xFF7A64D8); 

  // Simple input field
  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
      onChanged: onChanged,
      style: const TextStyle(fontFamily: null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();
    final profile = provider.userProfile;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Career Guidance AI',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.circular(_radius),
              ),
              child: const Column(
                children: [
                  Icon(Icons.psychology_rounded, color: Colors.white, size: 40),
                  SizedBox(height: 12),
                  Text(
                    "Tell us about yourself",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Our AI will generate personalized guidance based on your interests.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Inputs
            _buildInputField(
              icon: Icons.school,
              label: "Academic Stream",
              hint: "Science, Arts, Commerce",
              onChanged: (v) => profile.stream = v,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              icon: Icons.book,
              label: "Main Subjects",
              hint: "Physics, Maths, History",
              onChanged: (v) => profile.subjects = v,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              icon: Icons.favorite,
              label: "Hobbies & Interests",
              hint: "Coding, Drawing, Gaming",
              onChanged: (v) => profile.hobbies = v,
            ),

            const SizedBox(height: 28),

            // Button
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => context.read<ChatbotProvider>().getCareerGuidance(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius),
                ),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Get My Guidance",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),

            const SizedBox(height: 30),

            // Results
            if (provider.isLoading)
              Column(
                children: [
                  CircularProgressIndicator(color: _primaryColor),
                  const SizedBox(height: 12),
                  Text(
                    "Generating guidance...",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              )
            else if (provider.guidance != null)
              ResultsWidget(guidance: provider.guidance!, primaryColor: _primaryColor),
          ],
        ),
      ),
    );
  }
}


/// ==========================
/// RESULTS WIDGET (Simplified)
/// ==========================

class ResultsWidget extends StatelessWidget {
  final CareerGuidance guidance;
  final Color primaryColor;
  const ResultsWidget({super.key, required this.guidance, required this.primaryColor});

  static const double _radius = 6.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Your Guidance",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Summary (flat)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            guidance.personalizedSummary,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ),

        const SizedBox(height: 28),

        // Career Paths
        Row(
          children: [
            Icon(Icons.rocket_launch, color: primaryColor),
            const SizedBox(width: 8),
            const Text(
              "Suggested Career Paths",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...guidance.suggestedCareers.map(
          (career) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(_radius),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.careerTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(career.description),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Skills
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange),
            const SizedBox(width: 8),
            const Text(
              "Skills to Develop",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...guidance.recommendedSkills.map(
          (skill) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(_radius),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.skillName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(skill.reasoning),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
