import '../../data/repositories/chat_repository_impl.dart';
import '../entities/chat.dart';

class GetChats {
  final ChatRepository repository;

  GetChats(this.repository);

  List<Chat> call() {
    return repository
        .getAllChats()
        .map(
          (chatModel) => Chat(
            id: chatModel.id,
            userId: chatModel.userId,
            unreadCount: chatModel.unreadCount,
          ),
        )
        .toList();
  }
}
