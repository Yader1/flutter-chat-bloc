import 'package:flutter_chat_bloc/models/models.dart';
import 'package:flutter_chat_bloc/models/requests/requests.dart';

abstract class BaseAuthRepository{
  Future<AppResponse<AuthUser?>> register(RegisterRequest request);

  Future<AppResponse<AuthUser?>> login(LoginRequest request);

  Future<AppResponse<UserEntity?>> loginWithToken();

  Future<AppResponse> logout();
}