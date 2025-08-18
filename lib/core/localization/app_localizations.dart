import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AppLocalizations {
  String get communicationsTitle =>
      locale.languageCode == 'ar' ? 'جهات الاتصال' : 'Communications';
  String get callsTitle => locale.languageCode == 'ar' ? 'المكالمات' : 'Calls';
  String get screenNotImplemented => locale.languageCode == 'ar'
      ? 'هذه الشاشة لم يتم تنفيذها بعد'
      : 'This screen is not implemented yet';
  String get newGroup =>
      locale.languageCode == 'ar' ? 'مجموعة جديدة' : 'New Group';
  String get newBroadcast =>
      locale.languageCode == 'ar' ? 'بث جديد' : 'New Broadcast';
  String get linkedDevices =>
      locale.languageCode == 'ar' ? 'الأجهزة المرتبطة' : 'Linked Devices';
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('ar')];

  String get appTitle =>
      locale.languageCode == 'ar' ? 'واتساب المحلي' : 'WhatsApp Local';
  String get homeTitle => locale.languageCode == 'ar' ? 'الدردشات' : 'Chats';
  String get storiesTitle =>
      locale.languageCode == 'ar' ? 'الحالات' : 'Stories';
  String get settingsTitle =>
      locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get chatInputHint => Intl.message(
    'Type a message',
    name: 'chat_input_hint',
    locale: locale.toString(),
  );
  String get send =>
      Intl.message('Send', name: 'send', locale: locale.toString());
  String get typing =>
      Intl.message('typing...', name: 'typing', locale: locale.toString());
  String get online =>
      Intl.message('Online', name: 'online', locale: locale.toString());
  String get offline =>
      Intl.message('Offline', name: 'offline', locale: locale.toString());
  String get language =>
      Intl.message('Language', name: 'language', locale: locale.toString());
  String get english =>
      Intl.message('English', name: 'english', locale: locale.toString());
  String get arabic =>
      Intl.message('Arabic', name: 'arabic', locale: locale.toString());
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
