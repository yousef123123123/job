import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:job/widgets/my_app_widget.dart';

import 'features/chat/data/models/message_model.dart';

import 'features/stories/data/models/story_model.dart';
import 'widgets/portrait_lock.dart';

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
