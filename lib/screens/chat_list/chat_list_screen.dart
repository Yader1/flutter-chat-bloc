import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bloc/cubits/cubits.dart';
import 'package:flutter_chat_bloc/screens/screens.dart';

import '../../blocs/blocs.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static const routeName = "chat-list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatList"),
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(!state.isAuthenticated){
                Navigator.of(context).pushReplacementNamed(GuestScreen.routeName);
              }
            },
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    context.read<GuestCubit>().signOut();
                  },
                  icon: const Icon(Icons.logout));
            },
          )
        ],
      ),
    );
  }
}
