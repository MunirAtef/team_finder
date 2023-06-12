
import 'package:flutter/material.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/message_model.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_team/chat_team_cubit.dart';
import 'package:team_finder/shared/shared_functions.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';

class MessageBox extends StatelessWidget {
  final MessageModel message;
  final String? senderOfPrevious;
  final bool isTeamMessage;
  const MessageBox({
    Key? key,
    required this.message,
    this.senderOfPrevious,
    required this.isTeamMessage
  }) : super(key: key);


  Widget getUser(double width) {
    return FutureBuilder<UserModel?>(
      future: CashedUsers.getUser(message.senderId),
      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 5, top: 10),
            width: width * 3 / 4,
            decoration: BoxDecoration(
              color: Colors.cyan[800],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)
              )
            ),
            child: InkWell(
              onTap: () => ChatTeamCubit.openProfile(snapshot.data, context),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CircleImage(
                    radius: 15,
                    network: snapshot.data?.imageUrl
                  ),

                  const SizedBox(width: 5),

                  Text(
                    snapshot.data?.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          );
        }
        else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            margin: const EdgeInsets.only(left: 5, top: 10),
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)
                )
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CircleImage(
                  radius: 15,
                  asset: "assets/images/user_icon.png"
              ),
            ),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isMe = UserData.uid == message.senderId;
    bool sameSender = message.senderId == senderOfPrevious;
    double width = MediaQuery.of(context).size.width;
    bool showUserBar = (!isMe && !sameSender) && isTeamMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showUserBar) getUser(width),
        if (showUserBar && !isTeamMessage) const SizedBox(height: 10),

        Row(
          textDirection: isMe? TextDirection.ltr : TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: SizedBox()),

            EditedContainer(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(5, isMe && !sameSender? 10: 0, 5, 1),
              shadowColor: isMe? Colors.cyan[300]!: Colors.grey,
              backgroundColor: isMe? Colors.grey[100]!: Colors.white,
              maxWidth: width * 3 / 4,
              width: showUserBar? double.infinity: null,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe? 10: 0),
                topRight: Radius.circular(isMe? 0: showUserBar? 0: 10),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    getDate(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple[700]
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

