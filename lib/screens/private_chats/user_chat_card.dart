
import 'package:flutter/material.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_users/chat_users_ui.dart';
import 'package:team_finder/shared/shared_functions.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_container.dart';


class UserChatCard extends StatelessWidget {
  const UserChatCard({
    Key? key,
    required this.contact
  }) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    UserModel user = contact.user;

    return InkWell(
      onTap: () {
        contact.isActive = false;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatUsers(contact: contact))
        );
      },

      child: EditedContainer(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        shadowColor: Colors.cyan[900]!,

        child: Row(
          children: [
            CircleImage(
              radius: 30,
              network: user.imageUrl,
              placeHolder: Image.asset("assets/images/user_icon.png"),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800]
                    ),
                  ),

                  const SizedBox(height: 5),

                  if (user.bio != null) Text(
                    user.bio!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      getDate(contact.lastMessageTime),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: contact.isActive? Colors.purple: Colors.grey[800]
                      ),
                    ),
                  )
                ],
              ),
            ),

            if (contact.isActive) const CircleAvatar(
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

