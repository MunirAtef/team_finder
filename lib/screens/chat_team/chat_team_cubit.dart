

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/models/message_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/shared/user_data.dart';


class ChatTeamState {
  List<MessageModel> messages;
  bool isLoading;

  ChatTeamState({this.messages = const [], this.isLoading = false});

  ChatTeamState clone() => ChatTeamState(messages: messages, isLoading: isLoading);
}


class ChatTeamCubit extends Cubit<ChatTeamState> {
  late TeamCardModel team;
  TextEditingController chatController = TextEditingController();

  ChatTeamCubit(): super(ChatTeamState());


  void setInitial(TeamCardModel team) {
    this.team = team;
    chatController.clear();
    getMessages();
  }


  Future<void> getMessages() async {
    CollectionReference<Map<String, dynamic>> collection
      = FirebaseFirestore.instance.collection("teams_data")
        .doc(team.id).collection("messages");

    QuerySnapshot<Map<String, dynamic>> messages
      = await collection.orderBy("timestamp", descending: true).get();

    state.messages = messages.docs.map((e) => MessageModel.fromJson(e.data())).toList();
    emit(state.clone());

    if (team.lastMessageTime > team.lastSeenMessage) {
      setLastSeenMessage(team.lastMessageTime);
    }
  }

  Future<void> getMessagesAfterLastSeen() async {
    CollectionReference<Map<String, dynamic>> collection
    = FirebaseFirestore.instance.collection("teams_data")
        .doc(team.id).collection("messages");


    QuerySnapshot<Map<String, dynamic>> messages
    = await collection.where("timestamp", isGreaterThan: team.lastSeenMessage)
        .orderBy("timestamp", descending: true).get();

    List<MessageModel> messagesModel
      = messages.docs.map((e) => MessageModel.fromJson(e.data())).toList();

    if (messagesModel.isEmpty) return;

    state.messages.insertAll(0, messagesModel);

    emit(state.clone());
    setLastSeenMessage(messagesModel[0].timestamp);
  }

  Future<void> send() async {
    String content = chatController.text.trim();
    if (content == "") return;

    state.isLoading = true;
    emit(state.clone());

    int timestamp = Timestamp.now().millisecondsSinceEpoch;
    MessageModel message = MessageModel(
      content: content,
      senderId: UserData.uid,
      sourceId: team.id,
      timestamp: timestamp
    );

    FirebaseFirestore.instance.collection("teams_data")
      .doc(team.id).collection("messages").doc().set(message.toJson());

    await RealtimeDatabase.setLastSentMessage(teamId: team.id, value: timestamp);
    await setLastSeenMessage(timestamp);
    state.isLoading = false;
    emit(state.clone());

    chatController.clear();
  }

  Future<void> setLastSeenMessage(int value) async {
    team.lastSeenMessage = value;
    team.lastMessageTime = value;

    await RealtimeDatabase.setLastOpened(
      userId: UserData.uid,
      teamId: team.id,
      value: value,
    );
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

