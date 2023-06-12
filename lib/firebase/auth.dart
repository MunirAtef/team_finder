
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth {
  static Future<User?> registerWithEmail(BuildContext context, String email, String pass) async {
    FirebaseAuth instance = FirebaseAuth.instance;
    try {
      await instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      String msg = e.code.replaceAll("-", " ");
      msg = msg.replaceRange(0, 1, msg[0].toUpperCase());
      toastEnd(msg);
    } catch (e) {
      toastEnd(e.toString());
    }

    return instance.currentUser;
  }


  static Future<User?> loginWithEmail(BuildContext context, String email, String pass) async {

    FirebaseAuth instance = FirebaseAuth.instance;
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      String msg = e.code.replaceAll("-", " ");
      msg = msg.replaceRange(0, 1, msg[0].toUpperCase());
      toastEnd(msg);
    } catch (e) {
      toastEnd(e.toString());
    }

    return instance.currentUser;
  }


  static Future<User?> loginWithGoogle(BuildContext context) async {
    FirebaseAuth instance = FirebaseAuth.instance;

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await instance.signInWithCredential(googleAuthCredential);
      }
    } catch(e) {
      toastEnd("Some error happened");
    }

    return instance.currentUser;
  }


  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception {
      ///
    }
  }

  static Future<void> googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
    } on Exception {
      ///
    }
  }

  static bool isEmailValid(String email) {
    /// Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
  }

  static toastEnd(String msg) {
    Fluttertoast.showToast(msg: msg);
    return null;
  }
}

