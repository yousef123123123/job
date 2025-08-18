import 'package:hive/hive.dart';
import '../models/chat_model.dart';

class ChatLocalDataSource {
  final Box<ChatModel> chatBox;

  ChatLocalDataSource(this.chatBox);

  List<ChatModel> getAllChats() => chatBox.values.toList();

  Future<void> addChat(ChatModel chat) async =>
      await chatBox.put(chat.id, chat);

  Future<void> deleteChat(String id) async => await chatBox.delete(id);

  ChatModel? getChat(String id) => chatBox.get(id);
}
