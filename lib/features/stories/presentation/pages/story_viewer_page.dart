import 'package:flutter/material.dart';
import '../../data/models/story_model.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class StoryViewerPage extends StatefulWidget {
  final StoryModel story;
  const StoryViewerPage({required this.story, Key? key}) : super(key: key);

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.story.mediaType == 'video';
    if (_isVideo) {
      if (widget.story.mediaPath.startsWith('http')) {
        _videoController = VideoPlayerController.network(widget.story.mediaPath)
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play();
          });
      } else {
        _videoController =
            VideoPlayerController.file(File(widget.story.mediaPath))
              ..initialize().then((_) {
                setState(() {});
                _videoController?.play();
              });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.story.userId, style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _isVideo
            ? (_videoController != null && _videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : CircularProgressIndicator(color: Colors.white))
            : (widget.story.mediaPath.startsWith('http')
                  ? Image.network(
                      widget.story.mediaPath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    )
                  : Image.file(
                      File(widget.story.mediaPath),
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    )),
      ),
    );
  }
}
