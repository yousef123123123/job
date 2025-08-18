import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
// ...existing code...
import 'chat_page.dart';

class HomeBody extends StatelessWidget {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  const HomeBody({required this.dummyChats, required this.users, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dummyChats.isEmpty
        ? Center(
            child: Text(
              'لا يوجد محادثات',
              style: TextStyle(color: Colors.white),
            ),
          )
        : ListView.builder(
            itemCount: dummyChats.length,
            itemBuilder: (context, index) {
              final chatModel = dummyChats[index];
              final user = users.firstWhere((u) => u.id == chatModel.userId);
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white12)),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarPath),
                    radius: 26,
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      if (chatModel.unreadCount > 0)
                        Container(
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.done_all,
                        color: chatModel.unreadCount == 0
                            ? Colors.white
                            : Color(0xFF25D366),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      if (chatModel.messages.isNotEmpty)
                        chatModel.messages.last.voicePath != null &&
                                chatModel.messages.last.voicePath!.isNotEmpty
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.mic,
                                    color: Color(0xFF25D366),
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Voice message',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                chatModel.messages.last.text.isNotEmpty
                                    ? chatModel.messages.last.text
                                    : 'آخر رسالة...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              )
                      else
                        Text(
                          'آخر رسالة...',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                    ],
                  ),
                  trailing: user.isOnline
                      ? Icon(Icons.circle, color: Color(0xFF25D366), size: 14)
                      : null,
                  onTap: () {
                    if (chatModel.unreadCount > 0) {
                      chatModel.unreadCount = 0;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          messages: chatModel.messages,
                          chatId: chatModel.id,
                          user: user,
                          onSend: (msg) {
                            chatModel.messages.add(msg);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
