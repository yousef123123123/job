import 'package:hive/hive.dart';
import '../models/message_model.dart';

class MessageLocalDataSource {
  final Box<MessageModel> messageBox;

  MessageLocalDataSource(this.messageBox);

  List<MessageModel> getMessagesByChat(String chatId) =>
      messageBox.values.where((msg) => msg.chatId == chatId).toList();

  Future<void> addMessage(MessageModel message) async =>
      await messageBox.put(message.id, message);

  Future<void> deleteMessage(String id) async => await messageBox.delete(id);

  MessageModel? getMessage(String id) => messageBox.get(id);
}
