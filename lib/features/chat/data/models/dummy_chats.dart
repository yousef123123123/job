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
        text: 'يلا الساحل',
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
        text: 'صباحووووو ',
        mediaPath: null,
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
        isSeen: true,
        isMine: false,
      ),
      MessageModel(
        id: 'msg4',
        chatId: 'chat1',
        senderId: 'user1',
        text: 'ازيك انجم',
        mediaPath: null,
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(minutes: 2)),
        isSeen: true,
        isMine: false,
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
        text: 'يلا ناخد position',
        mediaPath: null,
        voicePath: null,
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isSeen: true,
        isMine: false,
      ),
    ],
  ),
];
