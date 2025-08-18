import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../../home/presentation/pages/settings_page.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  final List<dynamic> dummyChats;
  final ValueChanged<Locale?> onLocaleChanged;
  final ValueChanged<ThemeMode?> onThemeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;
  HomePage({
    required this.dummyChats,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<UserModel> users = [
    UserModel(
      id: 'user1',
      name: 'Yousef',
      avatarPath: 'https://randomuser.me/api/portraits/men/1.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user2',
      name: 'Sara',
      avatarPath: 'https://randomuser.me/api/portraits/women/2.jpg',
      isOnline: false,
    ),
    UserModel(
      id: 'user3',
      name: 'Ali',
      avatarPath: 'https://randomuser.me/api/portraits/men/3.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user4',
      name: 'Mona',
      avatarPath: 'https://randomuser.me/api/portraits/women/4.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user5',
      name: 'Omar',
      avatarPath: 'https://randomuser.me/api/portraits/men/5.jpg',
      isOnline: false,
    ),
    UserModel(
      id: 'user6',
      name: 'Laila',
      avatarPath: 'https://randomuser.me/api/portraits/women/6.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user7',
      name: 'Hassan',
      avatarPath: 'https://randomuser.me/api/portraits/men/7.jpg',
      isOnline: false,
    ),
    UserModel(
      id: 'user8',
      name: 'Nour',
      avatarPath: 'https://randomuser.me/api/portraits/women/8.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user9',
      name: 'Khaled',
      avatarPath: 'https://randomuser.me/api/portraits/men/9.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user10',
      name: 'Rania',
      avatarPath: 'https://randomuser.me/api/portraits/women/10.jpg',
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111B21),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(
            'WhatsApp',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            PopupMenuButton<int>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              color: Color(0xFF222E35),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  enabled: false,
                  child: Text(
                    'New Group',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  enabled: false,
                  child: Text(
                    'New Broadcast',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  enabled: false,
                  child: Text(
                    'Linked Devices',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  enabled: true,
                  child: Text(
                    'Settings',
                    style: TextStyle(color: Color(0xFF25D366)),
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        onLocaleChanged: widget.onLocaleChanged,
                        onThemeChanged: widget.onThemeChanged,
                        currentLocale: widget.currentLocale,
                        currentThemeMode: widget.currentThemeMode,
                      ),
                    ),
                  ); // إغلاق MaterialPageRoute
                } // إغلاق if
              }, // إغلاق onSelected
            ), // إغلاق PopupMenuButton
          ], // إغلاق actions
        ), // إغلاق AppBar
        body: widget.dummyChats.isEmpty
            ? Center(
                child: Text(
                  'لا يوجد محادثات',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: widget.dummyChats.length,
                itemBuilder: (context, index) {
                  final chatModel = widget.dummyChats[index];
                  final user = users.firstWhere(
                    (u) => u.id == chatModel.userId,
                  );
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
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
                                    chatModel
                                        .messages
                                        .last
                                        .voicePath!
                                        .isNotEmpty
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
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      trailing: user.isOnline
                          ? Icon(
                              Icons.circle,
                              color: Color(0xFF25D366),
                              size: 14,
                            )
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
              ),
      ),
    );
  }
}
