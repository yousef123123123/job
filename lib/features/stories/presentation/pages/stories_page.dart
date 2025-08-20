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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarBg = isDark ? Color(0xFF1F2C34) : Color(0xFF075E54);
    final iconColor = isDark ? Color(0xFFB6C2CB) : Colors.white;
    final titleColor = isDark ? Color(0xFFE9EDEF) : Colors.white;
    return Container(
      color: isDark ? Color(0xFF111B21) : Color(0xFFF0F0F0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: appBarBg,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)?.storiesTitle ?? 'Updates',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_a_photo, color: iconColor),
              onPressed: () => _addStory('image'),
              tooltip: 'Add Story',
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
