import 'package:job/features/chat/data/models/chat_model.dart';
import 'package:job/features/chat/data/repositories/chat_repository_impl.dart';

class MockChatRepository implements ChatRepository {
  final List<ChatModel> chats;
  MockChatRepository(this.chats);
  @override
  List<ChatModel> getAllChats() => chats;
  @override
  Future<void> addChat(ChatModel chat) async {}
  @override
  Future<void> deleteChat(String id) async {}
  @override
  ChatModel? getChat(String id) {
    try {
      return chats.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
