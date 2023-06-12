
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_team/chat_team_cubit.dart';
import 'package:team_finder/screens/chat_users/chat_users_cubit.dart';
import 'package:team_finder/screens/private_chats/private_chat_cubit.dart';
import 'package:team_finder/screens/private_chats/private_chats_ui.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/shared/user_data.dart';


class HomePageState {
  bool isLoading;
  bool privateChat;
  List<TeamCardModel> teamsCard;

  HomePageState({
    this.isLoading = false,
    this.privateChat = false,
    this.teamsCard = const []
  });

  HomePageState clone() {
    return HomePageState(
      isLoading: isLoading,
      privateChat: privateChat,
      teamsCard: teamsCard
    );
  }
}

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(): super(HomePageState());

  static bool isInitialize = false;
  static bool playSound = false;
  static bool playRequestsSound = true;

  StreamSubscription<db.DatabaseEvent>? chatListener;
  StreamSubscription<db.DatabaseEvent>? acceptanceListener;
  StreamSubscription<db.DatabaseEvent>? requestsListener;

  List<StreamSubscription<db.DatabaseEvent>> teamsListeners = [];
  int numberOfTeams = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playActive() async =>
    await audioPlayer.play(AssetSource("sound/active_chat_sound.mp3"));

  Future<void> playNotActive() async =>
    await audioPlayer.play(AssetSource("sound/iphone_notification.mp3"));

  late BuildContext context;

  void setInitial(BuildContext context) {
    this.context = context;
    if (isInitialize) return;
    isInitialize = true;

    getTeams();
    setChatListener();
    setAcceptanceListeners();
    setRequestsListeners();

    Future.delayed(const Duration(seconds: 3), () { playSound = true; });
  }

  void update() => emit(state.clone());


  void setChatListener() {
    bool isFirstLoading = true;
    PrivateChatCubit contactsScreenCubit = BlocProvider.of<PrivateChatCubit>(context);

    db.DatabaseReference ref = db.FirebaseDatabase.instance
        .ref(RealtimePaths.incomingChat(UserData.uid));

    chatListener = ref.onValue.listen((event) async {
      Iterable<db.DataSnapshot> children = event.snapshot.children;

      int len = children.length;
      if (isFirstLoading && len == 0) isFirstLoading = false;

      state.privateChat = len != 0;
      emit(state.clone());

      Map<String, int> tempMap = {};

      bool launch = false;

      for (int i = 0; i < len; i++) {
        String key = "${children.elementAt(i).key}";
        int? value = children.elementAt(i).value as int?;
        if (value == null) continue;
        tempMap[key] = value;

        if (UserData.incomingChats[key] != value) launch = true;

        UserData.incomingChats[key] = value;

        if (ChatUsersCubit.userModel != null && ChatUsersCubit.userModel!.id == key) {
          ChatUsersCubit.messagesController.add(value);
          await playActive();
        }
      }

      UserData.incomingChats = tempMap;

      if (ChatUsersCubit.userModel == null && launch) {
        if (PrivateChatCubit.isActive) contactsScreenCubit.updateContacts();
        isFirstLoading? isFirstLoading = false: await playNotActive();
      }
    });
  }

  void setAcceptanceListeners() {
    db.DatabaseReference ref
      = db.FirebaseDatabase.instance.ref(RealtimePaths.incomingAcceptance(UserData.uid));

    acceptanceListener = ref.onChildAdded.listen((event) {
      String? teamId = event.snapshot.key;
      if (teamId == null) return;
      UserData.acceptance.add(teamId);

      if (playSound) playNotActive();
    });
  }

  void setRequestsListeners() {
    db.DatabaseReference ref
    = db.FirebaseDatabase.instance.ref(RealtimePaths.incomingRequests(UserData.uid));

    requestsListener = ref.onValue.listen((event) {
      Iterable<db.DataSnapshot> children = event.snapshot.children;
      UserData.requests = {};

      for (int i = 0; i < children.length; i++) {
        String key = "${children.elementAt(i).key}";
        UserData.requests[key] = children.elementAt(i).value;
      }

      if (playSound && playRequestsSound) playNotActive();
    });
  }


  void sortAndUpdate() {
    if (state.teamsCard.length < numberOfTeams) return;

    List<TeamCardModel> teams = List.from(state.teamsCard);

    sortTeams(teams);
    state.teamsCard = teams;
    update();
  }


  Future<void> getTeams() async {
    emit(HomePageState(isLoading: true));
    disposeListeners();

    List<String> teamsId = UserData.userModel.joinedTeams;
    numberOfTeams = teamsId.length;

    CollectionReference<Map<String, dynamic>> collection
    = FirebaseFirestore.instance.collection("teams");

    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents;
    try {
      documents = (await collection.where("id", whereIn: teamsId).get()).docs;
    } catch(e) {
      documents = [];
    }

    List<TeamCardModel> teams = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
      TeamCardModel team = TeamCardModel.fromJson(document.data());
      teams.add(team);
      await addTeamListener(team);
    }

    sortTeams(teams);
    state.teamsCard = teams;
    state.isLoading = false;
    update();
  }

  void sortTeams(List<TeamCardModel> teams) {
    teams.sort((team1, team2) =>
        team2.lastMessageTime.compareTo(team1.lastMessageTime));
  }

  Future<void> addTeamListener(TeamCardModel team) async {
    bool playSound = false;

    db.DatabaseReference ref
    = db.FirebaseDatabase.instance.ref("teams/${team.id}");

    db.DatabaseEvent result = await ref.child("lastSeenMessage/${UserData.uid}").once();
    team.lastSeenMessage = (result.snapshot.value ?? 0) as int;

    db.DatabaseReference lastMessageRef = ref.child("lastMessage");
    await lastMessageRef.keepSynced(true);

    StreamSubscription<db.DatabaseEvent> listener =
    lastMessageRef.onValue.listen((db.DatabaseEvent event) async {
      team.lastMessageTime = (event.snapshot.value ?? 0) as int;

      if (team.id == RoutesHolderCubit.activeTeam) {
        BlocProvider.of<ChatTeamCubit>(context).getMessagesAfterLastSeen();
        await playActive();
      } else {
        if (playSound) {
          await playNotActive();
        }
        playSound = true;
      }

      sortAndUpdate();
    });

    teamsListeners.add(listener);
  }

  Future<void> disposeListeners() async {
    for (StreamSubscription<db.DatabaseEvent> listener in teamsListeners) {
      listener.cancel();
    }
  }

  Future<void> onRefresh() async {
    UserModel? user = await Firestore.getUserById(userId: UserData.uid);
    if (user == null) return;
    UserData.userModel = user;
    await getTeams();
    update();
  }

  void openPrivateChats() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivateChats())
    );
  }
}


