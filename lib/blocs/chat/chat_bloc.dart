import 'package:bloc/bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_bloc/models/requests/requests.dart';
import 'package:flutter_chat_bloc/repositories/repositories.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/enums.dart';
import '../../models/models.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final ChatMessageRepository _chatMessageRepository;

  ChatBloc({
    required ChatRepository chatRepository,
    required ChatMessageRepository chatMessageRepository,
  }) : 
  _chatRepository = chatRepository, 
  _chatMessageRepository = chatMessageRepository, 
  super(ChatState.initial()) {  
    on<ChatEvent>((event, emit) async {
      if(state.status.isLoading) return;

      emit(state.copyWith(status : DataStatus.loading));

      final result = await _chatRepository.getChats();

      emit(state.copyWith(
        status: DataStatus.loaded,
        chats: result.success! ? result.data ?? [] : []
      ));
    });

    on<ChatReset>((event, emit){
      emit(state.copyWith(
        chatMessage: [],
        message: '',
        status: DataStatus.initial,
        selectedChat: null,
        otherUserId: null,
        isLastPage: false,
        page: 1,
        chats: (event.shouldResetChat != null && event.shouldResetChat!) ? [] : state.chats,
      ));
    });

    on<UserSelected>((event, emit){
      emit(state.copyWith(otherUserId: event.user.id));
    });

    on<GetChatMessage>((event, emit) async {
      if(state.status.isFetching) return;

      emit(state.copyWith(status: DataStatus.fetching));

      ChatEntity? chat;

      if(state.isSearchChat){
        final chatResult =  await _chatRepository.createChat(CreateChatRequest(userId: state.otherUserId!));

        if(chatResult.success!){
          chat = chatResult.data;
        }
      } else if(state.isListChat){
        chat = state.selectedChat;
      }

      if(chat == null){
        emit(state.copyWith(
          chatMessage: [],
          status: DataStatus.loaded
        ));

        return;
      }

      final result = await _chatMessageRepository.getChatMessage(chatId: chat.id, page: 1);

      if(result.success!){
        emit(state.copyWith(
          chatMessage: result.data ?? [],
          status: DataStatus.loaded,
          selectedChat: chat,
        ));
      } else {
        emit(state.copyWith(
          chatMessage: [],
          status: DataStatus.error,
          message: result.message,
        ));
      }
    });

    on<SendMessage>((event, emit) async {
      if(state.status.isSubmitting) return;
      emit(state.copyWith(status : DataStatus.submitting));

      final result = await _chatMessageRepository.createChatMessage(
        CreateChatMessageRequest(
          chatId: event.chatId, 
          message: event.message.text,
        )
      );

      if(result.success!){
        final messages = [result.data!, ...state.chatMessage];

        emit(
          state.copyWith(
            chatMessage: messages,
            status: DataStatus.loaded,
          )
        );
      }else{
        emit(
          state.copyWith(
            status: DataStatus.loaded,
          )
        );
      }
    });

    on<LoadMoreChatMessage>((event, emit) async {
      if(state.status.isLoadingMore || state.isLastPage) return;

      emit(state.copyWith(status: DataStatus.loadingMore));

      final newPage = state.page + 1;

      final result = await _chatMessageRepository.getChatMessage(chatId: state.selectedChat!.id, page: newPage);

      if(result.success!){
        final newMessages = result.data ?? [];

        if(newMessages.isNotEmpty){
          emit(state.copyWith(
            chatMessage: [...state.chatMessage,...newMessages],
            status: DataStatus.loaded,
            page: newPage
          ));
        } else {
          emit(state.copyWith(
            status: DataStatus.loaded,
            isLastPage: true
          ));
        }
      }else{
        emit(state.copyWith(
            message: result.message,
            status: DataStatus.error,
          ));
      }
    });

    on<ChatSelected>((event, emit) {
      emit(state.copyWith(selectedChat: event.chat));
    });
  }
}
