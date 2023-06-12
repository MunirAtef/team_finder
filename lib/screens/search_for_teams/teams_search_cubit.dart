
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/models/join_request.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/shared/loading_box.dart';
import 'package:team_finder/shared/user_data.dart';

class TeamsSearchState {
  String? selectedCategory;
  List<TeamCardModel>? teamsCard;
  bool isLoading;

  TeamsSearchState({
    this.selectedCategory,
    this.teamsCard,
    this.isLoading = false
  });

  TeamsSearchState clone() {
    return TeamsSearchState(
      selectedCategory: selectedCategory,
      teamsCard: teamsCard,
      isLoading: isLoading
    );
  }
}

class TeamsSearchCubit extends Cubit<TeamsSearchState> {
  TeamsSearchCubit() : super(TeamsSearchState());

  TextEditingController searchController = TextEditingController();

  changeCategory(String? newValue) {
    state.selectedCategory = newValue;
    emit(state.clone());
  }


  Future<void> getTeams() async {
    state.isLoading = true;
    emit(state.clone());

    String searchWord = searchController.text.trim().toLowerCase();
    String category = state.selectedCategory ?? "All";

    List<TeamCardModel> teamsModel = [];

    CollectionReference teamsRef = FirebaseFirestore.instance.collection('teams');
    QuerySnapshot<Object?> teams = await teamsRef.orderBy("creationDate").get();

    for (QueryDocumentSnapshot<Object?> team in teams.docs) {
      TeamCardModel teamModel =
        TeamCardModel.fromJson(team.data() as Map<String, dynamic>);

      if (UserData.userModel.joinedTeams.contains(teamModel.id)) continue;
      if (!teamModel.teamName.toLowerCase().contains(searchWord)) continue;

      if (category == "All") {
        teamsModel.add(teamModel);
      } else if (category == "Other") {
        if (!categories.contains(teamModel.teamCategory)) {
          teamsModel.add(teamModel);
        }
      } else {
        if (category == teamModel.teamCategory) {
          teamsModel.add(teamModel);
        }
      }
    }

    state.teamsCard = teamsModel;
    state.isLoading = false;
    emit(state.clone());
  }


  Future<void> requestOrUndo(String adminId, String teamId, bool setRequest, context) async {
    await showLoading(
      context: context,
      title: setRequest? "SENDING REQUEST...": "UNDO REQUEST...",
      waitFor: () async {

        if (setRequest) {
          /// notify admin
          await RealtimeDatabase.setRequest(
            adminId: adminId,
            teamId: teamId,
            userId: UserData.uid
          );

          /// append to join requests
          await Firestore.appendToJoinRequests(
            request: JoinRequest(
              adminId: adminId,
              teamId: teamId,
              userId: UserData.uid
            )
          );

          UserData.joinRequestsID ??= [];
          UserData.joinRequestsID!.add(teamId);
          emit(state.clone());
          return;
        }

        /// delete request from admin requests
        await RealtimeDatabase.deleteRequest(
          adminId: adminId,
          teamId: teamId,
          userId: UserData.uid
        );

        /// delete request for join requests
        List<JoinRequest> joinRequests = [...UserData.userModel.joinRequests];
        joinRequests.removeWhere((element) => element.teamId == teamId);

        Firestore.updateJoinRequests(userId: UserData.uid, requests: joinRequests);

        UserData.userModel.joinRequests = joinRequests;
        UserData.joinRequestsID = joinRequests.map((e) => e.teamId).toList();
        emit(state.clone());
      }
    );

  }
}

