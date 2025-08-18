import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../data/models/story_model.dart';
import 'stories_body.dart';

class StoriesPage extends StatefulWidget {
  final List<StoryModel> stories;
  const StoriesPage({required this.stories, super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  List<StoryModel> _stories = [];

  @override
  void initState() {
    super.initState();
    _stories = List.from(widget.stories);
  }

  Future<void> _addStory(String type) async {
    final picker = ImagePicker();
    XFile? picked;
    if (type == 'image') {
      picked = await picker.pickImage(source: ImageSource.gallery);
    } else {
      picked = await picker.pickVideo(source: ImageSource.gallery);
    }
    if (picked != null) {
      setState(() {
        _stories.insert(
          0,
          StoryModel(
            id: 'story${_stories.length + 1}',
            userId: 'me',
            mediaPath: picked?.path ?? '',
            timestamp: DateTime.now(),
            isViewed: false,
            mediaType: type,
          ),
        );
      });
    }
  }

  void _viewStory(StoryModel story) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          child: story.mediaType == 'image'
              ? Image.file(File(story.mediaPath), fit: BoxFit.contain)
              : _VideoStoryPlayer(url: story.mediaPath),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111B21),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(
            'Stories',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.add_a_photo, color: Colors.white),
              onPressed: () => _addStory('image'),
            ),
            IconButton(
              icon: Icon(Icons.videocam, color: Colors.white),
              onPressed: () => _addStory('video'),
            ),
          ],
        ),
        body: StoriesBody(stories: _stories, onViewStory: _viewStory),
      ),
    );
  }
}

class _VideoStoryPlayer extends StatefulWidget {
  final String url;
  const _VideoStoryPlayer({required this.url});
  @override
  State<_VideoStoryPlayer> createState() => _VideoStoryPlayerState();
}

class _VideoStoryPlayerState extends State<_VideoStoryPlayer> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
