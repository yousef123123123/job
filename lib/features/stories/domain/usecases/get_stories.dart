import '../../data/repositories/story_repository_impl.dart';
import '../entities/story.dart';

class GetStories {
  final StoryRepository repository;

  GetStories(this.repository);

  List<Story> call() {
    return repository
        .getAllStories()
        .map(
          (storyModel) => Story(
            name: storyModel.name,
            id: storyModel.id,
            userId: storyModel.userId,
            mediaPath: storyModel.mediaPath,
            timestamp: storyModel.timestamp,
            isViewed: storyModel.isViewed,
            mediaType: storyModel.mediaType, // أضف هذا السطر
          ),
        )
        .toList();
  }
}
