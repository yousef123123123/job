import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'home_body.dart';
import 'package:job/features/chat/data/models/chat_model.dart';
import 'package:job/core/localization/app_localizations.dart';
import 'package:job/features/home/presentation/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<Locale?>? onLocaleChanged;
  final ValueChanged<ThemeMode?>? onThemeChanged;
  final Locale? currentLocale;
  final ThemeMode? currentThemeMode;
  final List<UserModel> users = [
    UserModel(
      id: 'user1',
      name: 'yousef',
      avatarPath: 'https://randomuser.me/api/portraits/men/1.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user2',
      name: 'ElRys',
      avatarPath:
          'https://en.amwalalghad.com/wp-content/uploads/2025/02/sisi_feb2.jpg',
      isOnline: false,
    ),
    UserModel(
      id: 'user3',
      name: 'Ali',
      avatarPath:
          'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/506804367_2079200242566177_1949159825969359624_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=IB1o2R_ELwUQ7kNvwGtPbO-&_nc_oc=Adl4FsOVg4vufeBuG-XDxPmaxYbd4e7OWcfojsbqL-3kZRUgT-mKZ-A4lAXrmyQbHDg&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=k8-cd07nEWS9Ac7lp2Rbhw&oh=00_AfXFW9bwNWS-c-l-DMboFvyPWGfFesDybz-BDzSEnRsVKA&oe=68AB174A',
      isOnline: true,
    ),
    UserModel(
      id: 'user4',
      name: 'monaa',
      avatarPath: 'https://randomuser.me/api/portraits/women/4.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user5',
      name: 'omar',
      avatarPath:
          'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/518324283_4044696459192712_2011175525981043257_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=833d8c&_nc_ohc=7vsbN0edd1YQ7kNvwHtPLu8&_nc_oc=Adm0G0KpeioZ16yT2Ax75YBSu-vCO99mV4Qd6g6qKQ7cdNY7RzjlNaYiCN4RW9jz_tE&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=k4kzdl5tCu5pJiEit1MWng&oh=00_AfUbobhjYZ6hO4rzK2IVshm1W1OXKrg4Tfecwj56vUvN_A&oe=68AB2436',
      isOnline: false,
    ),
    UserModel(
      id: 'user6',
      name: 'lolo',
      avatarPath: 'https://randomuser.me/api/portraits/women/6.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user7',
      name: 'sayed',
      avatarPath:
          'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/387755825_1608735739657875_517741673334542787_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=rrr_fyX3oJQQ7kNvwFvWI5X&_nc_oc=AdkuyVBDB5MeHv68SKvWAd60QZj_GctkSgVsr0P-2F6IrQmdwk5sllokwCXE5pGf4u8&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=Eb-vhFOTMkjKPy2ktOtLxw&oh=00_AfUk3f1WlZYOec4fEi7w6Y_sEXfz8sa8vAVmPfiu59EzOg&oe=68AB1446',
      isOnline: false,
    ),
    UserModel(
      id: 'user8',
      name: 'geme',
      avatarPath: 'https://randomuser.me/api/portraits/women/8.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user9',
      name: 'koko',
      avatarPath: 'https://randomuser.me/api/portraits/men/9.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user10',
      name: 'Rania',
      avatarPath: 'https://randomuser.me/api/portraits/women/10.jpg',
      isOnline: false,
    ),
    UserModel(
      id: 'user11',
      name: 'temo',
      avatarPath: 'https://randomuser.me/api/portraits/men/11.jpg',
      isOnline: true,
    ),
    UserModel(
      id: 'user12',
      name: 'Abdo',
      avatarPath:
          'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/514355676_4041458572849834_4014911700767193345_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=tyiKmFl5iMQQ7kNvwFI3rPe&_nc_oc=AdnIh0q-XF8BLmVnf_GUbaJqOh1hoBp1emd3XdmqP_9f_y0fW90AfjI8uGKY7MT2r6s&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=ov0Ji2uMzTfFDJIQ9dwkMg&oh=00_AfXyELIP0s2UCuksvp6gMKdoZiUsxjM9L3GkAH9Lu_hnQA&oe=68AB0041',
      isOnline: false,
    ),
  ];

  HomePage({
    Key? key,
    this.onLocaleChanged,
    this.onThemeChanged,
    this.currentLocale,
    this.currentThemeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final dummyChats = List.generate(
      users.length,
      (i) => ChatModel(
        id: 'chat${i + 1}',
        userId: users[i].id,
        unreadCount: (i % 4),
        messages: [],
      ),
    );
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
