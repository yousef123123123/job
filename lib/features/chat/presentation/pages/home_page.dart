import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'home_body.dart';
import 'package:job/features/chat/data/models/chat_model.dart';
import 'package:job/core/localization/app_localizations.dart';
import 'package:job/features/home/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  final ValueChanged<Locale?>? onLocaleChanged;
  final ValueChanged<ThemeMode?>? onThemeChanged;
  final Locale? currentLocale;
  final ThemeMode? currentThemeMode;

  HomePage({
    Key? key,
    required this.dummyChats,
    required this.users,
    this.onLocaleChanged,
    this.onThemeChanged,
    this.currentLocale,
    this.currentThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    // dummyChats و users يتم تمريرهم من الراوتر
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarBg = isDark ? Color(0xFF1F2C34) : Color(0xFF075E54);
    final iconColor = isDark ? Color(0xFFB6C2CB) : Colors.white;
    final searchIconColor = isDark ? Color(0xFFB6C2CB) : Colors.white;
    final cameraIconColor = isDark ? Color(0xFFB6C2CB) : Colors.white;
    final menuBg = isDark ? Color(0xFF222E35) : Colors.white;
    final menuTextColor = isDark ? Colors.white70 : Colors.black87;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF111B21) : Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              loc?.appTitle ?? 'WhatsApp',
              style: TextStyle(
                color: isDark ? Color(0xFFE9EDEF) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.camera_alt_rounded, color: cameraIconColor),
              onPressed: () {},
              tooltip: 'Camera',
            ),
            IconButton(
              icon: Icon(Icons.search, color: searchIconColor),
              onPressed: () {},
              tooltip: 'Search',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(users[0].avatarPath),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: iconColor),
            color: menuBg,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                enabled: false,
                child: Text(
                  loc?.newGroup ?? 'New Group',
                  style: TextStyle(color: menuTextColor.withOpacity(0.5)),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                enabled: false,
                child: Text(
                  loc?.newBroadcast ?? 'New Broadcast',
                  style: TextStyle(color: menuTextColor.withOpacity(0.5)),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                enabled: false,
                child: Text(
                  loc?.linkedDevices ?? 'Linked Devices',
                  style: TextStyle(color: menuTextColor.withOpacity(0.5)),
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
                      onLocaleChanged: onLocaleChanged ?? (_) {},
                      onThemeChanged: onThemeChanged ?? (_) {},
                      currentLocale:
                          currentLocale ?? Localizations.localeOf(context),
                      currentThemeMode:
                          currentThemeMode ??
                          (Theme.of(context).brightness == Brightness.dark
                              ? ThemeMode.dark
                              : ThemeMode.light),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: HomeBody(dummyChats: dummyChats, users: users),
    );
  }
}
