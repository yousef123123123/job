class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String? mediaPath;
  final String? voicePath;
  final DateTime timestamp;
  final bool isSeen;
  final bool isMine;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.mediaPath,
    this.voicePath,
    required this.timestamp,
    required this.isSeen,
    required this.isMine,
  });
}
