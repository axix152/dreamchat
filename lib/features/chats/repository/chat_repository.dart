import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamchat/common/enums/message_enum.dart';
import 'package:dreamchat/common/widget/util.dart';
import 'package:dreamchat/models/chat_contact.dart';
import 'package:dreamchat/models/message_model.dart';
import 'package:dreamchat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timesend', descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contact = [];
      for (var documnet in event.docs) {
        var chatContact = ChatContact.fromMap(documnet.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contact.add(
          ChatContact(
            name: user.name,
            profilepic: user.profilePic,
            contactId: chatContact.contactId,
            timesend: chatContact.timesend,
            lastmessage: chatContact.lastmessage,
          ),
        );
      }
      return contact;
    });
  }

  Stream<List<MessageModel>> getChatStream(String recvierUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recvierUserId)
        .collection('messages')
        .orderBy('sent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var documnet in event.docs) {
        messages.add(MessageModel.fromMap(documnet.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel reciverUserData,
    String text,
    DateTime timesent,
    String reciverUserId,
  ) async {
    // users -> reciver user id => chats -> current user id -> set data
    var reciverChatContact = ChatContact(
      name: senderUserData.name,
      profilepic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timesend: timesent,
      lastmessage: text,
    );

    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          reciverChatContact.toMap(),
        );
    // users  -> current user id => chats -> chats -> reciver user id  -> set data

    var senderChatContact = ChatContact(
      name: reciverUserData.name,
      profilepic: reciverUserData.profilePic,
      contactId: reciverUserData.uid,
      timesend: timesent,
      lastmessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String reciverUserId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String username,
    required String reciverUserName,
    required MessageEnum messagetype,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      reciverId: reciverUserId,
      text: text,
      type: messagetype,
      sent: timesent,
      messageId: messageId,
      isSeen: false,
    );

    // users -> sender Id -> recvier id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    // users -> recvier Id -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String reciverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timesend = DateTime.now();
      UserModel reciverUserData;
      var userDataMap =
          await firestore.collection('users').doc(reciverUserId).get();

      reciverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
        senderUser,
        reciverUserData,
        text,
        timesend,
        reciverUserId,
      );

      _saveMessageToMessageSubcollection(
        reciverUserId: reciverUserId,
        text: text,
        timesent: timesend,
        messagetype: MessageEnum.text,
        messageId: messageId,
        reciverUserName: reciverUserData.name,
        username: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
