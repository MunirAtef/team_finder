
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/general/cashed_users.dart';
import 'package:team_finder/models/contact.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/shared/user_data.dart';


class PrivateChatState {
  bool isLoading;
  List<Contact> contacts;

  PrivateChatState({
    this.isLoading = false,
    this.contacts = const []
  });

  PrivateChatState clone() => PrivateChatState(
    isLoading: isLoading,
    contacts: contacts
  );
}

class PrivateChatCubit extends Cubit<PrivateChatState> {
  PrivateChatCubit(): super(PrivateChatState());

  void setInitial() {
    getContacts();
    isActive = true;
  }

  static bool isActive = false;

  void update() {
    sortContacts(state.contacts);
    emit(state.clone());
  }

  void sortContacts(List<Contact> contacts) {
    contacts.sort((contact1, contact2) =>
      contact2.lastMessageTime - contact1.lastMessageTime);
  }

  Future<void> getContacts() async {
    state.isLoading = true;
    emit(state.clone());

    Map<String, dynamic>? contacts = (await FirebaseFirestore.instance
      .collection("users_contacts").doc(UserData.uid).get()).data();

    if (contacts == null) {
      state.isLoading = false;
      emit(state.clone());
      return;
    }

    List<Contact> contactsList = [];

    for (String key in contacts.keys) {
      UserModel? user = await CashedUsers.getUser(key);
      if (user == null) continue;

      contactsList.add(Contact(
        user: user,
        lastMessageTime: (contacts[key] as int?) ?? 0,
        isActive: UserData.incomingChats[key] != null
      ));
    }

    sortContacts(contactsList);

    state.contacts = contactsList;
    state.isLoading = false;
    emit(state.clone());
  }

  Future<void> updateContacts() async {
    List<Contact> newContacts = state.contacts;
    List<String> usersId = newContacts.map((e) => e.user.id).toList();
    for (String key in UserData.incomingChats.keys) {
      int userIndex = usersId.indexOf(key);
      if (userIndex == -1) {
        UserModel? user = await CashedUsers.getUser(key);
        if (user == null) return;
        newContacts.add(Contact(
          user: user,
          lastMessageTime: UserData.incomingChats[key] ?? 0,
          isActive: UserData.incomingChats[key] != null
        ));
      } else {
        newContacts[userIndex].lastMessageTime = UserData.incomingChats[key] ?? 0;
        newContacts[userIndex].isActive = UserData.incomingChats[key] != null;
      }
    }

    sortContacts(newContacts);
    emit(state.clone());
  }
}

