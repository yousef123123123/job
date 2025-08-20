part of 'stories_cubit.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<dynamic> stories;
  StoriesLoaded(this.stories);
}
