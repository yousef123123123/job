import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/story_model.dart';
part 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  StoriesCubit() : super(StoriesInitial());

  void loadStories(List<StoryModel> stories) {
    emit(StoriesLoaded(stories));
  }
}
