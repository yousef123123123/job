import '../models/story_model.dart';
import '../sources/story_local_data_source.dart';

abstract class StoryRepository {
  List<StoryModel> getAllStories();
  Future<void> addStory(StoryModel story);
  Future<void> deleteStory(String id);
  StoryModel? getStory(String id);
}

class StoryRepositoryImpl implements StoryRepository {
  final StoryLocalDataSource localDataSource;

  StoryRepositoryImpl(this.localDataSource);

  @override
  List<StoryModel> getAllStories() => localDataSource.getAllStories();

  @override
  Future<void> addStory(StoryModel story) async =>
      await localDataSource.addStory(story);

  @override
  Future<void> deleteStory(String id) async =>
      await localDataSource.deleteStory(id);

  @override
  StoryModel? getStory(String id) => localDataSource.getStory(id);
}
