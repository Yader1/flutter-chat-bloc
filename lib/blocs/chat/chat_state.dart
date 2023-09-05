part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required List<ChatEntity> chats,
    ChatEntity? selectedChat,
    required DataStatus status,
    required String message,
  }) = _ChatState;

  factory ChatState.initial(){
    return const ChatState(
      chats: [], 
      selectedChat: null,
      status: DataStatus.initial,
      message: ""
    );
  }
}
