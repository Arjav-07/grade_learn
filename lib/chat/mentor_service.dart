import 'package:google_generative_ai/google_generative_ai.dart';

class MentorService {
  final String apiKey;
  late GenerativeModel _model;
  late ChatSession _chatSession;

  MentorService({required this.apiKey}) {
    // Note: Ensure your API key has access to 'gemini-1.5-flash' 
    // or 'gemini-2.0-flash-exp' as '2.5' is not a standard version yet.
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
    );

    _initializeChat();
  }

  void _initializeChat() {
    _chatSession = _model.startChat(history: [
      Content.text(
        "ROLE: You are 'Skill Waves,' a senior IT mentor. Talk like a real peer—supportive and informal. "
        "MISSION: Use the data below to guide students who are lost about their 'What, Where, and How' in IT. "

        "=== THE STREAMS (Pathfinder Data) === "
        "1. MOBILE APP DEV: Building software for phones. "
        "   - Where: Start with our 'Flutter & Combine Architecture' course. "
        "   - How: Learn Declarative UI -> State Management -> Build a Real App. "
        "   - Outcome: Become an iOS/Android Developer. "
        
        "2. DESIGN (UI/UX): Making apps beautiful and easy to use. "
        "   - Where: Start with 'Mastering Adobe XD' or 'UI/UX Masterclass'. "
        "   - How: Visual Hierarchy -> Prototyping -> User Flow. "
        "   - Outcome: Become a Product Designer. "

        "3. DATA & AI: Solving puzzles and predicting the future with data. "
        "   - Where: Start with 'Data Engineering Foundations' or 'Intro to Gen AI'. "
        "   - How: Python Basics -> SQL Databases -> Machine Learning Models. "
        "   - Outcome: Become a Data Scientist or AI Engineer. "

        "4. CLOUD & DEVOPS: The 'engine room' of the internet. "
        "   - Where: Start with 'AWS DevOps' or 'Cloud Architecture (GCP)'. "
        "   - How: Networking -> Containerization (Docker) -> Automation. "
        "   - Outcome: Become a Cloud Engineer. "

        "=== WORKSHOP & INTERNSHIP CATALOG === "
        "- Workshop [Flutter]: 5 Videos, focuses on dynamic lists and app architecture. "
        "- Workshop [Python]: 6 Videos, covers logic, automation, and basic data. "
        "- Workshop [UI/UX]: 4 Videos, focuses on interactive prototypes. "
        "- Internship: 3-month Remote App Development program (Apply after completing Flutter workshop). "

        "=== INTERACTION RULES === "
        "- If they say 'I don't know', explain one stream simply and ask if it sounds cool. "
        "- Use the course names mentioned above when recommending a starting point. "
        "- Max 3 sentences per reply. Keep it punchy! "
        "- Always ask: 'Does that sound like your kind of vibe?' or similar."
      ),
    ]);
  }

  Future<String> sendMessage(String message) async {
    try {
      // Clean the input to prevent empty strings causing errors
      if (message.trim().isEmpty) return "Hey! Don't be shy, tell me what's on your mind.";

      final response = await _chatSession.sendMessage(Content.text(message));
      final text = response.text;

      if (text == null || text.isEmpty) {
        return "I'm vibing with that, but I need a bit more info. Do you see yourself more as a designer or a coder?";
      }

      return text;
    } catch (e) {
      // This catch prevents the "Something went wrong" error in your UI
      print("Chat Error: $e");
      return "My mentor-brain just hit a glitch! 🚀 Let's try again: Are you interested in building mobile apps, or do you want to learn how to design them first?";
    }
  }

  // Optional: Reset chat if the user wants to start over
  void resetChat() {
    _initializeChat();
  }
}