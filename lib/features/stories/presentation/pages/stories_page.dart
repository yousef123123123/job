import '../../../../core/localization/app_localizations.dart';
import 'package:hive/hive.dart';
import '../../data/sources/story_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late StoryLocalDataSource _localDataSource;

  @override
  void initState() {
    super.initState();
    _localDataSource = StoryLocalDataSource(Hive.box<StoryModel>('storiesBox'));
    final hiveStories = _localDataSource.getAllStories();
    if (hiveStories.isEmpty && widget.stories.isNotEmpty) {
      for (final story in widget.stories) {
        _localDataSource.addStory(story);
      }
      _stories = List<StoryModel>.from(widget.stories);
    } else {
      _stories = hiveStories;
    }
  }

  Future<void> _addStory(String type) async {
    final picker = ImagePicker();
    XFile? picked;
    if (type == 'image') {
      picked = await picker.pickImage(source: ImageSource.gallery);
    } else if (type == 'video') {
      picked = await picker.pickVideo(source: ImageSource.gallery);
    }
    if (picked != null) {
      final story = StoryModel(
        name: 'Yousef Jo',
        id: 'story${DateTime.now().millisecondsSinceEpoch}',
        userId: 'Yousef',
        mediaPath: picked.path,
        timestamp: DateTime.now(),
        isViewed: false,
        mediaType: type,
      );
      await _localDataSource.addStory(story);
      setState(() {
        _stories = [
          story,
          ..._localDataSource.getAllStories().where((s) => s.id != story.id),
        ];
      });
    }
  }

  void _viewStory(StoryModel story) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Image.file(File(story.mediaPath), fit: BoxFit.contain),
      
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
            AppLocalizations.of(context)?.storiesTitle ?? 'Stories',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.add_a_photo, color: Colors.white),
              onPressed: () => _addStory('image'),
            ),
          ],
        ),
        body: StoriesBody(
          stories: _stories,
          onViewStory: _viewStory,
          onAddStory: (type, path) async {
            final story = StoryModel(
              name: 'Yousef',
              id: 'story${DateTime.now().millisecondsSinceEpoch}',
              userId: 'Yousef',
              mediaPath: path,
              timestamp: DateTime.now(),
              isViewed: false,
              mediaType: type,
            );
            await _localDataSource.addStory(story);
            setState(() {
              _stories = [
                story,
                ..._localDataSource.getAllStories().where(
                  (s) => s.id != story.id,
                ),
              ];
            });
          },
        ),
      ),
    );
  }
}
