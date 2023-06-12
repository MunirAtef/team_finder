

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/shared/user_data.dart';

class TeamPageState {}


class TeamPageCubit extends Cubit<TeamPageState> {
  TeamPageCubit(): super(TeamPageState());

  late Timer timer;

  void setOnline() {
    DatabaseReference ref
    = FirebaseDatabase.instance.ref("teams/{team.id}/lastOpened/${UserData.uid}");

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int timestamp = Timestamp.now().millisecondsSinceEpoch;
      ref.set(timestamp);
      // team.lastOpenedTime = timestamp;
    });
  }

  void cancelTimer() => timer.cancel();
}