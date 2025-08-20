import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> setPortraitMode() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
