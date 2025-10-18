import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Note: To run this code, you need to add the http and flutter_dotenv packages to your pubspec.yaml file:
// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^1.2.1
//   flutter_dotenv: ^5.1.0

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const SkillUpApp());
}

class SkillUpApp extends StatelessWidget {
  const SkillUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillUp Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  Map<String, String?> userDetails = {
    'study': null,
    'level': null,
    'interests': null,
    'goals': null,
  };

  String currentQuestion = 'welcome';
  List<Map<String, dynamic>> chatHistory = [];


  static const Map<String, Map<String, String>> conversationFlow = {
    'welcome': {
      'question':
          "Hello! I'm your AI-powered SkillUp Bot. I can create a detailed roadmap for you from learning foundational skills to landing a job. To start, what's your current field of study? (e.g., Computer Science, Business, Arts)",
      'next': 'study'
    },
    'study': {
      'question':
          "Great! Now, what's your current educational level? (e.g., High School, Undergraduate, Graduate)",
      'next': 'level'
    },
    'level': {
      'question':
          "Understood. What are some of your interests or hobbies? (e.g., video games, painting, writing, technology)",
      'next': 'interests'
    },
    'interests': {
      'question':
          "Interesting! And what are your long-term career goals? (e.g., become a software developer, start my own business, work in digital marketing)",
      'next': 'goals'
    },
    'goals': {
      'question':
          "Thank you for sharing. I'm generating a personalized AI roadmap for you now. This might take a moment...",
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

    final apiKey = dotenv.env['GEMINI_API_KEY']; // Change this line
    if (apiKey == null) {
      _addMessage("API Key not found. Please check your .env file.");
      setState(() => _isTyping = false);
      return;
    }
    final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=$apiKey'; // Change this line
    
    const systemPrompt = "You are SkillUp Bot, an expert AI career counselor for students. Your goal is to provide a detailed, actionable, and encouraging roadmap. The roadmap should be structured into three phases: 'Phase 1: Building Your Foundation', 'Phase 2: Gearing Up for Internships', and 'Phase 3: Becoming Job-Ready'. For each phase, provide specific skills to learn, projects to build, and actions to take. Tailor the advice based on the user's details. When a user wants to change streams, acknowledge it and provide a fresh, complete roadmap for the new stream. Format your response using markdown-style asterisks for bullet points and bolding for phase titles.";

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
        userDetails = {'study': null, 'level': null, 'interests': null, 'goals': null};
        currentQuestion = 'welcome';
      });
      _askQuestion('welcome');
      return;
    }

    if (currentQuestion == 'chatting') {
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
      final initialPrompt = "My field of study is ${userDetails['study']}. I am at the ${userDetails['level']} level. My interests are ${userDetails['interests']}, and my long-term goal is to ${userDetails['goals']}. Please provide a detailed roadmap for me.";
      // Add this initial prompt to history so the AI knows the user's details
      chatHistory.add({"role": "user", "parts": [{"text": initialPrompt}]});
      _getAIResponse();
      setState(() {
        currentQuestion = 'chatting'; // Switch to continuous chat mode
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

