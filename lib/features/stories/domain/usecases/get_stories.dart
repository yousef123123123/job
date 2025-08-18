import '../../data/repositories/story_repository_impl.dart';
import '../entities/story.dart';

class GetStories {
  final StoryRepository repository;

  GetStories(this.repository);

  List<Story> call() {
    // تحويل StoryModel إلى Story إذا لزم الأمر
    return repository
        .getAllStories()
        .map(
          (storyModel) => Story(
            id: storyModel.id,
            userId: storyModel.userId,
            mediaPath: storyModel.mediaPath,
            timestamp: storyModel.timestamp,
            isViewed: storyModel.isViewed,
          ),
        )
        .toList();
  }
}
