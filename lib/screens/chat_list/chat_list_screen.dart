import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bloc/blocs/chat/chat_bloc.dart';
import 'package:flutter_chat_bloc/cubits/cubits.dart';
import 'package:flutter_chat_bloc/screens/screens.dart';
import 'package:flutter_chat_bloc/widgets/widgets.dart';

import '../../blocs/blocs.dart';
import '../../utils/utils.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static const routeName = "chat-list";

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final currentUser = authBloc.state.user!;
    final chatBloc = context.read<ChatBloc>();

    //eLog(authState);
    return StartUpContainer(
      onInit: () async {
        chatBloc.add(const ChatStarted());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ChatList"),
              Text("User ID ${currentUser.email}",
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w400)),
            ],
          ),
          actions: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (!state.isAuthenticated) {
                  Navigator.of(context)
                      .pushReplacementNamed(GuestScreen.routeName);
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
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (_, __) {},
          builder: (context, state) {
            if(state.chats.isEmpty){
              return const BlankContent(
                content: "No chat available",
                icon: Icons.chat_rounded,
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                return Text("Hola");
              },
              separatorBuilder: (_, __) => const Divider(height: 1.5),
              itemCount: state.chats.length
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            eLog("Show search user");
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
