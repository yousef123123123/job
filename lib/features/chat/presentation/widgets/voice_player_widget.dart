import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class VoicePlayerWidget extends StatefulWidget {
  final String voicePath;
  final DateTime? timestamp;
  const VoicePlayerWidget({required this.voicePath, this.timestamp, Key? key})
    : super(key: key);

  @override
  State<VoicePlayerWidget> createState() => _VoicePlayerWidgetState();
}

class _VoicePlayerWidgetState extends State<VoicePlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration? _voiceDuration;
  bool _durationLoaded = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initDuration();
    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  Future<void> _initDuration() async {
    try {
      await _player.setFilePath(widget.voicePath);
      setState(() {
        _voiceDuration = _player.duration;
        _durationLoaded = true;
      });
      await _player.stop();
    } catch (_) {}
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            'https://scontent.fcai30-1.fna.fbcdn.net/v/t39.30808-6/347413470_6382903195124063_7282368361415306080_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=ctZoHexm8gEQ7kNvwEgi5mL&_nc_oc=AdkjOhXXgfg-af6PbwjwOVJlRmw2tOWBkIhLn7lMoUoXIM0J1hoVsz55mjBlIN8GbEY&_nc_zt=23&_nc_ht=scontent.fcai30-1.fna&_nc_gid=Cj5hSKW172W253oUUB6QvQ&oh=00_AfXEPL9mU-TzyR_ybmtkOODnw4NyI5LOavCqGYoUfbpR3Q&oe=68AAB343',
          ),
          backgroundColor: Colors.white,
        ),
        SizedBox(width: 4),
        Container(
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: const Color.fromARGB(255, 128, 127, 127),
              size: 28,
            ),
            onPressed: _isPlaying ? _stop : _play,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 32,
            alignment: Alignment.centerLeft,
            child: CustomPaint(painter: _FakeWavePainter(), size: Size(90, 32)),
          ),
        ),
        SizedBox(width: 8),
        Text(
          (_durationLoaded && _voiceDuration != null
              ? _formatDuration(_voiceDuration!)
              : '--:--'),
    
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final min = duration.inMinutes.toString().padLeft(2, '0');
    final sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}

class _FakeWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 122, 122, 122)
      ..strokeWidth = 2
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
