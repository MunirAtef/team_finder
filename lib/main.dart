
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_team/chat_team_cubit.dart';
import 'package:team_finder/screens/chat_users/chat_users_cubit.dart';
import 'package:team_finder/screens/create_new_team/create_new_team_cubit.dart';
import 'package:team_finder/screens/dashboard/dashboard_cubit.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/screens/login/login_cubit.dart';
import 'package:team_finder/screens/notifications/acceptance/acceptance_cubit.dart';
import 'package:team_finder/screens/notifications/requests_tab/requests_cubit.dart';
import 'package:team_finder/screens/private_chats/private_chat_cubit.dart';
import 'package:team_finder/screens/profile/profile_cubit.dart';
import 'package:team_finder/screens/register/register_cubit.dart';
import 'package:team_finder/screens/register/upload_data_cubit.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/screens/search_for_teams/teams_search_cubit.dart';
import 'package:team_finder/screens/splash/splash_screen.dart';
import 'package:team_finder/screens/team_info_page/team_info_cubit.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TeamFinder());
}

class TeamFinder extends StatelessWidget {
  const TeamFinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider<RegisterCubit>(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider<UploadDataCubit>(
          create: (BuildContext context) => UploadDataCubit(),
        ),
        BlocProvider<RoutesHolderCubit>(
          create: (BuildContext context) => RoutesHolderCubit(),
        ),
        BlocProvider<HomePageCubit>(
          create: (BuildContext context) => HomePageCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(UserModel(id: "", name: ""), context),
        ),
        BlocProvider<NewTeamCubit>(
          create: (BuildContext context) => NewTeamCubit(context),
        ),
        BlocProvider<TeamsSearchCubit>(
          create: (BuildContext context) => TeamsSearchCubit(),
        ),
        BlocProvider<ChatTeamCubit>(
          create: (BuildContext context) => ChatTeamCubit(),
        ),
        BlocProvider<TeamInfoCubit>(
          create: (BuildContext context) => TeamInfoCubit(),
        ),
        BlocProvider<ChatUsersCubit>(
          create: (BuildContext context) => ChatUsersCubit(),
        ),
        BlocProvider<PrivateChatCubit>(
          create: (BuildContext context) => PrivateChatCubit(),
        ),
        BlocProvider<DashboardCubit>(
          create: (BuildContext context) => DashboardCubit(),
        ),
        BlocProvider<RequestCubit>(
          create: (BuildContext context) => RequestCubit(),
        ),
        BlocProvider<AcceptanceCubit>(
          create: (BuildContext context) => AcceptanceCubit(),
        ),
      ],

      child: MaterialApp(
        title: 'Team Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: const SplashScreen(),
      ),
    );
  }
}




