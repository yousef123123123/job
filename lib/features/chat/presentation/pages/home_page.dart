import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'home_body.dart';
import 'package:job/features/home/presentation/pages/settings_page.dart';
import 'package:job/core/localization/app_localizations.dart';

class HomePage extends StatelessWidget {
  final List<dynamic> dummyChats;
  final ValueChanged<Locale?> onLocaleChanged;
  final ValueChanged<ThemeMode?> onThemeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;
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
  HomePage({
    required this.dummyChats,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Container(
      color: Color(0xFF111B21),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(
            loc?.appTitle ?? 'WhatsApp',
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
                    loc?.newGroup ?? 'New Group',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  enabled: false,
                  child: Text(
                    loc?.newBroadcast ?? 'New Broadcast',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  enabled: false,
                  child: Text(
                    loc?.linkedDevices ?? 'Linked Devices',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  enabled: true,
                  child: Text(
                    loc?.settingsTitle ?? 'Settings',
                    style: TextStyle(color: Color(0xFF25D366)),
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 3) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        onLocaleChanged: onLocaleChanged,
                        onThemeChanged: onThemeChanged,
                        currentLocale: currentLocale,
                        currentThemeMode: currentThemeMode,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: HomeBody(dummyChats: dummyChats, users: users),
      ),
    );
  }
}
