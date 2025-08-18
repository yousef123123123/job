import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String path) onVoiceRecorded;
  const VoiceRecorderWidget({required this.onVoiceRecorded, Key? key})
    : super(key: key);

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  Timer? _timer;
  int _seconds = 0;
  String? _voicePath;

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        _seconds = 0;
        _voicePath = path;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _seconds++;
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });
    if (_voicePath != null && File(_voicePath!).existsSync()) {
      widget.onVoiceRecorded(_voicePath!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isRecording
        ? Row(
            children: [
              Icon(Icons.mic, color: Colors.red),
              Text('Recording... $_seconds s'),
              IconButton(
                icon: Icon(Icons.stop, color: Colors.red),
                onPressed: _stopRecording,
              ),
            ],
          )
        : IconButton(
            icon: Icon(Icons.mic, color: Colors.grey[400]),
            onPressed: _startRecording,
          );
  }
}
