import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_state.dart';
part 'guest_cubit.freezed.dart';

class GuestCubit extends Cubit<GuestState> {
  GuestCubit() : super(GuestState.initial());
}
