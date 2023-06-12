
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/screens/home_page/joined_team_card.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/shared/user_data.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_ui.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageCubit cubit = BlocProvider.of<HomePageCubit>(context)..setInitial(context);
    RoutesHolderCubit holderCubit = BlocProvider.of<RoutesHolderCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 10,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Row(
          children: [
            InkResponse(
              onTap: () => RoutesHolder.scaffoldKey.currentState?.openDrawer(),
              child: CircleImage(
                radius: 23,
                network: UserData.userModel.imageUrl,
                placeHolder: Image.asset("assets/images/user_icon.png"),
              ),
            ),

            const Expanded(
              child: EditedTextField(
                prefix: Icon(Icons.search),
                hint: 'Search',
                margin: EdgeInsets.symmetric(horizontal: 10),
                maxHeight: 50,
                minHeight: 50,
              )
            ),

            InkResponse(
              onTap: () => cubit.openPrivateChats(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(FontAwesomeIcons.message),

                  BlocBuilder<HomePageCubit, HomePageState>(
                    builder: (BuildContext context, HomePageState state) {
                      if (!state.privateChat) return const SizedBox();
                      return const Positioned(
                        right: -8,
                        top: -8,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.circle_notifications,
                            color: Colors.red,
                            size: 20
                          ),
                        )
                      );
                    }
                  ),
                ],
              )
            ),
          ],
        )
      ),

      body: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (BuildContext context, HomePageState state) {
          return RefreshIndicator(
            backgroundColor: Colors.black,
            onRefresh: () async => await cubit.onRefresh(),
            child: ListView(
              physics: const BouncingScrollPhysics(),

              children: [
                placeHolder(holderCubit),

                for (int i = 0; i < state.teamsCard.length; i++)
                  JoinedTeamCard(
                    teamCardModel: state.teamsCard[i],
                    lastMessageTime: state.teamsCard[i].lastMessageTime,
                    lastOpenedTime: state.teamsCard[i].lastSeenMessage,
                  ),


                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.cyan)
                    ),
                  ),

                const SizedBox(height: 500)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget placeHolder(RoutesHolderCubit holderCubit) {
    if (UserData.userModel.joinedTeams.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              "assets/images/not_found.gif",
              fit: BoxFit.cover
            ),

            const SizedBox(height: 20),

            const Text(
              "You didn't joined any teams yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),

            TextButton(
              onPressed: () => holderCubit.goToRoute(2),

              child: const Text(
                "JOIN TO START",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                // color: Colors.cyan[700]
                ),
              )
            )
          ],
        ),
      );
    }

    return const SizedBox(height: 10);
  }
}

