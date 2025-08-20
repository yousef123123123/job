import 'package:flutter/material.dart';
import 'package:job/core/localization/app_localizations.dart';

class SettingsBody extends StatelessWidget {
  final ValueChanged<Locale?> onLocaleChanged;
  final ValueChanged<ThemeMode?> onThemeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;
  const SettingsBody({
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: isDark ? Color(0xFF202C33) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.language, color: Color(0xFF25D366)),
              title: Text(
                loc.language,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: currentLocale,
                  items: [
                    DropdownMenuItem(
                      child: Text(loc.arabic),
                      value: Locale('ar'),
                    ),
                    DropdownMenuItem(
                      child: Text(loc.english),
                      value: Locale('en'),
                    ),
                  ],
                  onChanged: onLocaleChanged,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            color: isDark ? Color(0xFF202C33) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.brightness_6, color: Color(0xFF25D366)),
              title: Text(
                loc.locale.languageCode == 'ar' ? 'الثيم' : 'Theme',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                  value: currentThemeMode == ThemeMode.system
                      ? ThemeMode.dark
                      : currentThemeMode,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        loc.locale.languageCode == 'ar' ? 'فاتح' : 'Light',
                      ),
                      value: ThemeMode.light,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        loc.locale.languageCode == 'ar' ? 'غامق' : 'Dark',
                      ),
                      value: ThemeMode.dark,
                    ),
                  ],
                  onChanged: onThemeChanged,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
