import 'package:hive/hive.dart';
part 'story_model.g.dart';

@HiveType(typeId: 3)
class StoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String mediaPath;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isViewed;

  @HiveField(5)
  final String name;
  @HiveField(6)
  final String mediaType; // 'image' or 'video'

  StoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.mediaPath,
    required this.timestamp,
    required this.isViewed,
    required this.mediaType,
  });
}
