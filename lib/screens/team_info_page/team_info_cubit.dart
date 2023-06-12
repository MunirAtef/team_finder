
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/shared/loading_box.dart';
import 'package:team_finder/shared/user_data.dart';

class TeamInfoState {
  late TeamCardModel? teamCardModel;
  List<String> joinRequests = [];

  TeamInfoState({this.teamCardModel, this.joinRequests = const []});

  TeamInfoState clone() {
    return TeamInfoState(
      teamCardModel: teamCardModel,
      joinRequests: joinRequests
    );
  }
}

class TeamInfoCubit extends Cubit<TeamInfoState>{
  TeamInfoCubit(): super(TeamInfoState());
  late BuildContext context;

  void setInitial(BuildContext context, TeamCardModel teamCardModel)  {
    this.context = context;
    state.teamCardModel = teamCardModel;
  }

  void update() => emit(state.clone());

  Future<void> acceptUser(String userId) async {
    /// delete request in realtime database requests
    await RealtimeDatabase.deleteRequest(
      adminId: UserData.uid,
      teamId: state.teamCardModel!.id,
      userId: userId
    );

    /// notify user
    await RealtimeDatabase.setAcceptance(teamId: state.teamCardModel!.id, userId: userId);

    /// append team to joined teams for user
    await Firestore.appendToJoinedTeams(
      userId: userId,
      teamId: state.teamCardModel!.id
    );

    /// add user to team members
    await Firestore.appendUserToTeam(teamId: state.teamCardModel!.id, userId: userId);

    /// delete the join request on the user
    UserModel? user = await CashedUsers.getUser(userId);
    if (user == null) return;
    user.joinRequests.removeWhere((team) => team.teamId == state.teamCardModel!.id);
    await Firestore.updateJoinRequests(userId: userId, requests: user.joinRequests);

    state.teamCardModel!.membersID.add(userId);
    update();
  }

  Future<void> removeUser(String userId) async {}

  Future<void> acceptOrRemove(String userId, bool isAccept) async {
    if (isAccept) {
      HomePageCubit.playRequestsSound = false;

      showLoading(
        title: "ACCEPTING USER...",
        context: context,
        waitFor: () async => await acceptUser(userId)
      );

      HomePageCubit.playRequestsSound = false;
      return;
    }

    showLoading(
      context: context,
      waitFor: () async => await removeUser(userId)
    );
  }
}




