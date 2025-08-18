import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String chatId;
  @HiveField(2)
  final String senderId;
  @HiveField(3)
  final String text;
  @HiveField(4)
  final String? mediaPath;
  @HiveField(5)
  final String? voicePath;
  @HiveField(6)
  final DateTime timestamp;
  @HiveField(7)
  final bool isSeen;
  @HiveField(8)
  final bool isMine;

  MessageModel({
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
