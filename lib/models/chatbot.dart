import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- THEME CONSTANTS ---
const Color kScaffoldBackground = Color(0xFFF8F9FA);
const Color kPrimaryTextColor = Color(0xFF343A40);
const Color kSecondaryTextColor = Color(0xFF6C757D);
const Color kAccentColor = Colors.black;
const Color kBotBubbleColor = Color(0xFFE9ECEF);
const Color kUserBubbleColor = Color(0xFF343A40);
const Color kInputFieldColor = Colors.white;

// ✨ ENHANCED MODEL with message types
enum MessageType { text, typing, error }

class ChatMessage {
  final String text;
  final bool isUser;
  final MessageType type;
  // ✨ NEW: Add suggestions for interactive UX
  final List<String> suggestions;

  ChatMessage({
    required this.text,
    this.isUser = false,
    this.type = MessageType.text,
    this.suggestions = const [],
  });
}

// ✨ NEW: Dedicated service for all chat logic and API calls
class ChatService {
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-preview-0514:generateContent';
  
  // This could be moved to a separate UserData model
  Map<String, String?> userDetails = {
    'study': null, 'level': null, 'interests': null, 'goals': null, 'skills': null,
  };

  String currentQuestionKey = 'welcome';
  bool initialQuestionsComplete = false;
  List<Map<String, dynamic>> chatHistory = [];

  static const Map<String, Map<String, String>> conversationFlow = {
    'welcome': {'question': "Hi there! I'm your personal AI mentor. I'm here to help you build a roadmap from learning new skills all the way to landing a job. To get started, could you tell me your current field of study? (e.g., Computer Science, Business, Arts)", 'next': 'study'},
    'study': {'question': "Great, thanks for sharing! Now, what's your current educational level? (e.g., High School, Undergraduate, Graduate)", 'next': 'level'},
    'level': {'question': "Understood. What are some of your interests or hobbies? (e.g., video games, painting, technology)", 'next': 'interests'},
    'interests': {'question': "That's interesting! Do you have any existing skills you'd like to build upon? (e.g., basic Python, graphic design, writing)", 'next': 'skills'},
    'skills': {'question': "Good to know. And what are your long-term career goals? (e.g., become a developer, start a business)", 'next': 'goals'},
    'goals': {'question': "Thanks for sharing! I'm generating your personalized 'Phase 1' roadmap now. This might take a moment...", 'next': 'recommendation'}
  };

  void restart() {
    userDetails.updateAll((key, value) => null);
    currentQuestionKey = 'welcome';
    initialQuestionsComplete = false;
    chatHistory.clear();
  }

  // Handles the structured initial questions
  ChatMessage processInitialResponse(String response) {
    userDetails[currentQuestionKey] = response;
    final nextKey = conversationFlow[currentQuestionKey]!['next']!;
    currentQuestionKey = nextKey;
    final nextQuestion = conversationFlow[currentQuestionKey]!['question']!;
    return ChatMessage(text: nextQuestion);
  }

  // Generates the final prompt after collecting user details
  String get recommendationPrompt {
    initialQuestionsComplete = true;
    final prompt = "My details are: Study: ${userDetails['study']}, Level: ${userDetails['level']}, Interests: ${userDetails['interests']}, Skills: ${userDetails['skills']}, Goal: ${userDetails['goals']}. Please generate my 'Phase 1' learning roadmap. Structure your response clearly with phases or steps. At the end, provide three short, actionable follow-up questions as suggestions for our conversation, enclosed in brackets like [suggestion1][suggestion2][suggestion3].";
    chatHistory.add({"role": "user", "parts": [{"text": prompt}]});
    return prompt;
  }

  // The main API call logic
  Future<ChatMessage> getAIResponse(String userMessage) async {
    if (_apiKey == null) {
      return ChatMessage(text: "API Key not found. Please check your .env file.", type: MessageType.error);
    }
    
    chatHistory.add({"role": "user", "parts": [{"text": userMessage}]});

    const systemPrompt = "You are SkillUp, an AI mentor that helps users learn new skills and plan their careers. You are friendly, clear, and encouraging. When asked, you provide three short, actionable follow-up questions as suggestions for the user, enclosed in brackets at the very end of your response, like [suggestion1][suggestion2][suggestion3].";
    final contextualHistory = chatHistory.length > 10 ? chatHistory.sublist(chatHistory.length - 10) : chatHistory;
    final payload = {'contents': contextualHistory, 'systemInstruction': {'parts': [{'text': systemPrompt}]}};

    try {
      final response = await http.post(Uri.parse('$_apiUrl?key=$_apiKey'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(payload));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        String botResponseText = result['candidates'][0]['content']['parts'][0]['text'];
        chatHistory.add({"role": "model", "parts": [{"text": botResponseText}]});

        // ✨ NEW: Parse suggestions from the response
        final RegExp suggestionRegex = RegExp(r"\[(.*?)\]");
        final matches = suggestionRegex.allMatches(botResponseText);
        final suggestions = matches.map((m) => m.group(1)!).toList();
        
        // Remove the suggestion tags from the visible text
        botResponseText = botResponseText.replaceAll(suggestionRegex, "").trim();

        return ChatMessage(text: botResponseText, suggestions: suggestions);
      } else {
        return ChatMessage(text: "Hmm, I couldn’t reach my AI brain right now. Try again later!", type: MessageType.error);
      }
    } catch (e) {
      return ChatMessage(text: "Oops! Something went wrong. Please check your internet connection.", type: MessageType.error);
    }
  }
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
  bool _conversationStarted = false;

  // ✨ REFACTORED: Instantiate the service
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
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

  void _addMessage(ChatMessage message) {
    setState(() {
      // Remove typing indicator before adding new message
      _messages.removeWhere((msg) => msg.type == MessageType.typing);
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    final userMessage = text;
    _textController.clear();

    if (!_conversationStarted) {
      setState(() => _conversationStarted = true);
       _addMessage(ChatMessage(text: userMessage, isUser: true));
      // Start the conversation flow
      final botMessage = ChatMessage(text: ChatService.conversationFlow['welcome']!['question']!);
      _addMessage(botMessage);
      return;
    }
    
    _addMessage(ChatMessage(text: userMessage, isUser: true));
    
    // Handle restart command
    if (userMessage.toLowerCase().trim() == 'restart') {
      _chatService.restart();
      setState(() {
        _messages.clear();
        _conversationStarted = false;
      });
      return;
    }

    // Show typing indicator
    setState(() {
      _messages.add(ChatMessage(text: "SkillUp is thinking...", type: MessageType.typing));
    });
    _scrollToBottom();

    // Process response using the service
    _processUserResponse(userMessage);
  }

  Future<void> _processUserResponse(String response) async {
    if (!_chatService.initialQuestionsComplete) {
      final botMessage = _chatService.processInitialResponse(response);
      _addMessage(botMessage);
      
      // Check if we need to trigger the recommendation
      if (_chatService.currentQuestionKey == 'recommendation') {
        final recommendationPrompt = _chatService.recommendationPrompt;
        final aiResponse = await _chatService.getAIResponse(recommendationPrompt);
        _addMessage(aiResponse);
      }
    } else {
      // It's a general follow-up question
      final aiResponse = await _chatService.getAIResponse(response);
      _addMessage(aiResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        backgroundColor: kScaffoldBackground, elevation: 0, centerTitle: true,
        title: const Text('SkillUp AI', style: TextStyle(color: kPrimaryTextColor, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: !_conversationStarted
                ? const InitialView() // ✨ REFACTORED to its own widget
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      // ✨ REFACTORED: Cleaner message handling
                      if (message.type == MessageType.typing) {
                        return const TypingIndicator();
                      }
                      return ChatMessageBubble(message: message, onSuggestionTapped: _handleSubmitted);
                    },
                  ),
          ),
          TextInputBar(
            textController: _textController,
            onSubmitted: _handleSubmitted,
          ), // ✨ REFACTORED to its own widget
        ],
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


// --- ✨ NEW WIDGETS FOR BETTER ORGANIZATION ---

class InitialView extends StatelessWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is your previous _buildInitialView, now cleanly separated.
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.auto_awesome, size: 48, color: kSecondaryTextColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Capabilities', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryTextColor)),
          const SizedBox(height: 32),
          _buildCapabilityCard('Personalized Roadmaps', '(From learning to landing a job)'),
          const SizedBox(height: 16),
          _buildCapabilityCard('Answer Your Questions', '(Ask me anything about your career path)'),
          const SizedBox(height: 16),
          _buildCapabilityCard('Conversational AI', '(I can chat like a human!)'),
        ],
      ),
    );
  }

  Widget _buildCapabilityCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kBotBubbleColor)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: kPrimaryTextColor, fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: kSecondaryTextColor, fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}


class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onSuggestionTapped;
  
  const ChatMessageBubble({Key? key, required this.message, required this.onSuggestionTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.0);
    final isUser = message.isUser;
    
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: isUser ? kUserBubbleColor : kBotBubbleColor,
                    borderRadius: isUser
                        ? borderRadius.copyWith(bottomRight: const Radius.circular(5))
                        : borderRadius.copyWith(bottomLeft: const Radius.circular(5)),
                  ),
                  child: Text(message.text, style: TextStyle(color: isUser ? Colors.white : kPrimaryTextColor, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
        // ✨ NEW: Display suggestion chips
        if (message.suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: message.suggestions.map((suggestion) => ActionChip(
                label: Text(suggestion),
                onPressed: () => onSuggestionTapped(suggestion),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: kBotBubbleColor)
                ),
              )).toList(),
            ),
          )
      ],
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: kBotBubbleColor,
          borderRadius: BorderRadius.circular(20.0).copyWith(bottomLeft: const Radius.circular(5)),
        ),
        child: const Text("SkillUp is thinking...", style: TextStyle(color: kSecondaryTextColor, fontStyle: FontStyle.italic)),
      ),
    );
  }
}

class TextInputBar extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onSubmitted;

  const TextInputBar({Key? key, required this.textController, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: kInputFieldColor,
        border: Border(top: BorderSide(color: kBotBubbleColor, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  hintText: 'Ask me anything...',
                  hintStyle: const TextStyle(color: kSecondaryTextColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: kBotBubbleColor)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: kBotBubbleColor)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: const BorderSide(color: kAccentColor)),
                  filled: true,
                  fillColor: kInputFieldColor,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            InkWell(
              onTap: () => onSubmitted(textController.text),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: kAccentColor, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}