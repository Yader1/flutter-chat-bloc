import 'package:dio/dio.dart';
import 'package:flutter_chat_bloc/models/app_response.dart';
import 'package:flutter_chat_bloc/models/chat_message_model.dart';
import 'package:flutter_chat_bloc/models/requests/create_chat_message_request.dart';
import 'package:flutter_chat_bloc/repositories/core/endpoints.dart';

import '../../utils/utils.dart';
import 'base_chat_message_repository.dart';

class ChatMessageRepository extends BaseChatMessageRepository{
  final Dio _dioClient;

  ChatMessageRepository({
    Dio? dioClient,
  }) : _dioClient = dioClient ?? DioClient().instance;

  @override
  Future<AppResponse<ChatMessageEntity?>> createChatMessage(CreateChatMessageRequest request, String socketId) async {
    final response = await _dioClient.post(
      Endpoints.createChatMessage,
      data: request.toJson(),
      options: Options(
        headers: {
          'X-Socket-ID' : socketId
        }
      )
    );

    return AppResponse<ChatMessageEntity?>.fromJson(
      response.data, 
      (dynamic json) => response.data['success'] && json != null
      ? ChatMessageEntity.fromJson(json)
      : null 
    );
  }

  @override
  Future<AppResponse<List<ChatMessageEntity>>> getChatMessage({required int chatId, required int page}) async {
    final response = await _dioClient.get(
      Endpoints.getChatMessages,
      queryParameters: {
        'page' : page,
        'chat_id' : chatId,
      }
    );

    return AppResponse<List<ChatMessageEntity>>.fromJson(
      response.data, 
      (dynamic json) => response.data['success'] && json != null
      ? (json as List<dynamic>).map((e) => ChatMessageEntity.fromJson(e)).toList()
      : []
    );
  }
}