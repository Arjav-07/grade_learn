// lib/gemini_chat_service.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatService {
  final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiChatService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env['API_KEY']!,
        ) {
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String text) async {
    try {
      final content = Content.text(text);
      final response = await _chat.sendMessage(content);
      return response.text ?? 'Sorry, I could not process that.';
    } catch (e) {
      print("Error sending message: $e");
      return "Something went wrong. Please try again.";
    }
  }
}