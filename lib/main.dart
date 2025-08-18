import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'features/chat/presentation/pages/home_page.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/stories/presentation/pages/stories_page.dart';
import 'features/home/presentation/pages/settings_page.dart';
import 'features/stories/data/models/story_model.dart';
import 'features/chat/domain/entities/chat.dart';
import 'features/chat/domain/usecases/get_chats.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/data/models/chat_model.dart';
import 'features/chat/data/models/user_model.dart';
import 'features/chat/data/models/message_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;
  int _selectedIndex = 0;

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

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dummyUsers = [
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
    final egyptianMessages = [
      'عامل ايه يا صاحبي؟',
      'وحشتني والله!',
      'فينك مختفي كده؟',
      'تعالى نقعد على القهوة النهاردة',
      'شفت ماتش الأهلي امبارح؟',
      'هاتلي معاك سندوتش فول وانت جاي',
      'الدنيا حر موت هنا',
      'عايزين نطلع رحلة قريب',
      'ابعتلي الصور اللي صورناها',
      'هكلمك بعدين، عندي شغل دلوقتي',
    ];
    final dummyChats = List.generate(
      10,
      (i) => ChatModel(
        id: 'chat${i + 1}',
        userId: dummyUsers[i].id,
        unreadCount: (i % 4),
        messages: List.generate(
          7,
          (j) => MessageModel(
            id: 'msg${i}_${j}',
            chatId: 'chat${i + 1}',
            senderId: j % 2 == 0 ? 'me' : dummyUsers[i].id,
            text: egyptianMessages[(j + i) % egyptianMessages.length],
            mediaPath: null,
            voicePath: null,
            timestamp: DateTime.now().subtract(Duration(minutes: 10 * (7 - j))),
            isSeen: j % 3 != 0,
            isMine: j % 2 == 0,
          ),
        ),
      ),
    );
    final storyMedia = [
      // صور
      'https://randomuser.me/api/portraits/men/1.jpg',
      'https://randomuser.me/api/portraits/women/2.jpg',
      'https://randomuser.me/api/portraits/men/3.jpg',
      'https://randomuser.me/api/portraits/women/4.jpg',
      // فيديوهات  من النت
      'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_1mb.mp4',
      'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_2mb.mp4',
      'https://sample-videos.com/video123/mp4/240/big_buck_bunny_240p_3mb.mp4',
      // صور
      'https://randomuser.me/api/portraits/men/5.jpg',
      'https://randomuser.me/api/portraits/women/6.jpg',
      'https://randomuser.me/api/portraits/men/7.jpg',
    ];
    final dummyStories = List.generate(
      10,
      (i) => StoryModel(
        id: 'story${i + 1}',
        userId: dummyUsers[i].id,
        mediaPath: storyMedia[i],
        timestamp: DateTime.now().subtract(Duration(hours: i)),
        isViewed: i % 2 == 0,
        mediaType: storyMedia[i].endsWith('.mp4') ? 'video' : 'image',
      ),
    );
    final pages = [
      BlocProvider(
        create: (context) {
          final getChats = GetChats(MockChatRepository(dummyChats));
          final cubit = ChatCubit(getChats);
          cubit.loadChats();
          return cubit;
        },
        child: HomePage(
          dummyChats: dummyChats,
          onLocaleChanged: _onLocaleChanged,
          onThemeChanged: _onThemeChanged,
          currentLocale: _locale,
          currentThemeMode: _themeMode,
        ),
      ),
      StoriesPage(stories: dummyStories),
    ];
    return MaterialApp(
      title: 'WhatsApp Local',
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
          final loc = AppLocalizations.of(context);
          return Scaffold(
            body: pages[_selectedIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Color(0xFF222E35),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onTabSelected,
                backgroundColor: Colors.transparent,
                selectedItemColor: Color(0xFF25D366),
                unselectedItemColor: Colors.white70,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.circle_outlined,
                    ), // WhatsApp-style status icon
                    label: 'Updates',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MockChatRepository implements ChatRepository {
  final List<ChatModel> chats;
  MockChatRepository(this.chats);
  @override
  List<ChatModel> getAllChats() => chats;
  @override
  Future<void> addChat(ChatModel chat) async {}
  @override
  Future<void> deleteChat(String id) async {}
  @override
  ChatModel? getChat(String id) {
    try {
      return chats.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
