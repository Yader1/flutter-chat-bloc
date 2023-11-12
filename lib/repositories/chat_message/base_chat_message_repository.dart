import 'package:flutter_chat_bloc/models/models.dart';
import 'package:flutter_chat_bloc/models/requests/create_chat_message_request.dart';

abstract class BaseChatMessageRepository{
  Future<AppResponse<List<ChatMessageEntity>>> getChatMessage({
    required int chatId,
    required int page,
  });

  Future<AppResponse<ChatMessageEntity?>> createChatMessage(CreateChatMessageRequest request, String socketId);
}