import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../utils/logger.dart';
import '../../utils/utils.dart';
import '../../widgets/startup_container.dart';
import 'data.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = "chat";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //List<ChatMessage> messages = basicSample;

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    final authBloc = context.read<AuthBloc>();

    return StartUpContainer(
      onInit: () {
        chatBloc.add(const GetChatMessage());
      },
      onDisposed: (){
        chatBloc.add(const ChatReset());
        chatBloc.add(const ChatStarted());
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<ChatBloc, ChatState>(
            listener: (_, __) {},
            builder: (context, state) {
              final chat = state.selectedChat;

              return Text(
                chat == null ?
                "N/A" :
                getChatName(chat.participants, authBloc.state.user!),
              );
            },
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return DashChat(
              currentUser: authBloc.state.user!.toChatUser,
              onSend: (ChatMessage chatMessage) {
                chatBloc.add(SendMessage(
                  state.selectedChat!.id,
                  chatMessage
                ));
              },
              messages: state.uiChatMessage,
              messageListOptions: MessageListOptions(onLoadEarlier: () async {
                chatBloc.add(const LoadMoreChatMessage());
                //await Future.delayed(const Duration(seconds: 3));
              }),
            );
          },
        ),
      ),
    );
  }
}
