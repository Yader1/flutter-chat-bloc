import 'package:bloc/bloc.dart';
import 'package:flutter_chat_bloc/repositories/repositories.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/enums.dart';
import '../../models/models.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository, super(ChatState.initial()) {
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
      emit(ChatState.initial());
    });
  }
}
