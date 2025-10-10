import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import your existing GeminiApiService

class JarvisCareerAssistant extends StatefulWidget {
  const JarvisCareerAssistant({super.key});

  @override
  State<JarvisCareerAssistant> createState() => _JarvisCareerAssistantState();
}

class _JarvisCareerAssistantState extends State<JarvisCareerAssistant> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _userProfile = '';
  final List<ChatMessage> _conversationHistory = [];
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadUserProfile();
    _initAssistant();
  }
  
  // Initialize speech recognition
  Future<void> _initSpeech() async {
    await _speech.initialize();
  }
  
  // Load saved user profile data
  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userProfile = prefs.getString('user_profile') ?? '';
    });
  }
  
  // Initialize the assistant with a welcome message
  void _initAssistant() {
    if (_userProfile.isEmpty) {
      _speak("Hello! I'm your career guidance assistant. Let's start by creating your profile. What's your current field of study?");
    } else {
      _speak("Welcome back! Would you like to continue our discussion about career opportunities in your field?");
    }
  }
  
  // Start listening for voice input
  void _startListening() {
    if (!_isListening) {
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _processVoiceInput(result.recognizedWords);
          }
        },
      );
      setState(() {
        _isListening = true;
      });
    }
  }
  
  // Process the recognized speech
  Future<void> _processVoiceInput(String text) async {
    setState(() {
      _isListening = false;
      _conversationHistory.add(ChatMessage(text: text, role: ChatRole.user));
    });
    
    // Get AI response using your existing GeminiApiService
    final response = await GeminiApiService.getGeminiResponse(_conversationHistory);
    
    setState(() {
      _conversationHistory.add(ChatMessage(text: response, role: ChatRole.model));
    });
    
    _speak(response);
  }
  
  // Convert text to speech
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis Career Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Show profile management screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat history display
          Expanded(
            child: ListView.builder(
              itemCount: _conversationHistory.length,
              itemBuilder: (context, index) {
                // Return chat bubbles similar to your existing _buildMessage method
              },
            ),
          ),
          // Voice assistant status indicator
          Container(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isListening ? 80 : 60,
              height: _isListening ? 80 : 60,
              decoration: BoxDecoration(
                color: _isListening 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
                onPressed: _startListening,
              ),
            ),
          ),
        ],
      ),
    );
  }
}