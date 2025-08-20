import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import 'package:hive/hive.dart';
import '../../data/models/message_model.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'package:hive/hive.dart';
import '../../data/models/message_model.dart';
import '../../data/models/default_messages_model.dart';
import 'chat_page.dart';
import 'dart:io';
import 'package:job/constants/colors.dart';
import '../widgets/chat_tile.dart';
import '../cubit/chat_cubit.dart';

class HomeBody extends StatelessWidget {
  final List<dynamic> dummyChats;
  final List<UserModel> users;
  HomeBody({required this.dummyChats, required this.users, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        dummyChats: dummyChats,
        users: users,
        messagesBox: Hive.box<MessageModel>('messages'),
        defaultMessages: DefaultMessagesModel.getDefault(),
      ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          if (state is ChatLoaded) {
            final chats = state.chats;
            final cubit = context.read<ChatCubit>();
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chatModel = chats[index];
                final user = users.firstWhere((u) => u.id == chatModel.userId);
                final messagesBox = cubit.messagesBox;
                final chatMessages = messagesBox.values.where((msg) => msg.chatId == chatModel.id).toList();
                Widget lastMsgWidget;
                if (chatMessages.isNotEmpty) {
                  final lastMsg = chatMessages.last;
                  if (lastMsg.mediaPath != null && lastMsg.mediaPath!.isNotEmpty) {
                    lastMsgWidget = Row(
                      children: [
                        Icon(Icons.image, size: 16, color: isDark ? Colors.white70 : Colors.grey[700]),
                        SizedBox(width: 4),
                        Text('صورة', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[700])),
                      ],
                    );
                  } else if (lastMsg.voicePath != null && lastMsg.voicePath!.isNotEmpty) {
                    lastMsgWidget = Row(
                      children: [
                        Icon(Icons.mic, size: 16, color: isDark ? Colors.white70 : Colors.grey[700]),
                        SizedBox(width: 4),
                        Text('مقطع صوتي', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[700])),
                      ],
                    );
                  } else {
                    lastMsgWidget = Text(
                      lastMsg.text,
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[700]),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }
                } else {
                  lastMsgWidget = Text('ابدأ المحادثة', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[700]));
                }
                return ChatTile(
                  user: user,
                  chatModel: chatModel,
                  chatMessages: chatMessages,
                  lastMsgWidget: lastMsgWidget,
                  isDark: isDark,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          messages: chatMessages,
                          chatId: chatModel.id,
                          user: user,
                        ),
                      ),
                    );
                    cubit.resetUnread(chatModel);
                    cubit.reorderChat(chatModel);
                  },
                  onAvatarTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.45),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      user.name + (user.id == 'me' ? ' (You)' : ''),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: user.avatarPath.startsWith('http')
                                        ? Image.network(user.avatarPath, fit: BoxFit.cover, height: 260, width: double.infinity)
                                        : Image.file(File(user.avatarPath), fit: BoxFit.cover, height: 260, width: double.infinity),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.chat, color: AppColors.whatsappGreen, size: 28),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => ChatPage(
                                                  messages: chatMessages,
                                                  chatId: chatModel.id,
                                                  user: user,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.info_outline, color: AppColors.whatsappGreen, size: 28),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
          
