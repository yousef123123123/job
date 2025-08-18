class Story {
  final String id;
  final String userId;
  final String name;
  final String mediaPath;
  final DateTime timestamp;
  final bool isViewed;
  final String mediaType;

  Story({
    required this.id,
    required this.userId,
    required this.name,
    required this.mediaPath,
    required this.timestamp,
    required this.isViewed,
    required this.mediaType,
  });
}
