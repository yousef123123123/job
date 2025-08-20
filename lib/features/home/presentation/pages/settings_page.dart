import 'package:flutter/material.dart';
import 'settings_body.dart';
import 'package:job/core/localization/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  final ValueChanged<Locale?> onLocaleChanged;
  final ValueChanged<ThemeMode?> onThemeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;

  const SettingsPage({
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF0B141A) : Color(0xFF111B21),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Color(0xFF075E54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          title: Text(
            loc.settingsTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SettingsBody(
        onLocaleChanged: (locale) {
          onLocaleChanged(locale);
          Navigator.of(context).pop();
        },
        onThemeChanged: (mode) {
          onThemeChanged(mode);
          Navigator.of(context).pop();
        },
        currentLocale: currentLocale,
        currentThemeMode: currentThemeMode,
      ),
    );
  }
}
