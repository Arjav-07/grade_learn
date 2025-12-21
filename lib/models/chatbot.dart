import 'package:flutter/material.dart';
import 'package:grade_learn/chat/chatbot_models.dart';
import 'package:grade_learn/chat/chatbot_provider.dart';
import 'package:provider/provider.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  // Brutalist input field
  Widget _buildBrutalistInput({
    required IconData icon,
    required String label,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: hint.toUpperCase(),
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
              prefixIcon: Icon(icon, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatbotProvider>();
    final profile = provider.userProfile;

    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // --- BACK BUTTON ---
            Row( 
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 28, color: Colors.black),
                        SizedBox(width: 8),
                        Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brutalist Hero Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kBrutalistPurple,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.black, width: 2.5),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.psychology_rounded, color: Colors.white, size: 50),
                          SizedBox(height: 16),
                          Text(
                            "CAREER AI",
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "TELL US ABOUT YOURSELF TO GENERATE PERSONALIZED GUIDANCE.",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildBrutalistInput(
                      icon: Icons.school,
                      label: "Academic Stream",
                      hint: "e.g., Science, Arts, Commerce",
                      onChanged: (v) => profile.stream = v,
                    ),
                    const SizedBox(height: 20),

                    _buildBrutalistInput(
                      icon: Icons.book,
                      label: "Main Subjects",
                      hint: "e.g., Physics, Maths, History",
                      onChanged: (v) => profile.subjects = v,
                    ),
                    const SizedBox(height: 20),

                    _buildBrutalistInput(
                      icon: Icons.favorite,
                      label: "Hobbies & Interests",
                      hint: "e.g., Coding, Drawing, Gaming",
                      onChanged: (v) => profile.hobbies = v,
                    ),

                    const SizedBox(height: 32),

                    // Brutalist Action Button
                    GestureDetector(
                      onTap: provider.isLoading
                          ? null
                          : () => context.read<ChatbotProvider>().getCareerGuidance(),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
                        ),
                        child: Center(
                          child: provider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "GET MY GUIDANCE",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Results Logic
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator(color: Colors.black))
                    else if (provider.guidance != null)
                      ResultsWidget(guidance: provider.guidance!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsWidget extends StatelessWidget {
  final CareerGuidance guidance;
  const ResultsWidget({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        const Text("YOUR GUIDANCE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kBrutalistYellow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: Text(
            guidance.personalizedSummary.toUpperCase(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, height: 1.4),
          ),
        ),

        const SizedBox(height: 32),

        const Text("SUGGESTED PATHS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 16),
        ...guidance.suggestedCareers.map((career) => _buildResultTile(career.careerTitle, career.description, kBrutalistBlue, Icons.rocket_launch)),

        const SizedBox(height: 32),

        const Text("SKILLS TO DEVELOP", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 16),
        ...guidance.recommendedSkills.map((skill) => _buildResultTile(skill.skillName, skill.reasoning, Colors.white, Icons.star)),
      ],
    );
  }

  Widget _buildResultTile(String title, String desc, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}