import 'package:flutter/material.dart';
import 'package:grade_learn/chat/chat_screen.dart';
import 'package:grade_learn/widgets/main_navigation_screen.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistPurple = Color(0xFF7A64D8);

class ChatWelcome extends StatelessWidget {
  const ChatWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --- BACK BUTTON ---
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainNavigationScreen())),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Expanded area for scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER ---
                      const Text(
                        "WELCOME TO",
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            "CHATBOT",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("🤖", style: TextStyle(fontSize: 32)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // --- 1. MAIN HERO CARD ---
                      _buildHeroCard(),

                      const SizedBox(height: 30),

                      // --- SECTION TITLE ---
                      const Text(
                        "GUIDELINES & FEATURES",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- 2. FEATURE TILES ---
                      _buildFeatureTile(
                        icon: Icons.smart_toy_outlined,
                        title: "AI-POWERED LEARNING ASSISTANCE",
                        desc: "GET INSTANT HELP WITH PROGRAMMING CONCEPTS, COURSE RECOMMENDATIONS, AND CAREER GUIDANCE.",
                      ),
                      _buildFeatureTile(
                        icon: Icons.security,
                        title: "RESPECTFUL INTERACTIONS",
                        desc: "PLEASE KEEP CONVERSATIONS PROFESSIONAL AND EDUCATIONAL. INAPPROPRIATE CONTENT WILL BE FLAGGED.",
                      ),
                      _buildFeatureTile(
                        icon: Icons.access_time_filled,
                        title: "24/7 AVAILABILITY",
                        desc: "ASK QUESTIONS ANYTIME! THE CHATBOT IS AVAILABLE ROUND THE CLOCK TO SUPPORT YOUR LEARNING JOURNEY.",
                      ),
                      _buildFeatureTile(
                        icon: Icons.error_outline,
                        title: "ACCURACY & LIMITATIONS",
                        desc: "WHILE OUR AI IS TRAINED ON EXTENSIVE DATA, ALWAYS VERIFY CRITICAL INFORMATION FROM OFFICIAL SOURCES.",
                      ),
                      
                      const SizedBox(height: 30),

                      // --- 3. SCROLLABLE START BUTTON ---
                      _buildStartButton(context),

                      // --- BOTTOM PADDING ---
                      const SizedBox(height: 80), 
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HERO CARD ----------------
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: kBrutalistBlue,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: const Text("🤖", style: TextStyle(fontSize: 50)),
          ),
          const SizedBox(height: 20),
          const Text(
            "CODE LEARN AI ASSISTANCE",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const Text(
            "YOUR PERSONAL GUIDANCE COMPANION",
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.bold, 
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          // Tag Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: kBrutalistYellow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "AI CHAT BOT", 
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------- FEATURE TILE ----------------
  Widget _buildFeatureTile({required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13, 
                    color: Colors.black54, 
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- START BUTTON ----------------
  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: kBrutalistPurple,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "START CHATTING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}