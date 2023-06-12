

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/auth.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/routes_holder/routes_holder_ui.dart';
import 'package:team_finder/shared/user_data.dart';


class LoginState {
  bool passHidden;
  bool loadingEmail;
  bool loadingGoogle;

  LoginState({
    this.passHidden = true,
    this.loadingEmail = false,
    this.loadingGoogle = false
  });

  LoginState change({
    bool? passHidden,
    bool? loadingEmail,
    bool? loadingGoogle
  }) {
    return LoginState(
      passHidden: passHidden ?? this.passHidden,
      loadingEmail: loadingEmail ?? this.loadingEmail,
      loadingGoogle: loadingGoogle ?? this.loadingGoogle
    );
  }
}


class LoginCubit extends Cubit<LoginState> {
  LoginCubit(): super(LoginState());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void changePassVisibility() {
    emit(state.change(passHidden: !state.passHidden));
  }

  Future<void> loginWithEmail(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    String email = emailController.text.trim();
    String pass = passController.text;

    if (!isEmailValid(email)) return toastEnd("Invalid email");
    if (pass.length < 4) return toastEnd("Too short password");

    emit(state.change(loadingEmail: true, loadingGoogle: false));

    User? user = await Auth.loginWithEmail(context, email, pass);

    emit(state.change(loadingEmail: false, loadingGoogle: false));

    if (user != null) {
      UserData.uid = user.uid;
      await UserData.getData();

      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => const RoutesHolder()
      ));
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    emit(state.change(loadingEmail: false, loadingGoogle: true));
    User? user = await Auth.loginWithGoogle(context);
    emit(state.change(loadingEmail: false, loadingGoogle: false));

    if (user != null) {
      UserData.uid = user.uid;
      UserModel? userModel = await Firestore.getUserById(userId: user.uid);
      if (userModel == null) {
        toastEnd("User doesn't register yet");
        await Auth.signOut();
        await Auth.googleSignOut();
        return;
      }
      UserData.userModel = userModel;

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const RoutesHolder())
      );
    }
  }


  // Future<bool> isUserLoggedInWithGoogle() async {
  //   // final FirebaseAuth auth = FirebaseAuth.instance;
  //   final  user = await FirebaseAuth.instance.currentUser();
  //   if (user != null) {
  //     for (final userInfo in user.providerData) {
  //       if (userInfo.providerId == GoogleAuthProvider.providerId) {
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }

  bool isEmailValid(String email) {
    /// Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
  }

  void toastEnd(String msg) => Fluttertoast.showToast(msg: msg);
}



