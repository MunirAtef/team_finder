
import 'package:flutter/material.dart';
import 'package:team_finder/screens/notifications/acceptance/acceptance_page_ui.dart';
import 'package:team_finder/screens/notifications/requests_tab/requests_page_ui.dart';


class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "NOTIFICATIONS",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
        ),

        bottom: TabBar(
          controller: tabController,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          indicatorWeight: 3,
          indicatorColor: Colors.cyan[700],
          labelColor: Colors.cyan[700],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16
          ),
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'Acceptance'),
          ],
        ),
      ),


      body: TabBarView(
        controller:tabController,
        children: const [
          RequestsPage(),

          Acceptance(),
        ],
      ),
    );
  }
}

