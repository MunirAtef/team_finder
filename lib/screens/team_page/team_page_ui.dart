
import 'package:flutter/material.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/screens/chat_team/chat_team_ui.dart';
import 'package:team_finder/screens/dashboard/dashboard_ui.dart';
import 'package:team_finder/screens/team_info_page/team_info_ui.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';


class TeamPagesHolder extends StatefulWidget {
  final TeamCardModel teamCardModel;

  const TeamPagesHolder({
    Key? key,
    required this.teamCardModel,
  }) : super(key: key);

  @override
  State<TeamPagesHolder> createState() => _TeamPagesHolderState();
}

class _TeamPagesHolderState extends State<TeamPagesHolder> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TeamCardModel teamCardModel;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    teamCardModel = widget.teamCardModel;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan[600],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
        ),

        title: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TeamInfo(teamCardModel: teamCardModel)
              )
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleImage(
                radius: 20,
                network: teamCardModel.imageUrl,
                placeHolder: Image.asset("assets/images/team_icon.png"),
                margin: const EdgeInsets.all(5),
              ),

              Text(
                teamCardModel.teamName,
                style: const TextStyle(color: Colors.white, fontSize: 22)
              ),

              const SizedBox(width: 5),
            ],
          ),
        ),

        bottom: TabBar(
          controller: tabController,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          indicatorWeight: 3,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16
          ),
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'Dashboard'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ChatTeam(teamModel: teamCardModel),
          Dashboard(teamModel: teamCardModel)
        ],
      ),
    );
  }
}



