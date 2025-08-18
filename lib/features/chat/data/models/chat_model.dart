import 'package:hive/hive.dart';
import 'message_model.dart';
part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<MessageModel> messages;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  int unreadCount;

  ChatModel({
    required this.id,
    required this.messages,
    required this.userId,
    required this.unreadCount,
  });
}
