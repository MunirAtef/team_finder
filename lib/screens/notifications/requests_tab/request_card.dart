
import 'package:flutter/material.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/join_request.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/notifications/requests_tab/requests_cubit.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';



class RequestCard extends StatelessWidget {
  final JoinRequest joinRequest;
  final RequestCubit requestCubit;

  const RequestCard({Key? key, required this.joinRequest, required this.requestCubit}) : super(key: key);


  Future<NotificationRequestModel?> getTeamAndUser() async {
    UserModel? user = await CashedUsers.getUser(joinRequest.userId);
    Map<String, dynamic>? team = await Firestore.getDocument("teams", joinRequest.teamId);

    if (user == null || team == null) return null;

    return NotificationRequestModel(
      userModel: user,
      teamModel: TeamCardModel.fromJson(team)
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeamAndUser(),
      builder: (BuildContext context, AsyncSnapshot<NotificationRequestModel?> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();

        UserModel? user = snapshot.data?.userModel;
        TeamCardModel? team = snapshot.data?.teamModel;

        if (user == null || team == null) return const SizedBox();

        return EditedContainer(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          shadowColor: Colors.purple[100]!,

          child: Row(
            children: [
              InkResponse(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PersonalProfile(userModel: user)
                    )
                  );
                },
                child: CircleImage(
                  radius: 30,
                  network: user.imageUrl,
                  placeHolder: Image.asset("assets/images/user_icon.png"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "",
                        children: [
                          TextSpan(
                            text: user.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.cyan[800]
                            )
                          ),

                          TextSpan(
                            text: " send you a request to join ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]
                            )
                          ),
                          TextSpan(
                            text: team.teamName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple[800]
                            )
                          ),
                        ]
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Expanded(child: SizedBox()),

                        InkWell(
                          onTap: () async {
                            await requestCubit.acceptUser(context, joinRequest);
                          },
                          child: Text(
                            "ACCEPT",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.purple[700],
                              fontSize: 15
                            ),
                          )
                        ),

                        const SizedBox(width: 20),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


