
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_finder/firebase/auth.dart';
import 'package:team_finder/screens/login/login_ui.dart';


class RoutesHolderState {
  int index;
  bool notificationsOff;

  RoutesHolderState({
    this.index = 0,
    this.notificationsOff = true
  });

  RoutesHolderState clone() {
    return RoutesHolderState(index: index, notificationsOff: notificationsOff);
  }
}

class RoutesHolderCubit extends Cubit<RoutesHolderState> {
  RoutesHolderCubit(): super(RoutesHolderState());

  static String? activeTeam;

  void goToRoute(int index) {
    state.index = index;
    if (index == 3) state.notificationsOff = true;
    update();
  }

  void notification(bool active) {
    state.notificationsOff = active;
    emit(state);
  }

  void update() => emit(state.clone());

  Future<void> signOut(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);
    await Auth.signOut();
    await Auth.googleSignOut();

    navigator..pop()..pushReplacement(
      MaterialPageRoute(builder: (context) => const Login())
    );
  }
}

