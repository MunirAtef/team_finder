
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/realtime_database.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/team_info_page/team_info_cubit.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/info_box.dart';
import 'package:team_finder/shared_widgets/user_from_id.dart';

class TeamInfo extends StatelessWidget {
  final TeamCardModel teamCardModel;
  const TeamInfo({Key? key, required this.teamCardModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TeamInfoCubit cubit = BlocProvider.of<TeamInfoCubit>(context);
    cubit.setInitial(context, teamCardModel);

    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        onRefresh: () async {
          cubit.update();
          await Future.delayed(const Duration(seconds: 5));
        },
        child: SafeArea(
          child: BlocBuilder<TeamInfoCubit, TeamInfoState>(
            builder: (BuildContext context, TeamInfoState state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (teamCardModel.imageUrl != null)
                      Image.network(
                        teamCardModel.imageUrl!,
                        width: width,
                        height: width,
                        fit: BoxFit.cover
                      ),

                    const SizedBox(height: 20),

                    Text(
                      teamCardModel.teamName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),

                    const SizedBox(height: 10),

                    descriptionSection(),

                    adminSection(),

                    joinedMembers(cubit),

                    waitedMembersSection(cubit),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InfoBox descriptionSection() {
    return InfoBox(
      title: "DESCRIPTION",
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      childPadding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Text(
        teamCardModel.teamDescription,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      )
    );
  }


  Widget userListTile(TeamInfoCubit infoCubit, String userId, bool isMember) {
    return Row(
      children: [
        UserFromId(userId: userId, marginLeft: 15, cardWidth: 200),

        const Expanded(child: SizedBox()),

        if (!isMember) TextButton(
          onPressed: () async => await infoCubit.acceptOrRemove(userId, true),
          child: const Icon(Icons.add_box_rounded, color: Colors.cyan)
        )
      ],
    );
  }

  Widget adminSection() {
    return InfoBox(
      title: "ADMIN",
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: UserFromId(userId: teamCardModel.adminID, marginLeft: 15, cardWidth: 200)
    );
  }

  Widget joinedMembers(TeamInfoCubit infoCubit) {
    return InfoBox(
      title: "MEMBERS",
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(

        children: [
          if (teamCardModel.membersID.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Text(
                "No members yet",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.red
                ),
              ),
            ),

          for (int i = 0; i < teamCardModel.membersID.length; i++)
            userListTile(infoCubit, teamCardModel.membersID[i], true)
        ],
      )
    );
  }

  Widget waitedMembersList(TeamInfoCubit infoCubit) {
    return FutureBuilder(
      future: RealtimeDatabase.getTeamRequests(adminId: UserData.uid, teamId: teamCardModel.id),

      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) return const SizedBox();

          if (snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Text(
                "No join requests",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.red
                ),
              ),
            );
          }

          return Column(
            children: [
              for (String id in snapshot.data!) userListTile(infoCubit, id, false)
            ],
          );
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: LinearProgressIndicator(),
          )
        );
      },
    );
  }

  Widget waitedMembersSection(TeamInfoCubit infoCubit) {
    if (teamCardModel.adminID != UserData.uid) return const SizedBox();

    return InfoBox(
      title: "JOIN REQUESTS",
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: waitedMembersList(infoCubit)
    );
  }
}


