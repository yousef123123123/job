import 'package:flutter/material.dart';

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
                'الثيم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                  value: currentThemeMode,
                  items: [
                    DropdownMenuItem(
                      child: Text('النظام'),
                      value: ThemeMode.system,
                    ),
                    DropdownMenuItem(
                      child: Text('فاتح'),
                      value: ThemeMode.light,
                    ),
                    DropdownMenuItem(
                      child: Text('غامق'),
                      value: ThemeMode.dark,
                    ),
                  ],
                  onChanged: onThemeChanged,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          // محتوى إضافي (حشو) ليبدو مثل واتساب
          // Text(
          //   'معلومات الحساب',
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // SizedBox(height: 8),
          // Text('رقم الهاتف: 01012345678'),
          // SizedBox(height: 8),
          // Text('البريد الإلكتروني: user@email.com'),
          // SizedBox(height: 24),
          // Text(
          //   'الإشعارات',
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // SizedBox(height: 8),
          // Row(
          //   children: [
          //     Icon(Icons.notifications, color: Color(0xFF25D366)),
          //     SizedBox(width: 8),
          //     Text('تشغيل الإشعارات'),
          //   ],
          // ),
          // Spacer(),
          // Center(
          //   child: Text(
          //     '© جميع الحقوق محفوظة 2025',
          //     style: TextStyle(color: Colors.grey, fontSize: 13),
          //   ),
          // ),
        ],
      ),
    );
  }
}
