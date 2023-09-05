import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat_bloc/repositories/repositories.dart';

import '../../models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository, super(const Initial()) {
    on<UserStarted>((event, emit) async {
      final result = await _userRepository.getUser();

      emit(Loaded(result.data ?? []));
    });
  }
}
