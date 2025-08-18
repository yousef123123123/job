import 'package:flutter/material.dart';

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
    return Container(
      color: isDark ? Color(0xFF0B141A) : Color(0xFF111B21),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Color(0xFF075E54),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            title: Text(
              'الإعدادات',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: Padding(
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
                    'اللغة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: currentLocale,
                      items: [
                        DropdownMenuItem(
                          child: Text('العربية'),
                          value: Locale('ar'),
                        ),
                        DropdownMenuItem(
                          child: Text('English'),
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
                    'الوضع الليلي',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<ThemeMode>(
                      value: currentThemeMode,
                      items: [
                        DropdownMenuItem(
                          child: Text('فاتح'),
                          value: ThemeMode.light,
                        ),
                        DropdownMenuItem(
                          child: Text('داكن'),
                          value: ThemeMode.dark,
                        ),
                        DropdownMenuItem(
                          child: Text('النظام'),
                          value: ThemeMode.system,
                        ),
                      ],
                      onChanged: onThemeChanged,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'حول التطبيق',
                style: TextStyle(
                  color: Color(0xFF25D366),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Card(
                color: isDark ? Color(0xFF202C33) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: Color(0xFF25D366)),
                  title: Text(
                    'واتساب محلي - نسخة تجريبية',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('جميع الحقوق محفوظة © 2025'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
