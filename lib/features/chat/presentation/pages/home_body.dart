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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.dummyChats.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد محادثات',
          style: TextStyle(color: isDark ? Colors.white : Color(0xFF111B21)),
        ),
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
                Icon(
                  Icons.mic,
                  color: isDark ? Colors.grey[400] : Color(0xFF8696A0),
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  loc.voiceMessage,
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Color(0xFF667781),
                    fontSize: 13,
                  ),
                ),
                Spacer(),
                Text(
                  lastMsgTime,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Color(0xFF8696A0),
                    fontSize: 12,
                  ),
                ),
              ],
            );
          } else if (lastMsg.mediaPath != null &&
              lastMsg.mediaPath!.isNotEmpty) {
            lastMsgWidget = Row(
              children: [
                Icon(
                  Icons.image,
                  color: isDark ? Colors.grey[400] : Color(0xFF8696A0),
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  loc.imageMessage,
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Color(0xFF667781),
                    fontSize: 13,
                  ),
                ),
                Spacer(),
                Text(
                  lastMsgTime,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Color(0xFF8696A0),
                    fontSize: 12,
                  ),
                ),
              ],
            );
          } else {
            lastMsgWidget = Row(
              children: [
                Expanded(
                  child: Text(
                    lastMsg.text,
                    style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF667781),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  lastMsgTime,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Color(0xFF8696A0),
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }
        }
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 80,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  user.name + (user.id == 'me' ? ' (You)' : ''),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: user.avatarPath.startsWith('http')
                                    ? Image.network(
                                        user.avatarPath,
                                        fit: BoxFit.cover,
                                        height: 260,
                                        width: double.infinity,
                                      )
                                    : Image.file(
                                        File(user.avatarPath),
                                        fit: BoxFit.cover,
                                        height: 260,
                                        width: double.infinity,
                                      ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.chat,
                                        color: Color(0xFF25D366),
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // Open chat
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ChatPage(
                                              messages: chatMessages,
                                              chatId: chatModel.id,
                                              user: user,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: Color(0xFF25D366),
                                        size: 28,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 0),
                child: CircleAvatar(
                  backgroundImage: user.avatarPath.startsWith('http')
                      ? NetworkImage(user.avatarPath)
                      : FileImage(File(user.avatarPath)) as ImageProvider,
                  radius: 26,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 0, right: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF111B21),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${chatModel.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      color: chatModel.unreadCount == 0
                          ? (isDark ? Colors.white : Color(0xFF25D366))
                          : Color(0xFF25D366),
                      size: 18,
                    ),
                    SizedBox(width: 8),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
