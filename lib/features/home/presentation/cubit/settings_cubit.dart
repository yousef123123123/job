import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void changeLocale(locale) {
    emit(SettingsLocaleChanged(locale));
  }

  void changeTheme(themeMode) {
    emit(SettingsThemeChanged(themeMode));
  }
}
