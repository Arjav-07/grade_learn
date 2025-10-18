import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class SkillUpApp extends StatefulWidget {
  const SkillUpApp({Key? key}) : super(key: key);

  @override
  _SkillUpAppState createState() => _SkillUpAppState();
}

class _SkillUpAppState extends State<SkillUpApp> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  Map<String, String?> userDetails = {
    'study': null,
    'level': null,
    'interests': null,
    'goals': null,
    'skills': null,
  };

  String currentQuestion = 'welcome';
  bool initialQuestionsComplete = false;
  List<Map<String, dynamic>> chatHistory = [];


  static const Map<String, Map<String, String>> conversationFlow = {
    'welcome': {
      'question':
          "Hi there! I'm your personal AI mentor, SkillUp Bot. I'm here to help you build a roadmap from learning new skills all the way to landing a job. To get started, could you tell me your current field of study? (e.g., Computer Science, Business, Arts)",
      'next': 'study'
    },
    'study': {
      'question':
          "Great, thanks for sharing! Now, what's your current educational level? (e.g., High School, Undergraduate, Graduate)",
      'next': 'level'
    },
    'level': {
      'question':
          "Understood. What are some of your interests or hobbies? This helps me tailor the advice to be more engaging for you. (e.g., video games, painting, writing, technology)",
      'next': 'interests'
    },
    'interests': {
      'question':
          "That's interesting! Do you have any existing skills you'd like to build upon? (e.g., basic Python, graphic design, good at writing)",
      'next': 'skills'
    },
    'skills': {
      'question':
          "Good to know. And what are your long-term career goals? Don't worry if it's not perfectly clear yet. (e.g., become a software developer, start my own business, work in digital marketing)",
      'next': 'goals'
    },
    'goals': {
      'question':
          "Thank you for sharing all of that. I'm generating a personalized 'Phase 1' roadmap for you now to build your foundation. This might take a moment...",
      'next': 'recommendation'
    }
  };

  @override
  void initState() {
    super.initState();
    _askQuestion('welcome');
  }
  
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
       if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(String text, {bool isUser = false}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
      if(!isUser) {
        // Add bot messages to history for context
        chatHistory.add({"role": "model", "parts": [{"text": text}]});
      }
    });
    _scrollToBottom();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    
    // Add user message to UI and history
    _addMessage(text, isUser: true);
    chatHistory.add({"role": "user", "parts": [{"text": text}]});

    _processUserResponse(text);
  }

  Future<void> _getAIResponse({String? initialPrompt}) async {
    setState(() {
      _isTyping = true;
    });

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      _addMessage("API Key not found. Please check your .env file.");
      setState(() => _isTyping = false);
      return;
    }
    final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$apiKey';
    
    const systemPrompt = """
You are SkillUp Bot, an expert AI career mentor with a warm, friendly, and very personable approach. Your goal is to make the student feel like they are talking to a real, knowledgeable, and caring person.

**Personality & Tone:**
- Greet the user warmly when appropriate (e.g., "Hi there!", "Hello!").
- Use conversational gestures. If the user thanks you, respond with "You're very welcome!" or "My pleasure!". When you ask for information, say "thanks for sharing".
- Be consistently encouraging and positive. Use phrases like "That's a great goal!" or "It's perfectly okay to be unsure about that."
- Your tone should be that of a helpful guide, not a robot. Use "I" and "you" frequently.

**Guidance Structure:**
Your guidance is broken down into three main phases. Only provide one phase at a time and wait for the user to indicate they are ready for the next.

**Phase 1: Building Your Foundation**
When you first get the user's details, provide a personalized 'Phase 1' plan.
- Ask clarifying questions if their interests are vague. For example, if they say "technology," ask "What about technology excites you? Is it coding, design, or something else?"
- Suggest specific foundational skills.
- Recommend a mix of free resources (specific YouTube channels, websites) and maybe one highly-rated affordable course (like on Udemy or Coursera).
- Propose a simple, fun beginner project that aligns with their interests.
- End this phase by saying something encouraging and asking them to check back in. For example: "This is a great starting point. Take your time with these, and don't hesitate to ask questions along the way. When you feel you've got a good handle on the basics, let me know you're ready, and we can start talking about internships!"

**Phase 2: Gearing Up for Internships**
When the user says they're ready for the next step:
- Provide the 'Phase 2' plan.
- Give detailed advice on building a portfolio that stands out.
- Offer actionable tips for their resume, maybe even suggesting a template.
- Explain networking simply. "Think of it as making professional friends. Here's how to start on LinkedIn..."
- Suggest specific platforms to find internships in their field.
- Include a section on preparing for common interview questions.
- End by saying: "Building your portfolio and resume takes effort, but it's worth it. Once you feel confident with what you've prepared, let me know, and we'll tackle the final step: getting you job-ready."

**Phase 3: Becoming Job-Ready**
When the user is ready for the final phase:
- Provide the 'Phase 3' plan.
- Discuss advanced skills or specializations they could pursue.
- Offer tips on building a professional online presence beyond just LinkedIn (e.g., GitHub, Behance, personal blog).
- Give a gentle introduction to salary research and negotiation.
- Provide strategies for tailoring their job applications.
- End with an encouraging closing statement like, "You've come a long way! The job hunt is a marathon, not a sprint. I'm here to help if you have more questions. Good luck!"

**General Interaction Rules:**
- If a user asks a direct question at any point, answer it directly before continuing with the guidance plan. Don't be rigid.
- Use a conversational tone. Use "you" and "I". Be encouraging.
- Tailor all advice to the user's specific details from the conversation.
""";

    // Use the last few messages for context to keep the payload small
    final contextualHistory = chatHistory.length > 10 ? chatHistory.sublist(chatHistory.length - 10) : chatHistory;

    final payload = {
        'contents': contextualHistory,
        'systemInstruction': { 'parts': [{'text': systemPrompt}] },
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final botResponse = result['candidates'][0]['content']['parts'][0]['text'];
        _addMessage(botResponse);
      } else {
        _addMessage("Sorry, I'm having trouble connecting to my AI brain right now. Please try again later.");
      }
    } catch (e) {
      _addMessage("Sorry, something went wrong. Please check your internet connection.");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }


  void _processUserResponse(String response) {
    // Restart logic is always available
    if (response.toLowerCase().trim() == 'restart') {
      setState(() {
        _messages.clear();
        chatHistory.clear();
        userDetails = {'study': null, 'level': null, 'interests': null, 'goals': null, 'skills': null};
        currentQuestion = 'welcome';
        initialQuestionsComplete = false;
      });
      _askQuestion('welcome');
      return;
    }

    if (initialQuestionsComplete) {
      // If initial questions are done, every input is a direct query to the AI
      _getAIResponse();
      return;
    }

    // Initial data gathering flow
    switch (currentQuestion) {
      case 'study':
        userDetails['study'] = response;
        _askQuestion('level');
        break;
      case 'level':
        userDetails['level'] = response;
        _askQuestion('interests');
        break;
      case 'interests':
        userDetails['interests'] = response;
        _askQuestion('skills');
        break;
       case 'skills':
        userDetails['skills'] = response;
        _askQuestion('goals');
        break;
      case 'goals':
        userDetails['goals'] = response;
        _askQuestion('recommendation');
        break;
    }
  }

  void _askQuestion(String stage) {
    _addMessage(conversationFlow[stage]!['question']!);
    final nextStage = conversationFlow[stage]!['next']!;

    if (nextStage == 'recommendation') {
      // Create the initial prompt and call the AI
      final initialPrompt = "My details are: Study: ${userDetails['study']}, Level: ${userDetails['level']}, Interests: ${userDetails['interests']}, Existing Skills: ${userDetails['skills']}, Goal: ${userDetails['goals']}. Please start by providing my 'Phase 1' roadmap.";
      // Add this initial prompt to history so the AI knows the user's details
      chatHistory.add({"role": "user", "parts": [{"text": initialPrompt}]});
      _getAIResponse();
      setState(() {
        initialQuestionsComplete = true; // Switch to continuous chat mode
      });
    } else {
       setState(() {
        currentQuestion = nextStage;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillUp AI Bot'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                 if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
            ),
            child: const Text("SkillUp is thinking...", style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.indigo[500] : Colors.white,
                borderRadius: isUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                boxShadow: [
                  if(!isUser)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2)
                    )
                ]
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  hintText: 'Type your message or "restart"...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

