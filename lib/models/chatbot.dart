import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Used for Platform detection, though not implemented in this version

// --- CONSTANTS AND API CONFIGURATION ---

// IMPORTANT: Your Gemini API Key is loaded from an environment variable.
// You must run the app with the following command:
// flutter run --dart-define=API_KEY=YOUR_API_KEY_HERE
const String apiKey = String.fromEnvironment('API_KEY',
    defaultValue: 'YOUR_API_KEY_IS_NOT_SET');

// --- DATA MODELS ---

enum ChatRole { user, model }

class ChatMessage {
  final String text;
  final ChatRole role;

  ChatMessage({required this.text, required this.role});
}

// --- API SERVICE ---

/// A dedicated service to handle all interactions with the Gemini API.
class GeminiApiService {
  // The specific model URL for generating content
  static const String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=';

  // System instruction guides the AI's behavior and specialization
  static const String _systemInstruction =
      "You are a professional, motivating, and highly informed Career Guidance Counselor specializing in future-proof careers for students (2025+). Your purpose is to assess the student's current interests, field of study, and skills, and provide specific, actionable advice on career paths (e.g., Data Science, Cybersecurity, AI, Renewable Energy, Advanced Healthcare) and the necessary technical and soft skills (e.g., Python, Cloud Computing, Emotional Intelligence, Critical Thinking, Digital Literacy) they must acquire or enhance to succeed in that field. Keep your responses concise, use Markdown formatting (like **bold** and bullet points) for readability, and always conclude with an encouraging question to guide the next step of the conversation. Begin by asking the student about their current major or area of interest.";

  /// Calls the Gemini API with the current chat history and returns the AI's response.
  static Future<String> getGeminiResponse(List<ChatMessage> messages) async {
    if (apiKey == 'YOUR_API_KEY_IS_NOT_SET') {
      return "Error: API Key is not set. Please run the app with '--dart-define=API_KEY=YOUR_KEY'.";
    }

    final url = Uri.parse('$_geminiApiUrl$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final payload = _buildRequestPayload(messages);

    // Exponential backoff parameters
    const int maxRetries = 3;
    final Duration initialDelay = const Duration(seconds: 2);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          // Wait before retrying with exponential backoff
          await Future.delayed(initialDelay * (1 << (attempt - 1)));
        }

        final response = await http.post(
          url,
          headers: headers,
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          final candidate = result['candidates']?[0];
          if (candidate != null &&
              candidate['content']?['parts']?[0]?['text'] != null) {
            return candidate['content']['parts'][0]['text']; // Success
          }
          return "Sorry, the AI returned an empty response. Please try again.";
        } else {
          // Log and process non-200 status codes
          debugPrint(
              'API Error (Attempt ${attempt + 1}): Status ${response.statusCode}, Body: ${response.body}');
          if (response.statusCode == 400) {
             return "Sorry, there was a problem with the request to the AI. Your API key might be invalid or improperly formatted.";
          }
        }
      } on SocketException {
        // Handle network errors (e.g., no internet)
        return "Network connection failed. Please check your internet and try again.";
      } catch (e) {
        debugPrint('General Error (Attempt ${attempt + 1}): $e');
      }
    }

    return "Sorry, I couldn't get a response from the AI after several attempts. Please try again later.";
  }

  /// Builds the JSON payload for the Gemini API request.
  static Map<String, dynamic> _buildRequestPayload(List<ChatMessage> messages) {
    // Converts the chat history into the format required by the Gemini API.
    final List<Map<String, dynamic>> contents = messages.map((msg) {
      return {
        'role': msg.role == ChatRole.user ? 'user' : 'model',
        'parts': [{'text': msg.text}],
      };
    }).toList();

    return {
      'contents': contents,
      // Optional: Add Google Search grounding for real-time career advice
      'tools': [
        {'google_search': {}}
      ],
      'systemInstruction': {
        'parts': [
          {'text': _systemInstruction}
        ]
      },
      'generationConfig': {
        // Enforce strong response quality
        'temperature': 0.8,
        'topP': 0.95,
      }
    };
  }
}

// --- MAIN APPLICATION ---

void main() {
  runApp(const CareerAdvisorApp());
}

class CareerAdvisorApp extends StatelessWidget {
  const CareerAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Career Guide',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system, // Respect system light/dark mode
      home: const CareerAdvisorChat(),
    );
  }
}

// --- CHAT INTERFACE AND LOGIC ---

class CareerAdvisorChat extends StatefulWidget {
  const CareerAdvisorChat({super.key});

  @override
  State<CareerAdvisorChat> createState() => _CareerAdvisorChatState();
}

class _CareerAdvisorChatState extends State<CareerAdvisorChat> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Start with the initial prompt from the AI counselor
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your AI Career Guidance Counselor. I'm here to help you explore career paths and the skills you need to master. To start, what is your current field of study or primary area of interest?",
        role: ChatRole.model,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Handles the submission of a user message.
  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, role: ChatRole.user));
      _isLoading = true;
    });

    _scrollToBottom();

    // Get response from the Gemini API service
    final responseText = await GeminiApiService.getGeminiResponse(_messages);

    // Update state with AI Response
    setState(() {
      _messages.add(ChatMessage(text: responseText, role: ChatRole.model));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent, // For reversed list
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Career Coach',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // Show newest messages at the bottom
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Since the list is reversed, we display from the end of the _messages list
                final message = _messages[_messages.length - 1 - index];
                return _buildMessage(message);
              },
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(),
            ),
          // Input Field
          _buildTextComposer(),
        ],
      ),
    );
  }

  /// Builds a single chat bubble with appropriate styling.
  Widget _buildMessage(ChatMessage message) {
    final isUser = message.role == ChatRole.user;
    final color = isUser
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.secondaryContainer;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft:
                isUser ? const Radius.circular(20.0) : const Radius.circular(4.0),
            bottomRight:
                isUser ? const Radius.circular(4.0) : const Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SelectableText(
          message.text,
          style: textTheme.bodyLarge?.copyWith(
            color: isUser
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }

  /// Builds the text input bar at the bottom of the screen.
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _isLoading ? null : (_) => _sendMessage(),
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration.collapsed(
                hintText: 'Tell me about your interests...',
              ),
              readOnly: _isLoading,
              maxLines: null, // Allows multiline input
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_rounded,
                color: Theme.of(context).colorScheme.primary),
            onPressed: _isLoading ? null : _sendMessage,
            tooltip: 'Send Message',
          ),
        ],
      ),
    );
  }
}