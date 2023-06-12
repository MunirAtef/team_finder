
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_finder/firebase/auth.dart';
import 'package:team_finder/firebase/firestore.dart';
import 'package:team_finder/models/user_model.dart';
import 'package:team_finder/screens/register/upload_data.dart';
import 'package:team_finder/shared/user_data.dart';

class RegisterState {
  bool passHidden;
  bool confirmPassHidden;
  bool loadingEmail;
  bool loadingGoogle;

  RegisterState({
    this.passHidden = true,
    this.confirmPassHidden = true,
    this.loadingEmail = false,
    this.loadingGoogle = false
  });

  RegisterState change({
    bool? passHidden,
    bool? confirmPassHidden,
    bool? loadingEmail,
    bool? loadingGoogle
  }) {
    return RegisterState(
      passHidden: passHidden ?? this.passHidden,
      confirmPassHidden: confirmPassHidden ?? this.confirmPassHidden,
      loadingEmail: loadingEmail ?? this.loadingEmail,
      loadingGoogle: loadingGoogle ?? this.loadingGoogle
    );
  }
}


class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(): super(RegisterState());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void changePassVisibility() {
    emit(state.change(passHidden: !state.passHidden));
  }

  void changeConfirmPassVisibility() {
    emit(state.change(confirmPassHidden: !state.confirmPassHidden));
  }

  Future<void> registerWithEmail(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    String email = emailController.text.trim();
    String pass = passController.text;
    String confirmPass = confirmPassController.text;

    if (!isEmailValid(email)) return toastEnd("Invalid email");
    if (pass.length < 8) return toastEnd("Weak password");
    if (pass != confirmPass) return toastEnd("Passwords doesn't matching");

    emit(state.change(loadingEmail: true, loadingGoogle: false));
    User? user = await Auth.registerWithEmail(context, email, pass);
    emit(state.change(loadingEmail: false, loadingGoogle: false));

    if (user != null) {
      UserData.uid = user.uid;
      navigator.push(MaterialPageRoute(
        builder: (context) => const UploadData()
      ));
    }
  }

  Future<void> registerWithGoogle(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    emit(state.change(loadingEmail: false, loadingGoogle: true));
    User? user = await Auth.loginWithGoogle(context);
    emit(state.change(loadingEmail: false, loadingGoogle: false));

    if (user != null) {
      UserData.uid = user.uid;
      UserModel? userModel = await Firestore.getUserById(userId: user.uid);

      if (userModel != null) {
        toastEnd("User is already registered");
        await Auth.signOut();
        await Auth.googleSignOut();
        return;
      }

      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => const UploadData()
      ));
    }
  }


  bool isEmailValid(String email) {
    /// Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
  }

  void toastEnd(String msg) => Fluttertoast.showToast(msg: msg);
}

