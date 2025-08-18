import 'package:hive/hive.dart';
import '../models/story_model.dart';

class StoryLocalDataSource {
  final Box<StoryModel> storyBox;

  StoryLocalDataSource(this.storyBox);

  List<StoryModel> getAllStories() => storyBox.values.toList();

  Future<void> addStory(StoryModel story) async =>
      await storyBox.put(story.id, story);

  Future<void> deleteStory(String id) async => await storyBox.delete(id);

  StoryModel? getStory(String id) => storyBox.get(id);
}
