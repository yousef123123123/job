import 'package:flutter/material.dart';
import '../../data/models/story_model.dart';
import 'dart:io';

class StoryViewerPage extends StatefulWidget {
  final StoryModel story;
  const StoryViewerPage({required this.story, Key? key}) : super(key: key);

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  @override
  void initState() {
    super.initState();
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
        child: widget.story.mediaPath.startsWith('http')
            ? Image.network(
                widget.story.mediaPath,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (c, e, s) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.white, size: 64),
                    SizedBox(height: 12),
                    Text(
                      'تعذر تحميل الصورة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            : Image.file(
                File(widget.story.mediaPath),
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.white, size: 64),
                    SizedBox(height: 12),
                    Text(
                      'تعذر تحميل الصورة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
