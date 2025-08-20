part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<dynamic> chats;
  ChatLoaded(this.chats);
}
