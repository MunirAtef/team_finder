
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/join_request.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/shared/loading_box.dart';
import 'package:team_finder/shared/user_data.dart';

class NotificationRequestModel {
  UserModel userModel;
  TeamCardModel teamModel;

  NotificationRequestModel({
    required this.userModel,
    required this.teamModel
  });
}


class RequestsState {
  bool isLoading = false;
  List<JoinRequest> requestsModel;

  RequestsState({
    this.requestsModel = const [],
    this.isLoading = false
  });
}


class RequestCubit extends Cubit<RequestsState> {
  RequestCubit(): super(RequestsState()) {
    getAllRequests();
  }

  Future<void> getAllRequests() async {
    emit(RequestsState(isLoading: false));

    Map<String, dynamic> requests = UserData.requests;
    List<JoinRequest> joinRequests = [];

    for (String team in requests.keys) {
      for (String user in requests[team].keys) {
        joinRequests.add(JoinRequest(
          userId: user,
          adminId: UserData.uid,
          teamId: team
        ));
      }
    }

    emit(RequestsState(requestsModel: joinRequests));
  }


  Future<void> acceptUser(BuildContext context, JoinRequest joinRequest) async {
    HomePageCubit.playRequestsSound = false;

    showLoading(
      context: context,
      title: "ACCEPTING USER...",
      waitFor: () async {
        /// delete request in realtime database requests
        await RealtimeDatabase.deleteRequest(
          adminId: UserData.uid,
          teamId: joinRequest.teamId,
          userId: joinRequest.userId
        );

        /// notify user
        await RealtimeDatabase.setAcceptance(teamId: joinRequest.teamId, userId: joinRequest.userId);

        /// append team to joined teams for user
        await Firestore.appendToJoinedTeams(
          userId: joinRequest.userId,
          teamId: joinRequest.teamId
        );

        /// add user to team members
        await Firestore.appendUserToTeam(teamId: joinRequest.teamId, userId: joinRequest.userId);

        /// delete the join request on the user
        UserModel? user = await CashedUsers.getUser(joinRequest.userId);
        if (user == null) return;
        user.joinRequests.removeWhere((team) => team.teamId == joinRequest.teamId);
        await Firestore.updateJoinRequests(userId: joinRequest.userId, requests: user.joinRequests);

        await getAllRequests();
      }
    );

    HomePageCubit.playRequestsSound = false;
  }
}

