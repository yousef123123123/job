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
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF222E35),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Color(0xFF25D366), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic, color: Colors.white, size: 28),
                ),
                SizedBox(width: 12),
                // موجة صوتية وهمية (يمكن استبدالها بموجة حقيقية لاحقاً)
                Container(
                  width: 60,
                  height: 24,
                  child: CustomPaint(painter: _FakeWavePainter()),
                ),
                SizedBox(width: 12),
                Text(
                  _formatDuration(_seconds),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF25D366)),
                  onPressed: _stopRecording,
                ),
              ],
            ),
          )
        : IconButton(
            icon: Icon(Icons.mic, color: Color(0xFF25D366), size: 32),
            onPressed: _startRecording,
          );
  }

  String _formatDuration(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}

class _FakeWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF25D366)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(0, size.height / 2);
    for (double i = 0; i < size.width; i += 8) {
      path.lineTo(i, size.height / 2 + 8 * (i % 2 == 0 ? 1 : -1));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
