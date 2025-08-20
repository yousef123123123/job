import 'package:flutter/material.dart';

class NavBarUpdatesIcon extends StatelessWidget {
  final bool selected;
  const NavBarUpdatesIcon({required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? Colors.grey[400] : Color(0xFF667781);
    return Image.asset(
      'assets/images/updates.png',
      width: 28,
      height: 28,
      color: selected ? Color(0xFF25D366) : unselectedColor,
    );
  }
}
