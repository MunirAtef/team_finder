
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/team_card_model.dart';
import 'package:team_finder/shared_widgets/message_box.dart';
import 'package:team_finder/screens/chat_team/chat_team_cubit.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_cubit.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';



class ChatTeam extends StatelessWidget {
  final TeamCardModel teamModel;
  const ChatTeam({Key? key, required this.teamModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatTeamCubit cubit = BlocProvider.of<ChatTeamCubit>(context);
    cubit.setInitial(teamModel);

    return WillPopScope(
      onWillPop: () async {
        RoutesHolderCubit.activeTeam = null;
        BlocProvider.of<HomePageCubit>(context).update();
        return true;
      },

      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatTeamCubit, ChatTeamState>(
              builder: (BuildContext context, ChatTeamState state) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageBox(
                      message: state.messages[index],
                      senderOfPrevious: index == state.messages.length - 1? null: state.messages[index + 1].senderId,
                      isTeamMessage: true,
                    );
                  },
                );
              },
            )
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: EditedTextField(
                  controller: cubit.chatController,
                  hint: "Message",
                  maxLines: 3,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10)
                  ),
                  prefix: Icon(Icons.message_outlined, color: Colors.cyan[700]),
                  maxHeight: 100,
                ),
              ),
              BlocBuilder<ChatTeamCubit, ChatTeamState>(
                builder: (BuildContext context, ChatTeamState state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()
                      ),
                    );
                  }

                  return IconButton(
                      onPressed: () async => await cubit.send(),
                      icon: const Icon(Icons.send)
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

