
import 'package:flutter/material.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/screens/team_page/team_page_ui.dart';
import 'package:team_finder/shared/shared_functions.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';


class JoinedTeamCard extends StatelessWidget {
  const JoinedTeamCard({
    Key? key,
    required this.teamCardModel,
    required this.lastMessageTime,
    required this.lastOpenedTime
  }) : super(key: key);

  final TeamCardModel teamCardModel;
  final int lastMessageTime;
  final int lastOpenedTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RoutesHolderCubit.activeTeam = teamCardModel.id;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TeamPagesHolder(
              teamCardModel: teamCardModel
            )
          )
        );
      },
      child: EditedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        shadowColor: Colors.grey[600]!,

        child: Row(
          children: [
            CircleImage(
              radius: 30,
              network: teamCardModel.imageUrl,
              placeHolder: Image.asset("assets/images/team_icon.png"),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    teamCardModel.teamName,
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.cyan[700]
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    teamCardModel.teamCategory,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),

                  if (lastMessageTime > lastOpenedTime)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        getDate(lastMessageTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.purple,
                          fontSize: 14
                        ),
                      ),
                    )
                ],
              ),
            ),

            if (lastMessageTime > lastOpenedTime)
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.purple,
              ),

            const SizedBox(width: 5)
          ],
        ),
      ),
    );
  }
}

