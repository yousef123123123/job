import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoicePlayerWidget extends StatefulWidget {
  final String voicePath;
  const VoicePlayerWidget({required this.voicePath, Key? key})
    : super(key: key);

  @override
  State<VoicePlayerWidget> createState() => _VoicePlayerWidgetState();
}

class _VoicePlayerWidgetState extends State<VoicePlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  Future<void> _play() async {
    await _player.setFilePath(widget.voicePath);
    await _player.play();
  }

  Future<void> _stop() async {
    await _player.stop();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.stop : Icons.play_arrow,
            color: Colors.green,
          ),
          onPressed: _isPlaying ? _stop : _play,
        ),
        Text('Voice message', style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
