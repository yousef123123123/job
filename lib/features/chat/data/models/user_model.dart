import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String avatarPath;
  @HiveField(3)
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.isOnline,
  });
}
