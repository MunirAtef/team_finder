
import 'package:flutter/material.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/chat_users/chat_users_ui.dart';
import 'package:team_finder/screens/search_for_teams/teams_search_cubit.dart';
import 'package:team_finder/shared/shared_functions.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';
import 'package:team_finder/shared_widgets/user_from_id.dart';



class TeamCard extends StatelessWidget {
  final double width;
  final TeamCardModel teamCard;
  final List<UserModel>? members;
  final TeamsSearchCubit cubit;

  const TeamCard({
    Key? key,
    required this.width,
    required this.teamCard,
    required this.cubit,
    this.members
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return EditedContainer(
      width: width,

      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      shadowColor: Colors.grey[900]!,

      child: Column(
        children: [
          cardHeader(),

          adminSection(context),

          cardDescription(),

          skillsSection(teamCard.requiredSkills),

          buttonsSection(context),
        ],
      ),
    );
  }

  Container cardHeader() => Container(
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      )
    ),

    child: Row(
      children: [
        CircleImage(
          radius: 32,
          network: teamCard.imageUrl,
          placeHolder: Image.asset("assets/images/team_icon.png"),
          borderColor: Colors.white,
          margin: const EdgeInsets.fromLTRB(15, 5, 5, 5),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamCard.teamName,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),

            const SizedBox(height: 5),

            Text(
              teamCard.teamCategory,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),

            const SizedBox(height: 5),

            Text(
              getDate(teamCard.creationDate),
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        )
      ],
    ),
  );


  Container adminSection(BuildContext context) => Container(
    width: width,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    padding: const EdgeInsets.symmetric(horizontal: 10),

    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5))
    ),
    child: Row(
      children: [
        const Text(
          "Admin",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600
          )
        ),

        const SizedBox(height: 30, child: VerticalDivider(thickness: 2)),

        UserFromId(userId: teamCard.adminID, cardWidth: width - 170, cardHeight: 50),
      ],
    ),
  );


  Container cardDescription() => Container(
    width: width,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    padding: const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: const BorderRadius.all(Radius.circular(5))
    ),
    child: Text(
      teamCard.teamDescription,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600
      ),
    ),
  );


  Widget skillsSection(List<String>? skills) {
    if (skills == null || skills.isEmpty) return const SizedBox();
    return Column(
      children: [
        const Divider(color: Colors.black, thickness: 2, height: 2),

        const SizedBox(height: 10),

        const Text(
          "Required Skills",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),

        const SizedBox(height: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < skills.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                color: i % 2 == 0? Colors.purple[100] : Colors.purple[50],
                child: Text(
                  skills[i],

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
          ],
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget buttonsSection(context) {
    bool isRequested = UserData.getJoinRequests().contains(teamCard.id);
    bool isMe = teamCard.adminID == UserData.uid;

    if (isMe) return const SizedBox(height: 15);

    return Column(
      children: [
        const Divider(color: Colors.black, thickness: 2, height: 2),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                NavigatorState navigator = Navigator.of(context);
                UserModel? userModel = await CashedUsers.getUser(teamCard.adminID);
                if (userModel == null) return;

                navigator.push(MaterialPageRoute(
                  builder: (context) => ChatUsers(
                    contact: Contact(
                      user: userModel,
                      lastMessageTime: 0
                    )
                  )
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan[800],
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)
                  )
                )
              ),

              child: SizedBox(
                width: width / 2 - 50,
                child: const Center(child: Text("CONTACT ADMIN", style: TextStyle(color: Colors.white)))
              ),
            ),

            const SizedBox(width: 1),

            ElevatedButton(
              onPressed: () async => await cubit.requestOrUndo(
                teamCard.adminID, teamCard.id, !isRequested, context),

              style: ElevatedButton.styleFrom(
                backgroundColor: isRequested? Colors.grey[600]: Colors.cyan[500],
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  )
                )
              ),
              child: SizedBox(
                width: width / 2 - 50,
                child: Center(
                  child: Text(
                    isRequested? "UNDO REQUEST": "JOIN REQUEST",
                    style: const TextStyle(color: Colors.white),
                  )
                )
              ),
            ),
          ],
        ),

        const SizedBox(height: 15)
      ],
    );
  }
}

