import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'package:hive/hive.dart';
import '../../data/models/message_model.dart';
import '../../data/models/default_messages_model.dart';
import 'chat_page.dart';
import 'package:job/core/localization/app_localizations.dart';
import 'dart:io';

class HomeBody extends StatefulWidget {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  const HomeBody({required this.dummyChats, required this.users, Key? key})
    : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late DefaultMessagesModel defaultMessages;
  late Box<MessageModel> messagesBox;

  @override
  void initState() {
    super.initState();
    messagesBox = Hive.box<MessageModel>('messages');
    defaultMessages = DefaultMessagesModel.getDefault();
    for (var chat in widget.dummyChats) {
      final chatMessages = messagesBox.values
          .where((msg) => msg.chatId == chat.id)
          .toList();
      if (chatMessages.isEmpty) {
        final randomMsg = (defaultMessages.messages..shuffle()).first;
        messagesBox.add(
          MessageModel(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            chatId: chat.id,
            text: randomMsg,
            mediaPath: '',
            voicePath: '',
            senderId: chat.userId,
            isSeen: false,
            isMine: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dummyChats.isEmpty) {
      return Center(
        child: Text('لا يوجد محادثات', style: TextStyle(color: Colors.white)),
      );
    }
    return ListView.builder(
      itemCount: widget.dummyChats.length,
      itemBuilder: (context, index) {
        final chatModel = widget.dummyChats[index];
        final user = widget.users.firstWhere((u) => u.id == chatModel.userId);
        final chatMessages = messagesBox.values
            .where((msg) => msg.chatId == chatModel.id)
            .toList();
        final lastMsg = chatMessages.isNotEmpty ? chatMessages.last : null;
        final loc = AppLocalizations.of(context)!;
        Widget lastMsgWidget = SizedBox();
        String lastMsgTime = '';
        if (lastMsg != null) {
          final hour = lastMsg.timestamp.hour.toString().padLeft(2, '0');
          final min = lastMsg.timestamp.minute.toString().padLeft(2, '0');
          lastMsgTime = '$hour:$min';
          if (lastMsg.voicePath != null && lastMsg.voicePath!.isNotEmpty) {
            lastMsgWidget = Row(
              children: [
                Icon(Icons.mic, color: Colors.grey[400], size: 18),
                SizedBox(width: 4),
                Text(
                  loc.voiceMessage,
                  style: TextStyle(color: Colors.grey[300], fontSize: 13),
                ),
                Spacer(),
                Text(
                  lastMsgTime,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            );
          } else if (lastMsg.mediaPath != null &&
              lastMsg.mediaPath!.isNotEmpty) {
            lastMsgWidget = Row(
              children: [
                Icon(Icons.image, color: Colors.grey[400], size: 20),
                SizedBox(width: 4),
                Text(
                  loc.imageMessage,
                  style: TextStyle(color: Colors.grey[300], fontSize: 13),
                ),
                Spacer(),
                Text(
                  lastMsgTime,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            );
          } else {
            lastMsgWidget = Row(
              children: [
                Expanded(
                  child: Text(
                    lastMsg.text,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  lastMsgTime,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            );
          }
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.avatarPath.startsWith('http')
                ? NetworkImage(user.avatarPath)
                : FileImage(File(user.avatarPath)) as ImageProvider,
            radius: 26,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (chatModel.unreadCount > 0)
                    Container(
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF25D366),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${chatModel.unreadCount}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  // if (lastMsgTime.isNotEmpty)
                  //   Text(
                  //     lastMsgTime,
                  //     style: TextStyle(
                  //       color: Colors.grey[400],
                  //       fontSize: 12,
                  //       fontWeight: chatModel.unreadCount > 0
                  //           ? FontWeight.bold
                  //           : FontWeight.normal,
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.done_all,
                color: chatModel.unreadCount == 0
                    ? Colors.white
                    : Color(0xFF25D366),
                size: 18,
              ),
              SizedBox(width: 4),
              Expanded(child: lastMsgWidget),
            ],
          ),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatPage(
                  messages: chatMessages,
                  chatId: chatModel.id,
                  user: user,
                ),
              ),
            );
            setState(() {
              // Reset unread count after opening chat
              chatModel.unreadCount = 0;
              final idx = widget.dummyChats.indexOf(chatModel);
              if (idx > 0) {
                final moved = widget.dummyChats.removeAt(idx);
                widget.dummyChats.insert(0, moved);
              }
            });
          },
        );
      },
    );
  }
}
