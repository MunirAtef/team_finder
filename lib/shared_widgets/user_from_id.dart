
import 'package:flutter/material.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';

class UserFromId extends StatelessWidget {
  final String userId;
  final double? cardWidth;
  final double? cardHeight;
  final double marginLeft;

  const UserFromId({
    Key? key, required this.userId,
    this.cardWidth,
    this.cardHeight,
    this.marginLeft = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = cardWidth ?? MediaQuery.of(context).size.width - 180;
    double height = cardHeight ?? 60;

    return FutureBuilder<UserModel?>(
        future: CashedUsers.getUser(userId),

        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: cardWidth,
              height: height,
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: const LinearProgressIndicator(minHeight: 10)
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          UserModel? user = snapshot.data;
          if (user == null) return const SizedBox();
          
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                PersonalProfile(userModel: user)
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: marginLeft),

                CircleImage(
                  radius: height / 2 - 8,
                  network: user.imageUrl,
                  placeHolder: Image.asset("assets/images/user_icon.png"),
                  margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width,
                      child: Text(
                        user.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: height / 4 + 2,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),

                    SizedBox(height: height / 10),

                    if (user.bio != null) SizedBox(
                      width: width,
                      child: Text(
                        user.bio!,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: height / 5,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}



