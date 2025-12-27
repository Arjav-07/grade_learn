import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// --- 1. THE MENTOR SERVICE (FIXED FOR GEMINI 2.5 FLASH) ---
class MentorService {
  final String apiKey;
  late GenerativeModel _model;
  late ChatSession _chatSession;

  MentorService({required this.apiKey}) {
    // FIX: Using the currently active 'gemini-2.5-flash' model
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "You are 'GradeLearn Guru,' a senior student mentor. Talk like a real human peer—informal and supportive. "
        "Task: Guide students to upgrade skills via Workshops, Courses, and Internships. "
        "Rule 1: Never repeat the same advice twice. "
        "Rule 2: Ask ONE specific follow-up question about their goals per message."
      ),
    );
    _chatSession = _model.startChat();
  }

  Future<String> sendMessage(String text) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(text));
      return response.text ?? "Thinking... tell me more about your goals!";
    } catch (e) {
      return "Something went wrong on my end. Try asking again? 🚀";
    }
  }
}

// --- 2. THE CHAT SCREEN (NEO-BRUTALIST UI) ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  
  // Replace with your actual Gemini API Key
  final MentorService _mentor = MentorService(apiKey: 'AIzaSyBdXohHY9g2FoLvnSOJb8e-VABCFg-YikU');

  void _scrollToBottom() {
    // Auto-scroll logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() async {
    if (_controller.text.trim().isEmpty) return;
    
    final userText = _controller.text.trim();
    setState(() {
      _messages.add({"role": "user", "text": userText});
      _controller.clear();
    });
    _scrollToBottom();

    final response = await _mentor.sendMessage(userText);
    setState(() {
      _messages.add({"role": "bot", "text": response});
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _buildChatBubble(_messages[i]),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("MENTOR CHAT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
      backgroundColor:  const Color(0xFFFFFFF9),
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    );
  }

  // ✅ NEO-BRUTALIST BUBBLE DESIGN
  Widget _buildChatBubble(Map<String, String> msg) {
    bool isUser = msg["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFB5C0FF) : const Color(0xFFFDE798),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
          // ✅ DISTINCT HARD OFFSET SHADOW
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)
          ],
        ),
        child: Text(
          msg["text"]!,
          style: const TextStyle(
            fontFamily: 'Brutal', // Custom font applied here,
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  // ✅ FLOATING BRUTALIST INPUT
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFF9),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "ASK MENTOR...",
                        hintStyle: TextStyle( color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.black, size: 30),
                    onPressed: _handleSend,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "AI RESPONSES MAY NOT ALWAYS BE ACCURATE. VERIFY IMPORTANT INFORMATION.🚀",
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}