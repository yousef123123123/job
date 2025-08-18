import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';
import '../widgets/voice_recorder_widget.dart';
import '../widgets/voice_player_widget.dart';

class ChatBody extends StatelessWidget {
  final List<MessageModel> messages;
  final String chatId;
  final UserModel? user;
  final Function(MessageModel)? onSend;
  const ChatBody({
    required this.messages,
    required this.chatId,
    this.user,
    this.onSend,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[messages.length - 1 - index];
              final isMine = msg.isMine;
              return Align(
                alignment: isMine
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isMine
                        ? (isDark ? Color(0xFF202C33) : Color(0xFFDCF8C6))
                        : (isDark ? Color(0xFF2A3942) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 0),
                      bottomRight: Radius.circular(isMine ? 0 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 2),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (msg.mediaPath != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          child: Image.file(
                            File(msg.mediaPath!),
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (msg.voicePath != null)
                        VoicePlayerWidget(voicePath: msg.voicePath!),
                      if (msg.text.isNotEmpty)
                        Text(msg.text, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: msg.isSeen
                                ? Color(0xFF25D366)
                                : Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: isDark ? Color(0xFF202C33) : Color(0xFF222E35),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.emoji_emotions, color: Colors.grey[400]),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: isDark ? Color(0xFF2A3942) : Color(0xFF2A3942),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty && onSend != null) {
                      onSend!(
                        MessageModel(
                          id: 'msg${messages.length}',
                          chatId: chatId,
                          senderId: 'me',
                          text: val,
                          mediaPath: null,
                          voicePath: null,
                          timestamp: DateTime.now(),
                          isSeen: true,
                          isMine: true,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              VoiceRecorderWidget(
                onVoiceRecorded: (path) {
                  if (onSend != null) {
                    onSend!(
                      MessageModel(
                        id: 'msg${messages.length}',
                        chatId: chatId,
                        senderId: 'me',
                        text: '',
                        mediaPath: null,
                        voicePath: path,
                        timestamp: DateTime.now(),
                        isSeen: true,
                        isMine: true,
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF075E54),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
