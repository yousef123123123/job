part of 'settings_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLocaleChanged extends SettingsState {
  final dynamic locale;
  SettingsLocaleChanged(this.locale);
}

class SettingsThemeChanged extends SettingsState {
  final dynamic themeMode;
  SettingsThemeChanged(this.themeMode);
}
