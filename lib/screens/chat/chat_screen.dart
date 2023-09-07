import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../utils/logger.dart';
import '../../widgets/startup_container.dart';
import 'data.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = "chat";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = basicSample;

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return StartUpContainer(
      onInit: () {
        chatBloc.add(const GetChatMessage());
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<ChatBloc, ChatState>(
            listener: (_, __) {},
            builder: (context, state) {
              return Text("Other user name");
            },
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return DashChat(
              currentUser: user,
              onSend: (ChatMessage chatMessage) {
                vLog("add new message to messages");
              },
              messages: messages,
              messageListOptions: MessageListOptions(onLoadEarlier: () async {
                await Future.delayed(const Duration(seconds: 3));
              }),
            );
          },
        ),
      ),
    );
  }
}
