class Story {
  final String id;
  final String userId;
  final String mediaPath;
  final DateTime timestamp;
  final bool isViewed;

  Story({
    required this.id,
    required this.userId,
    required this.mediaPath,
    required this.timestamp,
    required this.isViewed,
  });
}
