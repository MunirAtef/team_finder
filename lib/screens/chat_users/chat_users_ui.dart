
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/chat_users/chat_users_cubit.dart';
import 'package:team_finder/screens/home_page/home_page_cubit.dart';
import 'package:team_finder/screens/private_chats/private_chat_cubit.dart';
import 'package:team_finder/shared_widgets/circle_image.dart';
import 'package:team_finder/shared_widgets/edited_text_field.dart';
import 'package:team_finder/shared_widgets/message_box.dart';

class ChatUsers extends StatelessWidget {
  final Contact contact;
  const ChatUsers({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = contact.user;
    ChatUsersCubit cubit = BlocProvider.of<ChatUsersCubit>(context);
    cubit.setInitial(contact);

    return WillPopScope(
      onWillPop: () async {
        ChatUsersCubit.listener?.pause();
        ChatUsersCubit.userModel = null;
        BlocProvider.of<HomePageCubit>(context).update();
        if (PrivateChatCubit.isActive) {
          BlocProvider.of<PrivateChatCubit>(context).update();
        }
        return true;
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green[300],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)
            )
          ),
          title: Row(
            children: [
              CircleImage(
                radius: 22,
                network: user.imageUrl,
                placeHolder: Image.asset("assets/images/user_icon.png"),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),

                  if (user.bio != null) Text(
                    user.bio!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800]
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatUsersCubit, ChatUsersState>(
                builder: (BuildContext context, ChatUsersState state) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageBox(
                        message: state.messages[index],
                        senderOfPrevious: index == state.messages.length - 1? null: state.messages[index + 1].senderId,
                        isTeamMessage: false,
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
                IconButton(
                  onPressed: () async => await cubit.send(),
                  icon: const Icon(Icons.send)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}




