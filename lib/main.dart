import 'portrait_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'features/chat/presentation/pages/home_page.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/stories/presentation/pages/stories_page.dart';

import 'features/stories/data/models/story_model.dart';
import 'features/chat/domain/usecases/get_chats.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/data/models/chat_model.dart';
import 'features/chat/data/models/user_model.dart';
import 'features/chat/data/models/message_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPortraitMode();
  await Hive.initFlutter();
  Hive.registerAdapter(StoryModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  await Hive.openBox<StoryModel>('storiesBox');
  await Hive.openBox<MessageModel>('messages');
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
  bool isSelectedIcon = false;

  void _onLocaleChanged(Locale? locale) {
    if (locale != null) {
      setState(() {
        _locale = locale;
        // إعادة بناء التطبيق بالكامل
      });
    }
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode != null) {
      setState(() {
        _themeMode = mode;
        // إعادة بناء التطبيق بالكامل
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
        name: 'Joooo',
        avatarPath:
            'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/347413470_6382903195124063_7282368361415306080_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=ctZoHexm8gEQ7kNvwEgi5mL&_nc_oc=AdkjOhXXgfg-af6PbwjwOVJlRmw2tOWBkIhLn7lMoUoXIM0J1hoVsz55mjBlIN8GbEY&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=Cj5hSKW172W253oUUB6QvQ&oh=00_AfXEPL9mU-TzyR_ybmtkOODnw4NyI5LOavCqGYoUfbpR3Q&oe=68AAB343',
        isOnline: true,
      ),
      UserModel(
        id: 'user2',
        name: 'Salah',
        avatarPath:
            'https://www.discoverwalks.com/blog/wp-content/uploads/2021/10/mohamed_salah_2018.jpg',
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
        name: 'جووو',
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
        name: 'Loly',
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
        name: 'Noura',
        avatarPath: 'https://randomuser.me/api/portraits/women/8.jpg',
        isOnline: true,
      ),
      UserModel(
        id: 'user9',
        name: 'Osos',
        avatarPath: 'https://randomuser.me/api/portraits/men/9.jpg',
        isOnline: true,
      ),
      UserModel(
        id: 'user10',
        name: 'ٍسلوي',
        avatarPath: 'https://randomuser.me/api/portraits/women/10.jpg',
        isOnline: false,
      ),
    ];
    final egyptianMessages = [
      'عامل ايه يا نجم واحشناااي ؟',
      'وحشتني والله!',
      'فينك مختفي كده؟',
      'تعالى نقعد على القهوة النهاردة',
      'شفت ماتش الأهلي امبارح؟',
      'هاتلي معاك سندوتش فول وانت جاي',
      'الدنيا حر موووووت هنا',
      'عايزين نطلع دهب قريب',
      'ابعتلي الصور اللي اتصورناها',
      'هكلمك بعدين، عندي صدااع دلوقتي',
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
      'https://randomuser.me/api/portraits/men/1.jpg',
      'https://www.discoverwalks.com/blog/wp-content/uploads/2021/10/mohamed_salah_2018.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSf0wwp8qMjs92mR6lKflihcc5xLcMJBg5CzQ&s',
      'https://www.discoverwalks.com/blog/wp-content/uploads/2022/02/abdel-fattah-el-sisi-wikipedia.jpg',
      'https://randomuser.me/api/portraits/women/2.jpg',
      'https://randomuser.me/api/portraits/men/3.jpg',
      'https://randomuser.me/api/portraits/women/4.jpg',

      'https://randomuser.me/api/portraits/men/5.jpg',
      'https://randomuser.me/api/portraits/women/6.jpg',
      'https://randomuser.me/api/portraits/men/7.jpg',
    ];
    final dummyStories = List.generate(
      10,
      (i) => StoryModel(
        id: 'story${i + 1}',
        userId: dummyUsers[i].id,
        name: dummyUsers[i].name,
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
          final loc = AppLocalizations.of(context);
          return Scaffold(
            body: _selectedIndex < 2 ? pages[_selectedIndex] : pages[0],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Color(0xFF222E35),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  if (index == 2 || index == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          loc?.screenNotImplemented ??
                              'هذه الشاشة لم يتم تنفيذها بعد',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Color(0xFF075E54),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    _onTabSelected(index);
                  }
                },
                backgroundColor: Colors.transparent,
                selectedItemColor: Color(0xFF25D366),
                unselectedItemColor: Colors.white70,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: loc?.homeTitle ?? 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/updates.png',
                      // color:
                      color: Color(0xFF25D366),
                      // color: Colors.white70,
                      width: 28,
                      height: 28,
                    ),
                    label: loc?.storiesTitle ?? 'stories_title',
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
