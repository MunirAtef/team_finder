
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:team_finder/firebase/auth.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/create_new_team/create_new_team_ui.dart';
import 'package:team_finder/screens/home_page/home_page_ui.dart';
import 'package:team_finder/screens/notifications/notifications_ui.dart';
import 'package:team_finder/screens/profile/profile_ui.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/screens/search_for_teams/teams_search_ui.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';



class RoutesHolder extends StatefulWidget {
  const RoutesHolder({super.key});
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  State<RoutesHolder> createState() => _RoutesHolderState();
}

class _RoutesHolderState extends State<RoutesHolder> {

  @override
  Widget build(BuildContext context) {
    RoutesHolderCubit holderCubit = BlocProvider.of<RoutesHolderCubit>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<Widget> routes = [const HomePage(), const NewTeam(), const TeamsSearch(), const Notifications()];


    return BlocBuilder<RoutesHolderCubit, RoutesHolderState>(
      builder: (BuildContext context, RoutesHolderState state) {
        return Scaffold(
          key: RoutesHolder.scaffoldKey,

          body: routes[state.index],

          bottomNavigationBar: SnakeNavigationBar.color(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 60,
            backgroundColor: Colors.purple[50],

            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey[700],
            snakeViewColor: Colors.cyan,
            snakeShape: SnakeShape.circle,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13
            ),

            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12
            ),

            showUnselectedLabels: true,
            showSelectedLabels: true,

            currentIndex: state.index,
            onTap: (index) => holderCubit.goToRoute(index),

            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.group_add),
                label: 'New Team'
              ),

              const BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/team_search.jpg")),
                label: 'Teams Search'
              ),

              BottomNavigationBarItem(
                icon: state.notificationsOff? const Icon(Icons.notifications):
                const Icon(Icons.notifications_active, color: Colors.red),
                label: 'Notifications'
              )
            ],
          ),

          drawer: drawer(
            context: context,
            holderCubit: holderCubit,
            width: width,
            height: height
          ),
        );
      },
    );
  }


  Container drawer({
    required BuildContext context,
    required RoutesHolderCubit holderCubit,
    required double width,
    required double height
  }) {
    return Container(
      width: width * 3 / 4,
      height: height,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PersonalProfile(
                          userModel: UserData.userModel
                        )
                      )
                    );
                  },
                  child: CircleImage(
                    radius: 80,
                    network: UserData.userModel.imageUrl,
                    placeHolder: Image.asset("assets/images/user_icon.png"),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  UserData.userModel.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),

                const SizedBox(height: 5),

                if (UserData.userModel.bio != null) Text(
                  UserData.userModel.bio!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: width * 3 / 4,
              color: Colors.grey[300],
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  OutlinedButton(
                    onPressed: () async {
                      NavigatorState navigator = Navigator.of(context);

                      UserModel? developer = await CashedUsers.getUser("NH5A3dj4u7f1LXCMXi4dctjdPBs2");
                      if (developer == null) return;

                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) => PersonalProfile(
                            userModel: developer
                          )
                        )
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black)
                    ),
                    child: SizedBox(
                      width: width * 3 / 4 - 80,
                      child: const Center(
                        child: Text(
                          "CONTACT DEVELOPER",
                          style: TextStyle(fontWeight: FontWeight.w600)
                        )
                      ),
                    )
                  ),

                  OutlinedButton(
                    onPressed: () async {
                      NavigatorState navigator = Navigator.of(context);

                      UserModel? developer = await CashedUsers.getUser("NH5A3dj4u7f1LXCMXi4dctjdPBs2");
                      if (developer == null) return;

                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) => PersonalProfile(
                            userModel: developer
                          )
                        )
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black)
                    ),
                    child: SizedBox(
                      width: width * 3 / 4 - 80,
                      child: const Center(
                        child: Text(
                          "ABOUT US",
                          style: TextStyle(fontWeight: FontWeight.w600)
                        )
                      ),
                    )
                  ),

                  OutlinedButton(
                    onPressed: () async {
                      await Auth.signOut();
                      await Auth.googleSignOut();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black)
                    ),
                    child: SizedBox(
                      width: width * 3 / 4 - 80,
                      child: const Center(
                        child: Text(
                          "LOG OUT",
                          style: TextStyle(fontWeight: FontWeight.w600)
                        )
                      ),
                    )
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}

