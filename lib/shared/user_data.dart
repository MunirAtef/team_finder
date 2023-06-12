
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team_finder/models/user_model.dart';

class UserData {
  static String uid = "";
  static late UserModel userModel;
  static List<String>? joinRequestsID;

  static Map<String, int> incomingChats = {};
  static List<String> acceptance = [];
  static Map<String, dynamic> requests = {};


  static Future<void> getData() async {
    DocumentReference<Map<String, dynamic>> ref
      = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot = await ref.get();
      userModel = UserModel.fromJson(querySnapshot.data()!);
    } catch (e) {
      ///
    }
  }

  static List<String> getJoinRequests() {
    if (joinRequestsID != null) return joinRequestsID!;
    joinRequestsID = List.from(userModel.joinRequests.map((e) => e.teamId).toList());
    return joinRequestsID!;
  }
}


Map<String, Icon> linksIcons = {
  "linkedin": const Icon(FontAwesomeIcons.linkedin, color: Colors.blue),
  "whatsapp": const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
  "github": const Icon(FontAwesomeIcons.github, color: Colors.black),
  "twitter": const Icon(FontAwesomeIcons.twitter, color: Colors.blue),
  "facebook": const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
  "instagram": const Icon(FontAwesomeIcons.instagram, color: Colors.purple),
};

final List<String> categories = [
  "Mobile Development",
  "Desktop Development",
  "Web Development",
  "Web Design",
  "Project Management",
  "Graphic Design",
  "Marketing",
  "Writing",
  "Video Editing",
  "Other"
];


