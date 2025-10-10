enum ChatAuthor {
  user,
  bot,
}

class ChatMessage {
  final String text;
  final ChatAuthor author;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.author,
    required this.timestamp,
  });
}