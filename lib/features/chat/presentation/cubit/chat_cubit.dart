import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/default_messages_model.dart';
import 'package:hive/hive.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  final Box<MessageModel> messagesBox;
  final DefaultMessagesModel defaultMessages;

  ChatCubit({
    required this.dummyChats,
    required this.users,
    required this.messagesBox,
    required this.defaultMessages,
  }) : super(ChatInitial()) {
    loadChats();
  }

  void loadChats() {
    for (var chat in dummyChats) {
      final chatMessages = messagesBox.values
          .where((msg) => msg.chatId == chat.id)
          .toList();
      if (chatMessages.isEmpty) {
        final randomMsg = (defaultMessages.messages..shuffle()).first;
        messagesBox.add(
          MessageModel(
            id: 'msg${DateTime.now().millisecondsSinceEpoch}',
            chatId: chat.id,
            senderId: chat.userId,
            text: randomMsg,
            mediaPath: null,
            voicePath: null,
            timestamp: DateTime.now(),
            isSeen: false,
            isMine: false,
          ),
        );
      }
    }
    emit(ChatLoaded(List.from(dummyChats)));
  }

  void reorderChat(dynamic chatModel) {
    final idx = dummyChats.indexOf(chatModel);
    if (idx > 0) {
      final moved = dummyChats.removeAt(idx);
      dummyChats.insert(0, moved);
      emit(ChatLoaded(List.from(dummyChats)));
    }
  }

  void resetUnread(dynamic chatModel) {
    chatModel.unreadCount = 0;
    emit(ChatLoaded(List.from(dummyChats)));
  }
}
