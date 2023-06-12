
import 'package:flutter/material.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/notifications/acceptance/acceptance_cubit.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';



class AcceptanceCard extends StatelessWidget {
  final String teamId;
  final AcceptanceCubit acceptanceCubit;

  const AcceptanceCard({Key? key, required this.teamId, required this.acceptanceCubit}) : super(key: key);


  Future<TeamCardModel?> getTeamAndUser() async {
    Map<String, dynamic>? team = await Firestore.getDocument("teams", teamId);

    if (team == null) return null;

    return TeamCardModel.fromJson(team);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeamAndUser(),
      builder: (BuildContext context, AsyncSnapshot<TeamCardModel?> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) return const SizedBox();

        TeamCardModel? team = snapshot.data;
        if (team == null) return const SizedBox();

        return EditedContainer(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          shadowColor: Colors.cyan[100]!,

          child: Row(
            children: [
              CircleImage(
                radius: 30,
                network: team.imageUrl,
                placeHolder: Image.asset("assets/images/team_icon.png"),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "",
                      children: [
                        TextSpan(
                          text: "Your request to team ",
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
                        TextSpan(
                            text: " has been accepted",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]
                            )
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

