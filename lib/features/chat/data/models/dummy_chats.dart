import 'chat_model.dart';
import 'message_model.dart';

final dummyChats = [
  ChatModel(
    id: 'chat1',
    userId: 'user1',
    unreadCount: 2,
    messages: [
      MessageModel(
        id: 'msg1',
        chatId: 'chat1',
        senderId: 'user1',
        text: 'Hello! 👋',
        mediaPath: null,
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isSeen: true,
        isMine: false,
      ),
      MessageModel(
        id: 'msg2',
        chatId: 'chat1',
        senderId: 'me',
        text: 'Hi, how are you?',
        mediaPath: null,
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
        isSeen: true,
        isMine: true,
      ),
    ],
  ),
  ChatModel(
    id: 'chat2',
    userId: 'user2',
    unreadCount: 0,
    messages: [
      MessageModel(
        id: 'msg3',
        chatId: 'chat2',
        senderId: 'user2',
        text: 'Check this image!',
        mediaPath: 'path/to/image.png',
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isSeen: true,
        isMine: false,
      ),
    ],
  ),
];
