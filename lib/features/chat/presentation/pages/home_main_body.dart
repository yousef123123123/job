import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class HomeMainBody extends StatelessWidget {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  const HomeMainBody({required this.dummyChats, required this.users, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dummyChats.isEmpty
        ? Center(
            child: Text(
              'لا يوجد محادثات',
              style: TextStyle(color: Colors.white),
            ),
          )
        : ListView.builder(
            itemCount: dummyChats.length,
            itemBuilder: (context, index) {
              final chatModel = dummyChats[index];
              final user = users.firstWhere((u) => u.id == chatModel.userId);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarPath),
                  radius: 26,
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  chatModel.messages.isNotEmpty
                      ? chatModel.messages.last.text
                      : 'آخر رسالة...',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                trailing: user.isOnline
                    ? Icon(Icons.circle, color: Color(0xFF25D366), size: 14)
                    : null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: Text(user.name)),
                        body: Center(
                          child: Text('صفحة الشات'),
                        ), // صفحة شات بسيطة
                      ),
                    ),
                  );
                },
              );
            },
          );
  }
}
