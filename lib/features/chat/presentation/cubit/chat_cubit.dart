import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/get_chats.dart';

class ChatState {
  final List<Chat> chats;
  final bool loading;
  ChatState({required this.chats, this.loading = false});
}

class ChatCubit extends Cubit<ChatState> {
  final GetChats getChats;
  ChatCubit(this.getChats) : super(ChatState(chats: [], loading: true));

  void loadChats() {
    emit(ChatState(chats: [], loading: true));
    final chats = getChats();
    emit(ChatState(chats: chats, loading: false));
  }
}
