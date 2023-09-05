import 'package:dio/dio.dart';
import 'package:flutter_chat_bloc/models/app_response.dart';
import 'package:flutter_chat_bloc/models/user_model.dart';
import 'package:flutter_chat_bloc/repositories/core/endpoints.dart';
import 'package:flutter_chat_bloc/repositories/user/base_user_repository.dart';
import 'package:flutter_chat_bloc/utils/dio_client/dio_client.dart';

class UserRepository extends BaseUserRepository{
  final Dio _dioClient;

  UserRepository({
    Dio? dioClient,
  }) : _dioClient = dioClient ?? DioClient().instance;

  @override
  Future<AppResponse<List<UserEntity>>> getUser() async {
    final response = await _dioClient.get(Endpoints.getUsers);

    return AppResponse<List<UserEntity>>.fromJson(
      response.data,
      (dynamic json){
        if(response.data['success'] && json != null){
          return (json as List<dynamic>).map((e) => UserEntity.fromJson(e)).toList();
        }

        return [];
      }
    );
  }
}