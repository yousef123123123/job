import 'package:job/core/routes/app_routes.dart';
import 'package:job/widgets/_nav_bar_updates_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:job/core/localization/app_localizations.dart';
import 'package:job/core/theme/app_theme.dart';
import 'package:job/features/chat/presentation/pages/home_page.dart';
import 'package:job/features/stories/presentation/pages/stories_page.dart';
import 'package:job/features/stories/data/models/story_model.dart';

import 'package:job/features/chat/data/models/dummy_chats.dart';
import 'package:job/features/chat/data/models/dummy_users.dart';
import 'package:job/features/chat/data/models/user_model.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.dark;
  int _selectedIndex = 0;

  void _onTabSelected(int index, BuildContext context) {
    if (index == 2 || index == 3) {
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF075E54), // WhatsApp dark green
                  Color(0xFF25D366), // WhatsApp light green
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              loc?.screenNotImplemented ?? 'Not implemented',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLocaleChanged(Locale? locale) {
    if (locale != null) {
      setState(() {
        _locale = locale;
      });
    }
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode != null) {
      setState(() {
        _themeMode = mode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dummyStories = [
      StoryModel(
        id: 'story1',
        userId: 'user1',
        name: 'Yousef',
        mediaPath:
            'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/387755825_1608735739657875_517741673334542787_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=rrr_fyX3oJQQ7kNvwFvWI5X&_nc_oc=AdkuyVBDB5MeHv68SKvWAd60QZj_GctkSgVsr0P-2F6IrQmdwk5sllokwCXE5pGf4u8&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=Eb-vhFOTMkjKPy2ktOtLxw&oh=00_AfUk3f1WlZYOec4fEi7w6Y_sEXfz8sa8vAVmPfiu59EzOg&oe=68AB1446',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isViewed: false,
        mediaType: 'image',
      ),
      StoryModel(
        id: 'story2',
        userId: 'user2',
        name: 'Abdallah Essa',
        mediaPath:
            'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/502659506_2228163400935859_1315357540697861294_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=g5mPk-KtL_wQ7kNvwEK8B7j&_nc_oc=Admj2xGPTDe2tyIrDTxjBSUzVZLj8O0Y0ZJwoODKkFuVuaKRJWVrBjmfYHmpe-bcwho&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=PotPROE46erSf8bjDtd8GQ&oh=00_AfU-ptD-hqIfH5hTmv21qxj4PZvc8FzRJvFfPj_zyq45Iw&oe=68AB139C',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isViewed: true,
        mediaType: 'image',
      ),
      StoryModel(
        id: 'story3',
        userId: 'user3',
        name: 'Saber ',
        mediaPath:
            'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/506804367_2079200242566177_1949159825969359624_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=IB1o2R_ELwUQ7kNvwGtPbO-&_nc_oc=Adl4FsOVg4vufeBuG-XDxPmaxYbd4e7OWcfojsbqL-3kZRUgT-mKZ-A4lAXrmyQbHDg&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=k8-cd07nEWS9Ac7lp2Rbhw&oh=00_AfXFW9bwNWS-c-l-DMboFvyPWGfFesDybz-BDzSEnRsVKA&oe=68AB174A',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        isViewed: false,
        mediaType: 'image',
      ),
    ];
    // Use imported dummy data
    final pages = [
      HomePage(
        dummyChats: dummyChats,
        users: dummyUsers,
        onLocaleChanged: _onLocaleChanged,
        onThemeChanged: _onThemeChanged,
        currentLocale: _locale,
        currentThemeMode: _themeMode,
      ),
      StoriesPage(stories: dummyStories),
      Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context);
          return Center(
            child: Text(
              loc?.communicationsTitle ?? 'Communications',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context);
          return Center(
            child: Text(
              loc?.callsTitle ?? 'Calls',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final navBarColor = isDark ? Color(0xFF222E35) : Colors.white;
          final loc = AppLocalizations.of(context);
          return Scaffold(
            backgroundColor: isDark ? Color(0xFF111B21) : Color(0xFFF0F0F0),
            body: pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: navBarColor,
              selectedItemColor: Color(0xFF25D366),
              unselectedItemColor: isDark ? Colors.white70 : Color(0xFF667781),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: loc?.homeTitle ?? 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: NavBarUpdatesIcon(selected: _selectedIndex == 1),
                  label: loc?.storiesTitle ?? 'Stories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_outlined),
                  label: loc?.communicationsTitle ?? 'Communications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  label: loc?.callsTitle ?? 'Calls',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (i) => _onTabSelected(i, context),
            ),
          );
        },
      ),
    );
  }
}
