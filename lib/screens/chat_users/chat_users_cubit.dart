
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/message_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/shared/user_data.dart';

class ChatUsersState {
  List<MessageModel> messages;
  bool sendingMessage;

  ChatUsersState({
    this.messages = const [],
    this.sendingMessage = false
  });

  ChatUsersState clone() => ChatUsersState(
    messages: messages,
    sendingMessage: sendingMessage
  );
}


class ChatUsersCubit extends Cubit<ChatUsersState> {
  ChatUsersCubit(): super(ChatUsersState());
  static UserModel? userModel;
  static Contact? contact;

  TextEditingController chatController = TextEditingController();

  static StreamController<int> messagesController = StreamController();
  static StreamSubscription<int>? listener;

  late String firstId;
  late String secondId;

  void setInitial(Contact contact) {
    state.messages = [];

    ChatUsersCubit.contact = contact;
    ChatUsersCubit.userModel = contact.user;

    firstId = UserData.uid;
    secondId = userModel!.id;

    if (firstId.compareTo(secondId) < 0) {
      firstId = userModel!.id;
      secondId = UserData.uid;
    }

    getMessages();

    listener ??= messagesController.stream.listen((event) async {
      await getMessagesAfterLastSeen();
    });

    if (listener != null && listener!.isPaused) listener!.resume();
  }

  Future<void> getMessages() async {
    CollectionReference<Map<String, dynamic>> collection
      = FirebaseFirestore.instance.collection("users_chat")
        .doc(firstId).collection(secondId);

    QuerySnapshot<Map<String, dynamic>> messages
      = await collection.orderBy("timestamp", descending: true).get();

    await deleteIncoming();
    UserData.incomingChats.remove(userModel?.id);

    state.messages = messages.docs.map((e) => MessageModel.fromJson(e.data())).toList();
    emit(state.clone());
  }

  Future<void> getMessagesAfterLastSeen() async {
    CollectionReference<Map<String, dynamic>> collection
    = FirebaseFirestore.instance.collection("users_chat")
        .doc(firstId).collection(secondId);

    QuerySnapshot<Map<String, dynamic>> messages
    = await collection.where("timestamp", isGreaterThan: state.messages.first.timestamp)
        .orderBy("timestamp", descending: true).get();

    await deleteIncoming();
    UserData.incomingChats.remove(userModel?.id);
    
    List<MessageModel> newMessages =
      messages.docs.map((e) => MessageModel.fromJson(e.data())).toList();

    contact!.lastMessageTime = newMessages.first.timestamp;
    state.messages.insertAll(0, newMessages);
    emit(state.clone());
  }


  Future<void> send() async {
    String content = chatController.text.trim();
    if (content == "") return;

    state.sendingMessage = true;
    emit(state.clone());

    int timestamp = Timestamp.now().millisecondsSinceEpoch;
    MessageModel message = MessageModel(
      content: content,
      senderId: UserData.uid,
      sourceId: "_",
      timestamp: timestamp
    );

    await FirebaseFirestore.instance.collection("users_chat")
      .doc(firstId).collection(secondId).doc().set(message.toJson());

    await RealtimeDatabase.notifyUserWithMessage(userId: userModel!.id, value: timestamp);

    FirebaseFirestore.instance.collection("users_contacts")
      .doc(firstId).update({secondId: timestamp});
    FirebaseFirestore.instance.collection("users_contacts")
      .doc(secondId).update({firstId: timestamp});

    contact!.lastMessageTime = timestamp;

    emit(ChatUsersState(
      messages: state.messages..insert(0, message),
      sendingMessage: false
    ));

    chatController.clear();
  }

  Future<void> deleteIncoming() async {
    await RealtimeDatabase.deleteChatNotification(userId: userModel!.id);
  }

  static void openProfile(UserModel? userModel, BuildContext context) {
    if (userModel == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfile(
          userModel: userModel
        )
      )
    );
  }
}


