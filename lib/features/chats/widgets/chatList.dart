import 'package:dreamchat/common/widget/loader.dart';
import 'package:dreamchat/common/widget/mymessage_Card.dart';
import 'package:dreamchat/common/widget/sendermessage_card.dart';
import 'package:dreamchat/features/chats/controller/chat_controller.dart';
import 'package:dreamchat/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../info.dart';

class ChatList extends ConsumerStatefulWidget {
  final String reciverUserId;
  const ChatList({required this.reciverUserId, Key? key}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.reciverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timesent = DateFormat.Hm().format(messageData.sent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timesent,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timesent,
              );
            },
          );
        });
  }
}
