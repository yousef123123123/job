import 'package:flutter/material.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/voice_recorder_widget.dart';
import '../widgets/voice_player_widget.dart';

class ChatPage extends StatefulWidget {
  final List<MessageModel> messages;
  final String chatId;
  final UserModel? user;
  final Function(MessageModel)? onSend;
  const ChatPage({
    required this.messages,
    required this.chatId,
    this.user,
    this.onSend,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<MessageModel> _messages;
  final TextEditingController _controller = TextEditingController();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages);
  }

  void _sendMessage({String? text, File? image, String? voicePath}) {
    if ((text == null || text.trim().isEmpty) &&
        image == null &&
        voicePath == null)
      return;
    final msg = MessageModel(
      id: 'msg${_messages.length}',
      chatId: widget.chatId,
      senderId: 'me',
      text: text ?? '',
      mediaPath: image?.path,
      voicePath: voicePath,
      timestamp: DateTime.now(),
      isSeen: true,
      isMine: true,
    );
    setState(() {
      _messages.add(msg);
      _controller.clear();
      _pickedImage = null;
    });
    if (widget.onSend != null) widget.onSend!(msg);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
      _sendMessage(image: _pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String lastSeen = user?.isOnline == true
        ? 'متصل الآن'
        : 'آخر ظهور: ${DateTime.now().subtract(Duration(minutes: 5)).hour}:${DateTime.now().subtract(Duration(minutes: 5)).minute}';
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
            titleSpacing: 0,
            title: Row(
              children: [
                SizedBox(width: 4),
                if (user != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarPath),
                    radius: 22,
                  ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      lastSeen,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.call, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.videocam, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
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
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: isDark
                            ? Color(0xFF2A3942)
                            : Color(0xFF2A3942),
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
                      onSubmitted: (val) => _sendMessage(text: val),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey[400]),
                    onPressed: _pickImage,
                  ),
                  SizedBox(width: 8),
                  VoiceRecorderWidget(
                    onVoiceRecorded: (path) {
                      _sendMessage(voicePath: path);
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
                      onPressed: () => _sendMessage(text: _controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
