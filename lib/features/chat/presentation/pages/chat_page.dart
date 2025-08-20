import 'package:flutter/material.dart';
import 'package:job/core/localization/app_localizations.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/voice_player_widget.dart';
import 'package:hive/hive.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

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
  late final AudioPlayer _sendPlayer;
  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  late List<MessageModel> _messages;
  late Box<MessageModel> _messagesBox;
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder(); // مكتبة record 6.x
  bool _isRecording = false;
  bool _isLocked = false;
  bool _showSend = false;
  // Removed unused fields (_startLongPressOffset, _recordingHint, _lockThreshold)
  String? _voicePath;
  int _recordDuration = 0;
  Timer? _recordTimer;

  Future<void> _pickCameraImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      _sendMessage(image: File(picked.path));
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesBox = Hive.box<MessageModel>('messages');
    _messages = _messagesBox.values
        .where((msg) => msg.chatId == widget.chatId)
        .toList();
    _controller.addListener(() {
      setState(() {
        _showSend = _controller.text.trim().isNotEmpty;
      });
    });
    _sendPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _sendPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSendSound() async {
    try {
      await _sendPlayer.setAsset('assets/audio/sound.mp3');
      await _sendPlayer.seek(Duration.zero);
      await _sendPlayer.play();
    } catch (e) {
      // ignore error
    }
  }

  void _sendMessage({String? text, File? image, String? voicePath}) async {
    if ((text == null || text.trim().isEmpty) &&
        image == null &&
        voicePath == null)
      return;
    final msg = MessageModel(
      id: 'msg${DateTime.now().millisecondsSinceEpoch}',
      chatId: widget.chatId,
      senderId: 'me',
      text: text ?? '',
      mediaPath: image?.path,
      voicePath: voicePath,
      timestamp: DateTime.now(),
      isSeen: true,
      isMine: true,
    );
    _messagesBox.add(msg);
    setState(() {
      _messages.add(msg);
      _controller.clear();
    });
    if (widget.onSend != null) widget.onSend!(msg);
    await _playSendSound();
  }

  Future<void> _pickImage() async {
    final picked = await FilePicker.platform.pickFiles(type: FileType.image);
    if (picked != null && picked.files.isNotEmpty) {
      _sendMessage(image: File(picked.files.first.path!));
    }
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    setState(() {
      _isRecording = true;
      _isLocked = false;
      _voicePath = null;
      _recordDuration = 0;
    });
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _recordDuration++;
      });
    });
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
    _voicePath = path;
  }

  void _onLongPressEnd(LongPressEndDetails details) async {
    if (_isRecording && !_isLocked) {
      setState(() {
        _isRecording = false;
      });
      _recordTimer?.cancel();
      final recordedPath = await _recorder.stop();
      final filePath = recordedPath ?? _voicePath;
      if (filePath != null && File(filePath).existsSync()) {
        _sendMessage(voicePath: filePath);
      }
    }
  }

  void _onCancelRecording() async {
    setState(() {
      _isRecording = false;
      _isLocked = false;
    });
    _recordTimer?.cancel();
    final recordedPath = await _recorder.stop();
    final filePath = recordedPath ?? _voicePath;
    if (filePath != null && File(filePath).existsSync()) {
      File(filePath).deleteSync();
    }
  }

  void _onSendRecording() async {
    setState(() {
      _isRecording = false;
      _isLocked = false;
    });
    _recordTimer?.cancel();
    final recordedPath = await _recorder.stop();
    final filePath = recordedPath ?? _voicePath;
    if (filePath != null && File(filePath).existsSync()) {
      _sendMessage(voicePath: filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String lastSeen = user?.isOnline == true
        ? (AppLocalizations.of(context)?.online ?? 'Online')
        : (AppLocalizations.of(context)?.lastSeen ?? 'last seen') +
              ': ${DateTime.now().subtract(Duration(minutes: 5)).hour.toString().padLeft(2, '0')}:${DateTime.now().subtract(Duration(minutes: 5)).minute.toString().padLeft(2, '0')}';
    final appBarBg = isDark ? Color(0xFF1F2C34) : Color(0xFF075E54);
    final iconColor = isDark ? Color(0xFFB6C2CB) : Colors.white;
    final titleColor = isDark ? Color(0xFFE9EDEF) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDark
                ? 'assets/images/back_dark.jpg'
                : 'assets/images/back_light.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appBarBg,
          elevation: 0,
          titleSpacing: 0,
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          title: Row(
            children: [
              if (user != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarPath),
                  radius: 20,
                ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.name ?? '',
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lastSeen,
                      style: TextStyle(
                        color: isDark ? Color(0xFF8696A0) : Colors.white70,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.call, color: iconColor),
              onPressed: () {},
              tooltip: 'Call',
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: iconColor),
              onPressed: () {},
              tooltip: 'Video',
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: iconColor),
              onPressed: () {},
              tooltip: 'Menu',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          child:
                              msg.mediaPath != null && msg.mediaPath!.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF25D366),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            13,
                                          ),
                                          child: Image.file(
                                            File(msg.mediaPath!),
                                            width: 220,
                                            height: 320,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 12,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 2,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Icon(
                                              Icons.done_all,
                                              size: 18,
                                              color: msg.isSeen
                                                  ? Color(0xFF25D366)
                                                  : Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 18,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                        0.84,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMine
                                        ? (isDark
                                              ? Color(0xFF202C33)
                                              : Color(0xFFDCF8C6))
                                        : (isDark
                                              ? Color(0xFF2A3942)
                                              : Colors.white),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(
                                        isMine ? 10 : 10,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMine ? 10 : 10,
                                      ),
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black12,
                                    //     blurRadius: 2,
                                    //   ),
                                    // ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (msg.voicePath != null &&
                                          msg.voicePath!.isNotEmpty)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            VoicePlayerWidget(
                                              voicePath: msg.voicePath!,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Icon(
                                                  Icons.done_all,
                                                  size: 16,
                                                  color: msg.isSeen
                                                      ? Color(0xFF25D366)
                                                      : Colors.grey[400],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      if (msg.text.isNotEmpty)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                msg.text,
                                                style: TextStyle(fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 2),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                  if (_isRecording)
                    Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mic, color: Colors.red, size: 28),
                                SizedBox(width: 12),
                                Text(
                                  _formatDuration(_recordDuration),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_isLocked)
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: _onCancelRecording,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.green,
                                        ),
                                        onPressed: _onSendRecording,
                                      ),
                                    ],
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
            Container(
              color: isDark ? Color(0xFF202C33) : Color(0xFF222E35),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey[400]),
                    onPressed: _pickImage,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)?.chatInputHint ??
                            'Type a message',
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
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.grey[400]),
                          onPressed: _pickCameraImage,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (val) => _sendMessage(text: val),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (_showSend)
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF25D366),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () => _sendMessage(text: _controller.text),
                      ),
                    )
                  else
                    GestureDetector(
                      onLongPressStart: _onLongPressStart,
                      onLongPressEnd: _onLongPressEnd,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _isRecording ? Colors.red : Color(0xFF25D366),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.mic, color: Colors.white, size: 28),
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
