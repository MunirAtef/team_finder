
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/screens/private_chats/private_chat_cubit.dart';
import 'package:team_finder/screens/private_chats/user_chat_card.dart';

class PrivateChats extends StatelessWidget {
  const PrivateChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    PrivateChatCubit cubit = BlocProvider.of<PrivateChatCubit>(context);
    cubit.setInitial();

    return WillPopScope(
      onWillPop: () async {
        PrivateChatCubit.isActive = false;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            )
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              PrivateChatCubit.isActive = false;
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.cyan[700])
          ),
          title: Text(
            "PRIVATE CHATS",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.cyan[700]
            ),
          ),
        ),

        body: BlocBuilder<PrivateChatCubit, PrivateChatState>(
          builder: (BuildContext context, PrivateChatState state) {
            if (state.isLoading) {
              return Padding(
                padding: EdgeInsets.only(bottom: height / 2),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state.contacts.isEmpty) return placeHolder();

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                return UserChatCard(contact: state.contacts[index]);
              },
            );
          }
        ),
      ),
    );
  }



  Widget placeHolder() {
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
              "No chats found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),
          ],
        ),
      );
  }
}
