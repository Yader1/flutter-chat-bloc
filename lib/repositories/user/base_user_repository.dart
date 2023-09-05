import 'package:flutter_chat_bloc/models/app_response.dart';
import 'package:flutter_chat_bloc/models/user_model.dart';

abstract class BaseUserRepository{
  Future<AppResponse<List<UserEntity>>> getUser();
}