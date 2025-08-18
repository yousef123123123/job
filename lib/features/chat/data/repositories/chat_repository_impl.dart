import '../models/chat_model.dart';
import '../sources/chat_local_data_source.dart';

abstract class ChatRepository {
  List<ChatModel> getAllChats();
  Future<void> addChat(ChatModel chat);
  Future<void> deleteChat(String id);
  ChatModel? getChat(String id);
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl(this.localDataSource);

  @override
  List<ChatModel> getAllChats() => localDataSource.getAllChats();

  @override
  Future<void> addChat(ChatModel chat) async =>
      await localDataSource.addChat(chat);

  @override
  Future<void> deleteChat(String id) async =>
      await localDataSource.deleteChat(id);

  @override
  ChatModel? getChat(String id) => localDataSource.getChat(id);
}
